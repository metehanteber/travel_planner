using Microsoft.Identity.Client;
using System.Globalization;
using System.Xml;
using TravelPlanner.Business.Repo;
using TravelPlanner.Core;
using TravelPlanner.Data.Entities;
using TravelPlanner.UI.Models;

namespace TravelPlanner.UI.Helpers
{
    public static class UIHelper
    {
        public static LayoutViewModel GetLayoutData()
        {
            var model = new LayoutViewModel
            {
                Countries = new List<Country>()
            };
            try
            {
                IRepository<Country> countriesService = Repository<Country>.Create();
                model.Countries = countriesService.GetQueryable().OrderBy(c => c.Id).ToList();
                return model;
            }
            catch
            {
                return model;
            }
        }

        public static void GetPastData(string metricType, long countryId, ref List<string> labels, ref List<decimal> values)
        {
            labels = new List<string>();
            values = new List<decimal>();
            if (metricType == "TouristCount" || metricType == "AccommodationPrice")
            {
                IRepository<TourismMetric> tourismService = Repository<TourismMetric>.Create();
                var data = tourismService.GetQueryable(x => x.CountryId == countryId).ToList();
                var dates = data.Select(x => x.DateRecorded).Distinct().OrderBy(x => x).ToList();
                foreach (var date in dates)
                {
                    decimal sum = 0;
                    if (metricType == "AccommodationPrice")
                    {
                        sum = data.Where(x => x.DateRecorded == date).Sum(x => x.AvgAccommodationPrice ?? 0);
                    }
                    else
                    {
                        sum = data.Where(x => x.DateRecorded == date).Sum(x => x.TouristCount ?? 0);
                        sum = Math.Round(sum);
                    }

                    labels.Add(date.ToString("MMM yyyy"));
                    values.Add(sum);
                }
            }
            else if (metricType == "ExchangeRate")
            {
                IRepository<ExchangeRate> exchangeService = Repository<ExchangeRate>.Create();
                var data = exchangeService.GetQueryable(x => x.CountryId == countryId).ToList();
                var dates = data.Select(x => x.DateRecorded).Distinct().OrderBy(x => x).ToList();
                foreach (var date in dates)
                {
                    var sum = data.Where(x => x.DateRecorded == date).Sum(x => x.Rate);
                    labels.Add(date.ToString("MMM yyyy"));
                    values.Add(sum);
                }
            }
            else if (metricType == "InflationRate")
            {
                IRepository<InflationRate> inflationService = Repository<InflationRate>.Create();
                var data = inflationService.GetQueryable(x => x.CountryId == countryId).ToList();
                var dates = data.Select(x => x.DateRecorded).Distinct().OrderBy(x => x).ToList();
                foreach (var date in dates)
                {
                    var sum = data.Where(x => x.DateRecorded == date).Sum(x => x.Rate);
                    labels.Add(date.ToString("MMM yyyy"));
                    values.Add(sum);
                }
            }
        }

        public static void GetForecastData(string metricType, long countryId, ref List<string> labels, ref List<decimal> values)
        {
            if (labels is null) labels = new List<string>();
            if (values is null) values = new List<decimal>();

            var forecastService = Repository<Forecast>.Create();
            var data = forecastService.GetQueryable(x => x.CountryId == countryId && x.MetricType == metricType).OrderBy(x => x.ForecastDate).ToList();

            if (data is null || data.Count < 1)
            {
                return;
            }

            var cultureInfo = new CultureInfo("tr-TR");

            var dates = data.Select(x => x.ForecastDate).Distinct().OrderBy(x => x).ToList();

            foreach (var date in dates)
            {
                var value = data.Where(x => x.ForecastDate == date).Sum(x => x.PredictedValue);
                if (metricType == "TouristCount") value = Math.Round(value);
                values.Add(value);
                labels.Add(date.ToString("MMM yyyy", cultureInfo));
            }
        }

        public static string[] GetUIColors()
        {
            return ["#32a852", "#a2a832", "#a83832", "#3279a8", "#878787", "#111111", "#FEFEFE"];
        }
    }
}
