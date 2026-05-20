using Microsoft.AspNetCore.Mvc;
using System.Linq;
using System.Globalization;
using TravelPlanner.Business.Repo;
using TravelPlanner.Data.Entities;

namespace TravelPlanner.UI.Controllers
{
    public class ForecastController : Controller
    {
        public IActionResult Index()
        {
            var countryRepo = Repository<Country>.Create();
            var countries = countryRepo.GetQueryable().OrderBy(x => x.Name).ToList();

            return View(countries);
        }

        [HttpPost]
        public IActionResult GetForecastData(long countryId, string metricType)
        {
            // 1. Forecast tablosu için repository'yi ayağa kaldır
            var forecastRepo = Repository<Forecast>.Create();

            // 2. İlgili ülkeye ve metrik tipine göre verileri çek, tarihe göre sırala
            var forecastData = forecastRepo.GetQueryable(x =>
                    x.CountryId == countryId &&
                    x.MetricType == metricType)
                .OrderBy(x => x.ForecastDate)
                .ToList();

            // 3. Eğer tabloda henüz veri yoksa, arayüzü uyarmak için false dön
            if (forecastData == null || !forecastData.Any())
            {
                return Json(new
                {
                    isSuccess = false,
                    message = "Bu kriterlere uygun tahmin verisi henüz oluşturulmamış."
                });
            }

            // 4. Chart.js için verileri formatla
            // Tarihleri "Oca 2026", "Şub 2026" gibi Türkçe ve okunaklı bir formata çeviriyoruz
            var cultureInfo = new CultureInfo("tr-TR");

            var dates = forecastData.Select(x => x.ForecastDate).Distinct().OrderBy(x => x).ToList();
            var data = new List<decimal>();

            foreach (var date in dates)
            {
                var value = forecastData.Where(x => x.ForecastDate == date).Sum(x => x.PredictedValue);
                if (metricType == "TouristCount") value = Math.Round(value);
                data.Add(value);
            }


            var labels = dates.Select(x => x.ToString("MMM yyyy", cultureInfo)).ToArray();

            // 5. Veriyi JSON olarak UI'a fırlat
            return Json(new { isSuccess = true, labels = labels, values = data });
        }
    }
}