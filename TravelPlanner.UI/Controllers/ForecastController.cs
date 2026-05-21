using Microsoft.AspNetCore.Mvc;
using System.Linq;
using System.Globalization;
using TravelPlanner.Business.Repo;
using TravelPlanner.Data.Entities;
using TravelPlanner.Core;
using TravelPlanner.UI.Helpers;

namespace TravelPlanner.UI.Controllers
{
    public class ForecastController : Controller
    {
        public IActionResult Index()
        {
            var countriesService = Repository<Country>.Create();
            var countries = countriesService.GetQueryable().OrderBy(x => x.Id).ToList();

            return View(countries);
        }

        [HttpPost]
        public IActionResult GetForecastData(long countryId, string metricType, int dataType)
        {
            List<string> labels = new List<string>();
            var values = new List<decimal>();
            if (dataType.ContainedIn(0, 2))
            {
                UIHelper.GetPastData(metricType, countryId, ref labels, ref values);
            }
            if (dataType.ContainedIn(1, 2))
            {
                UIHelper.GetForecastData(metricType, countryId, ref labels, ref values);
            }

            return Json(new { isSuccess = true, labels, values });
        }
    }
}