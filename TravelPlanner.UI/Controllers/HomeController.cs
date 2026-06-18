using Microsoft.AspNetCore.Mvc;
using System;
using System.Linq;
using TravelPlanner.Business.Repo;
using TravelPlanner.Data.Entities;

namespace TravelPlanner.UI.Controllers
{
    public class HomeController : Controller
    {
        public IActionResult Index()
        {
            var countryService = Repository<Country>.Create();
            var cityService = Repository<City>.Create();
            var forecastService = Repository<Forecast>.Create();

            ViewBag.CountryCount = countryService.GetQueryable().Count();
            ViewBag.CityCount = cityService.GetQueryable().Count();
            ViewBag.ForecastCount = forecastService.GetQueryable().Count();

            var popularCountries = countryService.GetQueryable(x => !x.IsDeleted)
                .OrderBy(x => x.Id)
                .Take(4)
                .ToList();

            ViewBag.PopularCountries = popularCountries;

            return View();
        }
    }
}