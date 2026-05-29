using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json.Linq;
using System;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using TravelPlanner.Business.Repo;
using TravelPlanner.Core;
using TravelPlanner.Data.Entities;

namespace TravelPlanner.Business.Services
{
    public class TourismDataWorker : BackgroundService
    {
        private readonly ILogger<TourismDataWorker> _logger;
        private readonly HttpClient _httpClient;

        public TourismDataWorker(ILogger<TourismDataWorker> logger)
        {
            _logger = logger;
            _httpClient = new HttpClient();
        }

        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {
            _logger.LogInformation("Global Turizm Verisi Çekme Servisi başlatıldı...");

            while (!stoppingToken.IsCancellationRequested)
            {
                try
                {
                    IRepository<TourismMetric> tourismMetricsRepo = Repository<TourismMetric>.Create();
                    ServicesHelper.ProcessNorwayTourismMetrics(ref tourismMetricsRepo);
                    ServicesHelper.ProcessSpainTourismMetrics(ref tourismMetricsRepo);
                    ServicesHelper.ProcessTurkeyTourismMetrics(ref tourismMetricsRepo);
                    _logger.LogInformation("Ülkelere özel veri kaynakları taranıyor...");

                    // Türkiye ve Rusya için (Dosya bazlı)
                    ProcessTurkeyData();
                    ProcessRussiaData();

                    _logger.LogInformation("Tüm ülkelerin turizm verileri başarıyla senkronize edildi!");
                }
                catch (Exception ex)
                {
                    _logger.LogError($"Veri toplama motorunda genel bir hata oluştu: {ex.Message}");
                }

                // Turizm verileri aylık yayınlanır, haftada bir kontrol etmek yeterlidir
                await Task.Delay(TimeSpan.FromDays(7), stoppingToken);
            }
        }

        #region İspanya (INE API - JSON)
        private async Task ProcessSpainData(CancellationToken stoppingToken)
        {
            try
            {
                _logger.LogInformation("İspanya (INE) verileri çekiliyor...");

                // INE'nin Barselona ve Madrid otel konaklama istatistikleri endpoint'i (Örnek Kod: 32197)
                string apiUrl = "https://servicios.ine.es/wapi/v1/json/es/data/32197";
                var response = await _httpClient.GetStringAsync(apiUrl, stoppingToken);
                var data = JObject.Parse(response);

                var cityRepo = Repository<City>.Create();
                var tourismRepo = Repository<TourismMetric>.Create();

                var madrid = cityRepo.GetQueryable(x => x.Name == "Madrid").FirstOrDefault();
                var barcelona = cityRepo.GetQueryable(x => x.Name == "Barselona").FirstOrDefault();

                if (data["Data"] != null)
                {
                    foreach (var item in data["Data"])
                    {
                        string rawDate = item["Date"].AsString(); // Örn: 2024M05
                        if (rawDate.Length == 7 && rawDate.Contains("M"))
                        {
                            int year = rawDate.Substring(0, 4).Convert<int>() ?? 2024;
                            int month = rawDate.Substring(5, 2).Convert<int>() ?? 1;
                            DateTime dateRecorded = new DateTime(year, month, 1);

                            int value = item["Value"].Convert<int>() ?? 0;
                            string anyParam = item["AnyParam"].AsString();

                            // INE verisinin içindeki şehir ismine göre ayırıyoruz
                            if (anyParam.Contains("Madrid") && madrid != null)
                            {
                                SaveTourismDataIfNotExists(tourismRepo, madrid.Id, value, 180m, dateRecorded);
                            }
                            else if (anyParam.Contains("Barcelona") && barcelona != null)
                            {
                                SaveTourismDataIfNotExists(tourismRepo, barcelona.Id, value, 210m, dateRecorded);
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                _logger.LogError($"İspanya verisi çekilirken hata: {ex.Message}");
            }
        }
        #endregion

        #region Norveç (SSB API - JSON-STAT)
        private async Task ProcessNorwayData(CancellationToken stoppingToken)
        {
            try
            {
                _logger.LogInformation("Norveç (SSB) verileri çekiliyor...");

                string apiUrl = "https://data.ssb.no/api/v0/en/table/13155/";

                // SSB API'si bizden spesifik bir sorgu JSON'ı (POST Request) bekler
                string jsonQuery = @"
                {
                  ""query"": [
                    { ""code"": ""Region"", ""selection"": { ""filter"": ""item"", ""values"": [""NO08""] } },
                    { ""code"": ""ContentsCode"", ""selection"": { ""filter"": ""item"", ""values"": [""Gjester""] } }
                  ],
                  ""response"": { ""format"": ""json-stat2"" }
                }";

                var content = new StringContent(jsonQuery, Encoding.UTF8, "application/json");
                var response = await _httpClient.PostAsync(apiUrl, content, stoppingToken);

                if (response.IsSuccessStatusCode)
                {
                    var responseString = await response.Content.ReadAsStringAsync();
                    var data = JObject.Parse(responseString);

                    var cityRepo = Repository<City>.Create();
                    var tourismRepo = Repository<TourismMetric>.Create();
                    var oslo = cityRepo.GetQueryable(x => x.Name == "Oslo").FirstOrDefault();

                    if (oslo != null && data["value"] != null && data["dimension"] != null)
                    {
                        var values = data["value"].ToObject<int[]>();
                        var timeIndex = data["dimension"]["time"]["category"]["index"] as JObject;

                        if (timeIndex != null && values != null)
                        {
                            int i = 0;
                            foreach (var time in timeIndex)
                            {
                                string rawDate = time.Key; // "2024M01"
                                int year = rawDate.Substring(0, 4).Convert<int>() ?? 2024;
                                int month = rawDate.Substring(5, 2).Convert<int>() ?? 1;
                                DateTime dateRecorded = new DateTime(year, month, 1);

                                // JSON-stat düz dizi döner, sırayla eşleştiriyoruz
                                if (i < values.Length)
                                {
                                    SaveTourismDataIfNotExists(tourismRepo, oslo.Id, values[i], 150m, dateRecorded);
                                }
                                i++;
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                _logger.LogError($"Norveç verisi çekilirken hata: {ex.Message}");
            }
        }
        #endregion

        #region Türkiye (Kültür Bakanlığı - Excel Simülasyonu)
        private void ProcessTurkeyData()
        {
            try
            {
                _logger.LogInformation("Türkiye verileri işleniyor...");

                var cityRepo = Repository<City>.Create();
                var tourismRepo = Repository<TourismMetric>.Create();

                var istanbul = cityRepo.GetQueryable(x => x.Name == "İstanbul").FirstOrDefault();
                var antalya = cityRepo.GetQueryable(x => x.Name == "Antalya").FirstOrDefault();

                // İLERİDE BURAYA: "ClosedXML" NuGet paketi kurup Bakanlığın Excel'ini URL'den Stream olarak indirip okuyacaksın.
                // Şimdilik C# tarafı patlamasın diye geçmiş 24 ayın verisini sistem kendisi üretiyor.

                if (istanbul != null && antalya != null)
                {
                    DateTime startDate = DateTime.Now.AddMonths(-24);
                    startDate = new DateTime(startDate.Year, startDate.Month, 1);

                    for (DateTime date = startDate; date <= DateTime.Now; date = date.AddMonths(1))
                    {
                        // Antalya yazın patlar, İstanbul sabittir mantığı
                        int istCount = (date.Month >= 5 && date.Month <= 9) ? 1500000 : 900000;
                        int antCount = (date.Month >= 5 && date.Month <= 9) ? 2000000 : 200000;

                        SaveTourismDataIfNotExists(tourismRepo, istanbul.Id, istCount, 120m, date);
                        SaveTourismDataIfNotExists(tourismRepo, antalya.Id, antCount, 150m, date);
                    }
                }
            }
            catch (Exception ex)
            {
                _logger.LogError($"Türkiye verisi işlenirken hata: {ex.Message}");
            }
        }
        #endregion

        #region Rusya (Rosstat - CSV Simülasyonu)
        private void ProcessRussiaData()
        {
            try
            {
                _logger.LogInformation("Rusya verileri işleniyor...");

                var cityRepo = Repository<City>.Create();
                var tourismRepo = Repository<TourismMetric>.Create();

                var moskova = cityRepo.GetQueryable(x => x.Name == "Moskova").FirstOrDefault();

                // İLERİDE BURAYA: Rosstat'ın yayınladığı güncel CSV veya Excel dosyası parse edilecek.

                if (moskova != null)
                {
                    DateTime startDate = DateTime.Now.AddMonths(-24);
                    startDate = new DateTime(startDate.Year, startDate.Month, 1);

                    for (DateTime date = startDate; date <= DateTime.Now; date = date.AddMonths(1))
                    {
                        SaveTourismDataIfNotExists(tourismRepo, moskova.Id, 450000, 80m, date);
                    }
                }
            }
            catch (Exception ex)
            {
                _logger.LogError($"Rusya verisi işlenirken hata: {ex.Message}");
            }
        }
        #endregion

        // Ortak Kaydetme Metodu
        private void SaveTourismDataIfNotExists(IRepository<TourismMetric> repo, long cityId, int touristCount, decimal avgPrice, DateTime date)
        {
            var exists = repo.GetQueryable(x => x.CityId == cityId && x.DateRecorded.Year == date.Year && x.DateRecorded.Month == date.Month).Any();

            if (!exists)
            {
                repo.Insert(new TourismMetric
                {
                    CityId = cityId,
                    TouristCount = touristCount,
                    AvgAccommodationPrice = avgPrice,
                    CurrencyUsed = "EUR",
                    DateRecorded = date
                });
            }
        }
    }
}