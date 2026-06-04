using Microsoft.AspNetCore.Mvc;
using System.Linq;
using TravelPlanner.Business.Repo;
using TravelPlanner.Core;
using TravelPlanner.Data.Entities;
using TravelPlanner.UI.Helpers;

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

            var populationData = UIHelper.GetCountryPopulation(country.Code);

            var latestExchange = exRepo.GetQueryable(x => x.CountryId == country.Id)
                                       .OrderByDescending(x => x.DateRecorded)
                                       .FirstOrDefault();

            ViewBag.LatestExchangeRate = latestExchange != null ? Math.Round(latestExchange.Rate, 2) : 1;
            ViewBag.Currency = latestExchange != null ? latestExchange.TargetCurrency : "EUR";
            ViewBag.Cities = cities;
            ViewBag.LatestMetrics = latestMetrics;
            ViewBag.PopulationData = populationData;

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

            var futureMetrics = forecastRepo.GetQueryable(x => x.CityId == id)
                .Where(x => x.ForecastDate >= currentMonth)
                .OrderBy(x => x.ForecastDate)
                .ToList();

            var forecastMetrics = new List<TourismMetric>();

            var dates = futureMetrics.Select(x => x.ForecastDate).Distinct().ToList();

            foreach (var date in dates)
            {
                var m = futureMetrics.Where(x => x.ForecastDate == date).ToList();
                var tc = m.Where(x => x.MetricType == "TouristCount").OrderByDescending(x => x.Id).FirstOrDefault();
                var ap = m.Where(x => x.MetricType == "AccommodationPrice").OrderByDescending(x => x.Id).FirstOrDefault();

                forecastMetrics.Add(new TourismMetric
                {
                    Id = 0,
                    AvgAccommodationPrice = ap is null ? null : ap.PredictedValue,
                    TouristCount = tc is null ? null : tc.PredictedValue.Convert<int>(),
                    CityId = city.Id,
                    CountryId = city.CountryId,
                    CurrencyUsed = city.Country is null ? "EUR" : city.Country.ExchangeCode.NullToEmpty(true),
                    DateRecorded = date,
                    Guid = Guid.NewGuid(),
                    IsDeleted = false
                });

            }

            ViewBag.Country = countryRepo.GetQueryable(x => x.Id == city.CountryId).FirstOrDefault();
            ViewBag.HistoricalMetrics = historicalMetrics;
            ViewBag.FutureMetrics = forecastMetrics;

            return View(city);
        }
    }
}