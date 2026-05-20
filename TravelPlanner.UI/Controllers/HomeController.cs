using Microsoft.AspNetCore.Mvc;
using TravelPlanner.Business.Repo;
using TravelPlanner.Data.Entities;

namespace TravelPlanner.UI.Controllers
{
    public class HomeController : Controller
    {
        public IActionResult Index()
        {
            // Senin yazdýðýn saðlam Repository pattern'i ile instance'larý alýyoruz
            var countryRepo = Repository<Country>.Create();
            var cityRepo = Repository<City>.Create();
            var forecastRepo = Repository<Forecast>.Create();

            // Veritabanýnda veri yoksa patlamamasý için basit Count() iþlemleri yapýyoruz
            ViewBag.CountryCount = countryRepo.GetQueryable().Count();
            ViewBag.CityCount = cityRepo.GetQueryable().Count();
            ViewBag.ForecastCount = forecastRepo.GetQueryable().Count();

            return View();
        }
    }
}