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
        public static ForecastChartModel GetChartData<T>(IRepository<T>? repository = null, long? countryId = null, CultureInfo? cultureInfo = null) where T : EntityBase, IMetrics
        {
            if (repository is null) repository = Repository<T>.Create();
            if (cultureInfo is null) cultureInfo = CultureInfo.CurrentCulture;
            var model = new ForecastChartModel
            {
                values = new List<decimal>(),
                labels = new List<string>()
            };
            if (repository is null) repository = Repository<T>.Create();
            var query = repository.GetQueryable();
            if (countryId.HasValue && countryId.Value > 0) query = query.Where(x => x.CountryId == countryId.Value);
            var list = query.ToList();
            if (list is null || list.Count < 1) return model;

            if (typeof(T) == typeof(ExchangeRate))
            {
                var data = list.Select(c => c as ExchangeRate).Where(x => x is not null).ToList() ?? new List<ExchangeRate?>();
                model.labels = data.Select(x => x.DateRecorded.ToString("MMMM yyyy", cultureInfo)).ToList();
                model.values = data.Select(x => x.Rate).ToList();
            }
            else if (typeof(T) == typeof(TourismMetric))
            {
                var data = list.Select(c => c as TourismMetric).Where(x => x is not null).ToList() ?? new List<TourismMetric?>();
                var dates = data.Select(x => x is null ? DateTime.MinValue : x.DateRecorded).Distinct().OrderBy(x => x).ToList();
                foreach (var date in dates)
                {
                    model.values.Add(data.Where(x => x is not null && x.DateRecorded == date).Sum(x => x?.TouristCount ?? 0).ToDecimal() ?? 0);
                }
                model.labels = dates.Select(x => x.ToString("MMMM yyyy", cultureInfo)).ToList();
            }
            return model;

        }
    }
}
