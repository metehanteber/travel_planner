# -*- coding: utf-8 -*-
import os
import warnings
import pandas as pd
import numpy as np
from datetime import datetime
from dateutil.relativedelta import relativedelta
from sqlalchemy import create_engine, text

from statsmodels.tsa.arima.model import ARIMA
from sklearn.preprocessing import MinMaxScaler

# Keras ve TensorFlow loglarini/uyarilarini temiz tutmak icin
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2'
os.environ['TF_ENABLE_ONEDNN_OPTS'] = '0'
warnings.filterwarnings('ignore')

from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import LSTM, Dense, Input

# 1. VERITABANI BAGLANTISI
DB_USER = "postgres"
DB_PASS = "1234" # Kendi sifrenle degistir
DB_HOST = "localhost"
DB_NAME = "travel_planner_db"
engine = create_engine(f'postgresql+psycopg2://{DB_USER}:{DB_PASS}@{DB_HOST}/{DB_NAME}')

# =====================================================================
# YARDIMCI FONKSIYONLAR
# =====================================================================

def create_lstm_dataset(dataset, look_back=3):
    """LSTM modeli icin veriyi pencerelere (window) boler."""
    X, Y = [], []
    for i in range(len(dataset) - look_back):
        a = dataset[i:(i + look_back), 0]
        X.append(a)
        Y.append(dataset[i + look_back, 0])
    return np.array(X), np.array(Y)

def run_ai_engine(ts_data, months_to_predict):
    """Saf ARIMA+LSTM Hibrit tahmin motoru. Veriyi alir, tahmini doner."""
    # 1. ARIMA
    arima_model = ARIMA(ts_data, order=(5, 1, 0)) 
    arima_fit = arima_model.fit()
    
    arima_fitted = arima_fit.predict(start=1, end=len(ts_data)-1)
    residuals = ts_data[1:] - arima_fitted

    # 2. LSTM
    scaler = MinMaxScaler(feature_range=(-1, 1))
    residuals_scaled = scaler.fit_transform(residuals.reshape(-1, 1))

    look_back = 3
    if len(residuals_scaled) <= look_back:
        # Eger veri LSTM'in ogrenmesi icin cok azsa (orn: yillik enflasyon), sadece ARIMA don
        return arima_fit.forecast(steps=months_to_predict)

    X_train, y_train = create_lstm_dataset(residuals_scaled, look_back)
    X_train = np.reshape(X_train, (X_train.shape[0], 1, X_train.shape[1]))

    lstm_model = Sequential()
    lstm_model.add(Input(shape=(1, look_back)))
    lstm_model.add(LSTM(50, activation='relu'))
    lstm_model.add(Dense(1))
    lstm_model.compile(loss='mean_squared_error', optimizer='adam')
    
    lstm_model.fit(X_train, y_train, epochs=100, batch_size=1, verbose=0)

    # 3. TAHMIN (FORECAST)
    arima_forecast = arima_fit.forecast(steps=months_to_predict)
    
    lstm_inputs = residuals_scaled[-look_back:].reshape(1, 1, look_back)
    lstm_pred_scaled = []
    
    for _ in range(months_to_predict):
        pred = lstm_model.predict(lstm_inputs, verbose=0)
        lstm_pred_scaled.append(pred[0,0])
        lstm_inputs = np.array([[[lstm_inputs[0, 0, 1], lstm_inputs[0, 0, 2], pred[0,0]]]])

    lstm_forecast = scaler.inverse_transform(np.array(lstm_pred_scaled).reshape(-1, 1)).flatten()
    
    # ARIMA + LSTM
    return arima_forecast + lstm_forecast

# =====================================================================
# SEHIR BAZLI TAHMINLER (Turist Sayisi & Konaklama Fiyati)
# =====================================================================
def process_city_metrics(city_id, country_id, metric_type, months_to_predict=6):
    col_name = "tourist_count" if metric_type == "TouristCount" else "avg_accommodation_price"
    
    query = f"SELECT date_recorded, {col_name} as val FROM tourism_metrics WHERE city_id = {city_id} ORDER BY date_recorded ASC"
    with engine.connect() as conn:
        df = pd.read_sql(text(query), conn)
    
    if len(df) < 12:
        return # Yetersiz veri
        
    ts_data = df['val'].values.astype('float64')
    final_forecast = run_ai_engine(ts_data, months_to_predict)
    
    last_date = df['date_recorded'].iloc[-1]
    
    for i in range(months_to_predict):
        # Eger aylik veriyse aylari artir, yillik veriyse yillari (Turizm ayliktir)
        forecast_date = last_date + relativedelta(months=i+1)
        pred_value = round(final_forecast[i], 2)
        if pred_value < 0: pred_value = 0 # Turist sayisi ve fiyat eksi olamaz
            
        insert_q = f"""
            INSERT INTO forecasts (country_id, city_id, metric_type, forecast_date, predicted_value, model_used, created_at, guid, is_deleted)
            VALUES ({country_id}, {city_id}, '{metric_type}', '{forecast_date.strftime('%Y-%m-%d')}', {pred_value}, 'ARIMA+LSTM', CURRENT_TIMESTAMP, gen_random_uuid(), false)
        """
        with engine.begin() as conn:
            conn.execute(text(insert_q))

# =====================================================================
# ULKE BAZLI TAHMINLER (Enflasyon & Doviz Kuru)
# =====================================================================
def process_country_metrics(country_id, metric_type, steps_to_predict=6):
    if metric_type == "Inflation":
        query = f"SELECT date_recorded, rate as val FROM inflation_rates WHERE country_id = {country_id} ORDER BY date_recorded ASC"
    else:
        query = f"SELECT date_recorded, rate as val FROM exchange_rates WHERE country_id = {country_id} ORDER BY date_recorded ASC"
        
    with engine.connect() as conn:
        df = pd.read_sql(text(query), conn)
    
    if len(df) < 5: 
        return # Enflasyon genelde yillik olur, en az 5 yillik/aylik veri lazim
        
    ts_data = df['val'].values.astype('float64')
    final_forecast = run_ai_engine(ts_data, steps_to_predict)
    
    last_date = df['date_recorded'].iloc[-1]
    
    for i in range(steps_to_predict):
        if metric_type == "Inflation":
            # Enflasyon genelde yillik tutulur, yillari artir
            forecast_date = last_date + relativedelta(years=i+1)
        else:
            # Doviz kuru aylik/gunluk tutulur, aylari artir (Senaryomuza gore)
            forecast_date = last_date + relativedelta(months=i+1)
            
        pred_value = round(final_forecast[i], 2)
        # Doviz kuru sifirin altina dusemez ama enflasyon (deflasyon) dusebilir
        if metric_type == "ExchangeRate" and pred_value < 0: 
            pred_value = 0.01 
            
        # Ulke bazli oldugu icin city_id NULL olarak gonderilir
        insert_q = f"""
            INSERT INTO forecasts (country_id, city_id, metric_type, forecast_date, predicted_value, model_used, created_at, guid, is_deleted)
            VALUES ({country_id}, NULL, '{metric_type}', '{forecast_date.strftime('%Y-%m-%d')}', {pred_value}, 'ARIMA+LSTM', CURRENT_TIMESTAMP, gen_random_uuid(), false)
        """
        with engine.begin() as conn:
            conn.execute(text(insert_q))


# =====================================================================
# ANA CALISTIRICI (MAIN)
# =====================================================================
if __name__ == "__main__":
    print("--- TravelForecast AI Motoru Baslatiliyor ---")
    
    # --- 1. SEHIR BAZLI METRIKLERI ISLE ---
    print("\n[ASAMA 1] Sehir Bazli Turizm Metrikleri Hesaplaniyor...")
    cities_q = "SELECT id, country_id FROM cities WHERE is_deleted = false"
    with engine.connect() as conn:
        cities_df = pd.read_sql(text(cities_q), conn)
        
    if not cities_df.empty:
        city_metrics = ["TouristCount", "AccommodationPrice"]
        for _, row in cities_df.iterrows():
            c_id = row['id']
            cnt_id = row['country_id']
            for metric in city_metrics:
                # Eski veriyi temizle
                del_q = f"DELETE FROM forecasts WHERE city_id = {c_id} AND metric_type = '{metric}'"
                with engine.begin() as conn: conn.execute(text(del_q))
                
                print(f"-> Sehir ID: {c_id} | Metrik: {metric} isleniyor...")
                process_city_metrics(city_id=c_id, country_id=cnt_id, metric_type=metric, months_to_predict=6)
                
    # --- 2. ULKE BAZLI METRIKLERI ISLE ---
    print("\n[ASAMA 2] Ulke Bazli Makroekonomik Metrikler Hesaplaniyor...")
    countries_q = "SELECT id FROM countries WHERE is_deleted = false"
    with engine.connect() as conn:
        countries_df = pd.read_sql(text(countries_q), conn)
        
    if not countries_df.empty:
        country_metrics = ["Inflation", "ExchangeRate"]
        for _, row in countries_df.iterrows():
            cnt_id = row['id']
            for metric in country_metrics:
                # Eski veriyi temizle (Ulke bazli tahminlerin city_id'si NULL olur)
                del_q = f"DELETE FROM forecasts WHERE country_id = {cnt_id} AND city_id IS NULL AND metric_type = '{metric}'"
                with engine.begin() as conn: conn.execute(text(del_q))
                
                print(f"-> Ulke ID: {cnt_id} | Metrik: {metric} isleniyor...")
                process_country_metrics(country_id=cnt_id, metric_type=metric, steps_to_predict=6)

    print("\n--- TUM ISLEMLER BASARIYLA TAMAMLANDI! ---")