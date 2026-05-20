
import os
import warnings
import pandas as pd
import numpy as np
from datetime import datetime
from dateutil.relativedelta import relativedelta
from sqlalchemy import create_engine
from statsmodels.tsa.arima.model import ARIMA
from sklearn.preprocessing import MinMaxScaler

# Keras ve TensorFlow loglarýný/uyarýlarýný temiz tutmak için
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2'
warnings.filterwarnings('ignore')

from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import LSTM, Dense, Input

# 1. VERÝTABANI BAÐLANTISI (Kendi þifreni buraya yazmalýsýn)
# SQLAlchemy ile PostgreSQL'e baðlanýyoruz
DB_USER = "postgres"
DB_PASS = "123456" # Kendi þifrenle deðiþtir
DB_HOST = "localhost"
DB_NAME = "tourism_forecast_db"
engine = create_engine(f'postgresql+psycopg2://{DB_USER}:{DB_PASS}@{DB_HOST}/{DB_NAME}')

def create_lstm_dataset(dataset, look_back=3):
    """LSTM modeli için veriyi pencerelere (window) böler."""
    X, Y = [], []
    for i in range(len(dataset) - look_back):
        a = dataset[i:(i + look_back), 0]
        X.append(a)
        Y.append(dataset[i + look_back, 0])
    return np.array(X), np.array(Y)

def run_hybrid_forecast(city_id, metric_type="TouristCount", months_to_predict=6):
    print(f"\n--- Þehir ID: {city_id} | Metrik: {metric_type} için Hibrit Model Baþlatýlýyor ---")
    
    # 2. VERÝ ÇEKME
    # tourism_metrics tablosundan ilgili þehrin verilerini tarihe göre sýralý çekiyoruz
    query = f"""
        SELECT date_recorded, tourist_count 
        FROM tourism_metrics 
        WHERE city_id = {city_id} 
        ORDER BY date_recorded ASC
    """
    df = pd.read_sql(query, engine)
    
    if len(df) < 12:
        print(f"Uyarý: Þehir ID {city_id} için yeterli veri yok (Minimum 12 ay gerekli). Atlanýyor.")
        return

    df.set_index('date_recorded', inplace=True)
    ts_data = df['tourist_count'].values.astype('float64')

    # 3. ARIMA MODELÝ (Lineer Trend Tahmini)
    # Mevsimselliði de hesaba katmak için p,d,q parametrelerini veriyoruz
    print("1/3 -> ARIMA Modeli Eðitiliyor...")
    arima_model = ARIMA(ts_data, order=(5, 1, 0)) 
    arima_fit = arima_model.fit()
    
    # ARIMA'nýn geçmiþ veriler üzerindeki tahminleri (Fitted values)
    arima_fitted = arima_fit.predict(start=1, end=len(ts_data)-1)
    
    # Hatalarýn (Residuals) Hesaplanmasý: Gerçek Veri - ARIMA Tahmini
    # Ýlk veriyi shift ettiðimiz için ts_data'nýn 1'den sonrasýný alýyoruz
    residuals = ts_data[1:] - arima_fitted

    # 4. LSTM MODELÝ (Hatalarý Öðrenme)
    print("2/3 -> LSTM Modeli Eðitiliyor...")
    scaler = MinMaxScaler(feature_range=(-1, 1))
    residuals_scaled = scaler.fit_transform(residuals.reshape(-1, 1))

    look_back = 3
    X_train, y_train = create_lstm_dataset(residuals_scaled, look_back)
    X_train = np.reshape(X_train, (X_train.shape[0], 1, X_train.shape[1]))

    # Keras Sequential Yapýsý
    lstm_model = Sequential()
    lstm_model.add(Input(shape=(1, look_back)))
    lstm_model.add(LSTM(50, activation='relu'))
    lstm_model.add(Dense(1))
    lstm_model.compile(loss='mean_squared_error', optimizer='adam')
    
    # Loglarý gizleyerek sessizce (verbose=0) eðitiyoruz
    lstm_model.fit(X_train, y_train, epochs=100, batch_size=1, verbose=0)

    # 5. GELECEK TAHMÝNÝ (FORECASTING)
    print("3/3 -> Gelecek 6 Ay Ýçin Tahminler Üretiliyor...")
    
    # ARIMA ile gelecek tahminleri
    arima_forecast = arima_fit.forecast(steps=months_to_predict)
    
    # LSTM ile gelecek hatalarýn (residuals) tahmini
    lstm_inputs = residuals_scaled[-look_back:].reshape(1, 1, look_back)
    lstm_pred_scaled = []
    
    for _ in range(months_to_predict):
        pred = lstm_model.predict(lstm_inputs, verbose=0)
        lstm_pred_scaled.append(pred[0,0])
        # Bir sonraki adým için input'u güncelle
        lstm_inputs = np.array([[[lstm_inputs[0, 0, 1], lstm_inputs[0, 0, 2], pred[0,0]]]])

    # Ölçeklenen veriyi geri çeviriyoruz
    lstm_forecast = scaler.inverse_transform(np.array(lstm_pred_scaled).reshape(-1, 1)).flatten()

    # HÝBRÝT SONUÇ: ARIMA Tahmini + LSTM Hata Tahmini
    final_forecast = arima_forecast + lstm_forecast

    # 6. VERÝTABANINA KAYDETME (Forecasts Tablosu)
    last_date = df.index[-1]
    
    for i in range(months_to_predict):
        forecast_date = last_date + relativedelta(months=i+1)
        pred_value = round(final_forecast[i], 2)
        
        # Eðer negatif bir tahmin çýkarsa 0'a yuvarla (Turist sayýsý eksi olamaz)
        if pred_value < 0: pred_value = 0
            
        # SQL Insert Sorgusu
        insert_query = f"""
            INSERT INTO forecasts (city_id, metric_type, forecast_date, predicted_value, model_used, created_at, guid, is_deleted)
            VALUES ({city_id}, '{metric_type}', '{forecast_date.strftime('%Y-%m-%d')}', {pred_value}, 'ARIMA+LSTM', CURRENT_TIMESTAMP, gen_random_uuid(), false)
        """
        with engine.begin() as conn:
            conn.execute(insert_query)
            
        print(f"-> {forecast_date.strftime('%Y-%m')} Tahmini: {pred_value} veritabanýna iþlendi.")

if __name__ == "__main__":
    print("--- TravelForecast AI Motoru Baþlatýlýyor ---")
    
    # Veritabanýndaki tüm þehir ID'lerini çekiyoruz
    cities_query = "SELECT id, name FROM cities WHERE is_deleted = false"
    cities_df = pd.read_sql(cities_query, engine)
    
    if cities_df.empty:
        print("Uyarý: Veritabanýnda kayýtlý þehir bulunamadý. Lütfen önce .NET uygulamasýný çalýþtýrarak tablolarýn dolmasýný bekleyin.")
    else:
        for index, row in cities_df.iterrows():
            city_id = row['id']
            city_name = row['name']
            
            # Daha önce tahmin yapýlmýþsa temizleyebiliriz (Ýsteðe baðlý, veriyi güncel tutmak için)
            delete_old_query = f"DELETE FROM forecasts WHERE city_id = {city_id} AND metric_type = 'TouristCount'"
            with engine.begin() as conn:
                conn.execute(delete_old_query)
            
            # Modeli çalýþtýr
            run_hybrid_forecast(city_id=city_id, metric_type="TouristCount", months_to_predict=6)