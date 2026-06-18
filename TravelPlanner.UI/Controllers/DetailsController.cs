using Microsoft.AspNetCore.Mvc;
using System;
using System.Linq;
using System.Collections.Generic;
using TravelPlanner.Business.Repo;
using TravelPlanner.Data.Entities;

namespace TravelPlanner.Web.UI.Controllers
{
    public class DetailsController : Controller
    {
        [Route("country/{code}")]
        public IActionResult Country(string code)
        {
            if (string.IsNullOrWhiteSpace(code)) return RedirectToAction("Index", "Home");

            var countryRepo = Repository<Country>.Create();
            var cityRepo = Repository<City>.Create();
            var exRepo = Repository<ExchangeRate>.Create();
            var metricRepo = Repository<TourismMetric>.Create();

            var country = countryRepo.GetQueryable(x => x.Code.ToLower() == code.ToLower()).FirstOrDefault();

            if (country == null) return NotFound("Ülke bulunamadı.");

            var cities = cityRepo.GetQueryable(x => x.CountryId == country.Id).ToList();

            var cityIds = cities.Select(c => c.Id).ToList();
            var latestMetrics = metricRepo.GetQueryable(x => cityIds.Contains(x.CityId))
                .GroupBy(x => x.CityId)
                .Select(g => g.OrderByDescending(m => m.DateRecorded).FirstOrDefault())
                .ToDictionary(x => x.CityId, x => x);

            var populationData = TravelPlanner.Business.ServicesHelper.GetCountryPopulation(country.Code);

            var exchangeRates = exRepo.GetQueryable(x => x.CountryId == country.Id)
                                       .OrderByDescending(x => x.DateRecorded)
                                       .Take(2)
                                       .ToList();

            string exchangeInsight = "Güncel kur verisi analiz ediliyor.";
            if (exchangeRates.Count == 2)
            {
                var currentRate = exchangeRates[0].Rate;
                var previousRate = exchangeRates[1].Rate;

                if (currentRate > previousRate)
                {
                    exchangeInsight = $"Kur trendi yukarı yönlü. Yerel para birimi EUR karşısında değer kaybediyor. ({(currentRate - previousRate):N2} artış)";
                }
                else if (currentRate < previousRate)
                {
                    exchangeInsight = $"Kur trendi aşağı yönlü. Yerel para birimi EUR karşısında değer kazanıyor. ({(previousRate - currentRate):N2} düşüş)";
                }
                else
                {
                    exchangeInsight = "Döviz kuru stabil seyrediyor.";
                }
            }

            ViewBag.LatestExchangeRate = exchangeRates.FirstOrDefault()?.Rate ?? 1;
            ViewBag.Currency = exchangeRates.FirstOrDefault()?.TargetCurrency ?? "EUR";
            ViewBag.Cities = cities;
            ViewBag.LatestMetrics = latestMetrics;
            ViewBag.PopulationData = populationData;
            ViewBag.ExchangeInsight = exchangeInsight;

            return View(country);
        }

        [Route("city/{id:long}")]
        public IActionResult City(long id)
        {
            var cityRepo = Repository<City>.Create();
            var metricRepo = Repository<TourismMetric>.Create();
            var forecastRepo = Repository<Forecast>.Create();
            var countryRepo = Repository<Country>.Create();

            var city = cityRepo.GetQueryable(x => x.Id == id).FirstOrDefault();
            if (city == null) return NotFound("Şehir bulunamadı.");

            var currentMonth = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1);

            var historicalMetrics = metricRepo.GetQueryable(x => x.CityId == id)
                .Where(x => x.DateRecorded < currentMonth)
                .OrderByDescending(x => x.DateRecorded)
                .ToList();

            var rawForecasts = forecastRepo.GetQueryable(x => x.CityId == id)
                .Where(x => x.ForecastDate >= currentMonth)
                .ToList();

            var futureMetrics = rawForecasts
                .GroupBy(x => x.ForecastDate)
                .Select(g => new TourismMetric
                {
                    DateRecorded = g.Key,
                    TouristCount = (int?)(g.FirstOrDefault(x => x.MetricType == "TouristCount")?.PredictedValue),
                    AvgAccommodationPrice = (decimal?)(g.FirstOrDefault(x => x.MetricType == "AccommodationPrice")?.PredictedValue),
                    CurrencyUsed = "EUR"
                })
                .OrderBy(x => x.DateRecorded)
                .ToList();

            string touristInsight = "Turist hacmi için yeterli tahmin verisi bekleniyor.";
            string priceInsight = "Konaklama fiyatları için yeterli tahmin verisi bekleniyor.";

            if (historicalMetrics.Any() && futureMetrics.Any())
            {
                var lastHistTourist = historicalMetrics.First().TouristCount ?? 0;
                var avgFutureTourist = futureMetrics.Average(x => x.TouristCount) ?? 0;

                if (avgFutureTourist > lastHistTourist)
                {
                    touristInsight = $"Yapay zeka modelimize göre önümüzdeki dönemde turist yoğunluğunda artış beklenmektedir. Ortalama beklenti: {avgFutureTourist:N0} kişi.";
                }
                else
                {
                    touristInsight = $"Yapay zeka modelimize göre önümüzdeki dönemde turist yoğunluğunda sakinleşme veya düşüş beklenmektedir. Ortalama beklenti: {avgFutureTourist:N0} kişi.";
                }

                var lastHistPrice = historicalMetrics.First().AvgAccommodationPrice ?? 0;
                var avgFuturePrice = futureMetrics.Average(x => x.AvgAccommodationPrice) ?? 0;

                if (avgFuturePrice > lastHistPrice)
                {
                    priceInsight = $"Artan talebe bağlı olarak konaklama maliyetlerinde yükseliş trendi öngörülüyor. Hedef ortalama: {avgFuturePrice:N2}";
                }
                else
                {
                    priceInsight = $"Konaklama maliyetlerinde düşüş trendi veya stabilite öngörülüyor. Fiyat/performans dönemi yaklaşıyor.";
                }
            }

            ViewBag.Country = countryRepo.GetQueryable(x => x.Id == city.CountryId).FirstOrDefault();
            ViewBag.HistoricalMetrics = historicalMetrics;
            ViewBag.FutureMetrics = futureMetrics;
            ViewBag.TouristInsight = touristInsight;
            ViewBag.PriceInsight = priceInsight;

            return View(city);
        }
    }
}