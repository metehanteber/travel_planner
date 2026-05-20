using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using System;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using TravelPlanner.Business.Repo;
using TravelPlanner.Data.Entities;

namespace TravelPlanner.Business.Services
{
    public class TourismMetricsWorker : BackgroundService
    {
        private readonly ILogger<TourismMetricsWorker> _logger;

        public TourismMetricsWorker(ILogger<TourismMetricsWorker> logger)
        {
            _logger = logger;
        }

        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {
            _logger.LogInformation("Turizm Metrikleri Servisi başlatıldı...");

            while (!stoppingToken.IsCancellationRequested)
            {
                try
                {
                    _logger.LogInformation("Şehir bazlı turizm verileri işleniyor...");

                    var cityRepo = Repository<City>.Create();
                    var tourismRepo = Repository<TourismMetric>.Create();
                    var cities = cityRepo.GetQueryable().ToList();

                    // Geçmiş 2 yılın her ayı için veri kontrolü/üretimi yapıyoruz
                    DateTime startDate = DateTime.Now.AddYears(-2);
                    startDate = new DateTime(startDate.Year, startDate.Month, 1);
                    DateTime endDate = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1);

                    Random rnd = new Random();

                    foreach (var city in cities)
                    {
                        for (DateTime date = startDate; date <= endDate; date = date.AddMonths(1))
                        {
                            var exists = tourismRepo.GetQueryable(x => x.CityId == city.Id && x.DateRecorded.Year == date.Year && x.DateRecorded.Month == date.Month).Any();

                            if (!exists)
                            {
                                // İLERİDE BURAYA: TÜİK veya Rosstat API bağlantısını HTTP Request ile yazacaksın.
                                // Şimdilik ARIMA modelinin eğitilebilmesi için mevsime duyarlı sentetik veri atıyoruz.

                                int baseTouristCount = 50000;
                                decimal basePrice = 100m;

                                // Yaz ayları (Haziran, Temmuz, Ağustos) turist sayısı patlar (Kuzey yarımküre)
                                if (date.Month >= 6 && date.Month <= 8)
                                {
                                    baseTouristCount = rnd.Next(150000, 300000);
                                    basePrice = rnd.Next(150, 300);
                                }
                                // Kış ayları (Aralık, Ocak, Şubat) özellikle Rusya (Soçi) gibi yerlerde kış turizmi etkisi
                                else if (date.Month == 12 || date.Month <= 2)
                                {
                                    baseTouristCount = rnd.Next(80000, 120000);
                                    basePrice = rnd.Next(120, 200);
                                }
                                // Bahar ayları stabil
                                else
                                {
                                    baseTouristCount = rnd.Next(40000, 90000);
                                    basePrice = rnd.Next(80, 130);
                                }

                                tourismRepo.Insert(new TourismMetric
                                {
                                    CityId = city.Id,
                                    TouristCount = baseTouristCount,
                                    AvgAccommodationPrice = basePrice,
                                    CurrencyUsed = "EUR", // Standartlaştırmak için EUR alıyoruz
                                    DateRecorded = date,
                                    CountryId = city.CountryId
                                });
                            }
                        }
                    }

                    _logger.LogInformation("Turizm metrikleri başarıyla veritabanına işlendi.");
                }
                catch (Exception ex)
                {
                    _logger.LogError($"Turizm verileri işlenirken hata oluştu: {ex.Message}");
                }

                // Bu servis günde bir kez çalışıp API/Veri güncellemelerini kontrol eder
                await Task.Delay(TimeSpan.FromHours(24), stoppingToken);
            }
        }
    }
}