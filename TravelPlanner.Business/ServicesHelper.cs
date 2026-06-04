using Microsoft.EntityFrameworkCore.Metadata.Internal;
using Microsoft.Identity.Client;
using Microsoft.VisualBasic;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;
using TravelPlanner.Business.Repo;
using TravelPlanner.Core;
using TravelPlanner.Data;
using TravelPlanner.Data.Entities;
using static System.Runtime.InteropServices.JavaScript.JSType;

namespace TravelPlanner.Business
{
    public static class ServicesHelper
    {
        #region Common
        private static List<TourismMetricsModel> ConcatCityInfo(List<City> cities, Dictionary<string, Dictionary<string, int>> touristCount, Dictionary<string, Dictionary<string, decimal>> accomodationPrice)
        {
            List<TourismMetricsModel> model = new List<TourismMetricsModel>();

            foreach (var city in cities)
            {
                var cKeys = city.AdditionalData.NullToEmpty(true).Split([" "], StringSplitOptions.RemoveEmptyEntries).ToList();
                if (cKeys is null || cKeys.Count < 1) continue;

                if (touristCount.ContainsKey(cKeys.First()))
                {
                    var data = touristCount[cKeys.First()];
                    if (data is null || data.Count < 1) continue;
                    foreach (var item in data)
                    {
                        var dateInfo = item.Key.NullToEmpty(true).ToUpper().Split(["M"], StringSplitOptions.RemoveEmptyEntries).Select(x => x.Convert<int>()).Where(x => x.HasValue).Select(x => x.Value).ToList();
                        if (dateInfo is null || dateInfo.Count != 2) continue;
                        var date = new DateTime(dateInfo[0], dateInfo[1], 1);
                        var metric = model.Where(x => x.CityId == city.Id && x.Date == date).FirstOrDefault();
                        if (metric is null)
                        {
                            metric = new TourismMetricsModel
                            {
                                CityId = city.Id,
                                Date = date,
                                TouristCount = item.Value,
                                CountryId = city.CountryId
                            };
                            model.Add(metric);
                        }
                        else
                        {
                            if (item.Value > 0)
                            {
                                metric.TouristCount = item.Value;
                            }
                        }
                    }
                }

                if (accomodationPrice.ContainsKey(cKeys.Last()))
                {
                    var data = accomodationPrice[cKeys.Last()];
                    if (data is null || data.Count < 1) continue;
                    foreach (var item in data)
                    {
                        var dateInfo = item.Key.NullToEmpty(true).ToUpper().Split(["M"], StringSplitOptions.RemoveEmptyEntries).Select(x => x.Convert<int>()).Where(x => x.HasValue).Select(x => x.Value).ToList();
                        if (dateInfo is null || dateInfo.Count != 2) continue;
                        var date = new DateTime(dateInfo[0], dateInfo[1], 1);
                        var metric = model.Where(x => x.CityId == city.Id && x.Date == date).FirstOrDefault();
                        if (metric is null)
                        {
                            metric = new TourismMetricsModel
                            {
                                CityId = city.Id,
                                Date = date,
                                AccomodationPrices = item.Value,
                                CountryId = city.CountryId
                            };
                            model.Add(metric);
                        }
                        else
                        {
                            if (item.Value > 0)
                            {
                                metric.AccomodationPrices = item.Value;
                            }
                        }
                    }
                }

            }
            return model;
        }

        #endregion Common

        #region Norway Info
        public static void ProcessNorwayTourismMetrics(ref IRepository<TourismMetric> repository)
        {
            IRepository<City> citiesRepo = Repository<City>.Create();
            var cities = citiesRepo.GetQueryable(x => x.Country.Code == "NO").ToList();
            var tCodes = cities.Select(x => x.AdditionalData.NullToEmpty(true).Split([" "], StringSplitOptions.RemoveEmptyEntries).FirstOrDefault().NullToEmpty(true)).Where(x => x != "").Distinct().OrderBy(x => x).ToList();
            var aCodes = cities.Select(x => x.AdditionalData.NullToEmpty(true).Split([" "], StringSplitOptions.RemoveEmptyEntries).LastOrDefault().NullToEmpty(true)).Where(x => x != "").Distinct().OrderBy(x => x).ToList();
            var touristCount = ProcessNorwayTouristCount(tCodes);
            var accomodationPrices = ProcessNorwayAccommodationPrice(aCodes);
            var cityIds = cities.Select(x => x.Id).ToList();
            var metrics = repository.GetQueryable(x => cityIds.Contains(x.CityId)).ToList();
            var list = ConcatCityInfo(cities, touristCount, accomodationPrices);

            bool updated = false;

            List<TourismMetric> addeds = new List<TourismMetric>();
            foreach (var item in list)
            {
                var metric = metrics.Where(x => x.DateRecorded == item.Date && x.CityId == item.CityId).FirstOrDefault();
                if (metric is null)
                {
                    addeds.Add(new TourismMetric
                    {
                        DateRecorded = item.Date,
                        AvgAccommodationPrice = item.AccomodationPrices,
                        TouristCount = item.TouristCount,
                        CityId = item.CityId,
                        CountryId = item.CountryId,
                        CurrencyUsed = "NOK",
                        Guid = Guid.NewGuid(),
                        IsDeleted = false
                    });
                }
                else
                {
                    if (!metric.TouristCount.HasValue || (item.TouristCount.HasValue && item.TouristCount.Value > 0))
                    {
                        metric.TouristCount = item.TouristCount;
                        updated = true;
                    }
                    if (!metric.AvgAccommodationPrice.HasValue || (item.AccomodationPrices.HasValue && item.AccomodationPrices.Value > 0))
                    {
                        metric.AvgAccommodationPrice = item.AccomodationPrices;
                        updated = true;
                    }
                }
            }

            if (updated)
            {
                repository.SaveChanges();
            }
            if (addeds.Count > 0)
            {
                repository.InsertList(addeds);
            }
        }
        private static Dictionary<string, Dictionary<string, int>> ProcessNorwayTouristCount(List<string> codes)
        {
            var dict = new Dictionary<string, Dictionary<string, int>>();

            foreach (var code in codes)
            {
                var request = new ApiRequest
                {
                    Method = "POST",
                    ContentType = "application/json;charset=utf-8",
                    Data = new
                    {
                        query = new[] {
                      new {
                          code = "Region",
                          selection = new {
                              filter = "item",
                              values = new string[]{ code }
                          }
                      },
                    new {
                        code = "ContentsCode",
                        selection = new {
                            filter = "item",
                            values = new string[] { "Overnattinger" } ,
                        }
                    }
                    },
                        response = new { format = "json-stat2" }
                    },
                    Url = "https://data.ssb.no/api/v0/en/table/13155/"
                };

                var jsonResponse = request.SendAndReceiveRawResponse().NullToEmpty(true);

                if (jsonResponse == "")
                    continue;

                using JsonDocument doc = JsonDocument.Parse(jsonResponse);

                JsonElement root = doc.RootElement;

                if (root.TryGetProperty("error", out JsonElement errorElement))
                {
                    continue;
                }

                JsonElement tidIndexElement = root
                    .GetProperty("dimension")
                    .GetProperty("Tid")
                    .GetProperty("category")
                    .GetProperty("index");

                JsonElement valuesElement = root.GetProperty("value");

                dict.Add(code, tidIndexElement
                    .EnumerateObject()
                    .Select(x => new
                    {
                        Month = x.Name,
                        Index = x.Value.GetInt32()
                    })
                    .OrderBy(x => x.Index)
                    .Where(x => x.Index >= 0 && x.Index < valuesElement.GetArrayLength())
                    .ToDictionary(
                        x => x.Month,
                        x =>
                        {
                            try
                            {
                                return valuesElement[x.Index].GetInt32();
                            }
                            catch
                            {
                                return 0;
                            }
                        }
                    ));
            }

            return dict;
        }
        private static Dictionary<string, Dictionary<string, decimal>> ProcessNorwayAccommodationPrice(List<string> codes)
        {
            var dict = new Dictionary<string, Dictionary<string, decimal>>();

            foreach (var code in codes)
            {
                var request = new ApiRequest
                {
                    Method = "POST",
                    ContentType = "application/json;charset=utf-8",
                    Data = new
                    {
                        query = new[] {
                    new {
                        code = "Region",
                        selection = new {
                            filter = "item",
                            values = new string[] { code }
                        }
                    },
                    new {
                        code = "ContentsCode",
                        selection = new {
                            filter = "item",
                            values = new string[] { "PrisRom" }
                        }
                    }
                },
                        response = new { format = "json-stat2" }
                    },
                    Url = "https://data.ssb.no/api/v0/en/table/14168/"
                };

                var jsonResponse = request.SendAndReceiveRawResponse().NullToEmpty(true);

                if (jsonResponse == "")
                    continue;

                using JsonDocument doc = JsonDocument.Parse(jsonResponse);
                JsonElement root = doc.RootElement;

                if (root.TryGetProperty("error", out JsonElement errorElement))
                {
                    continue;
                }

                JsonElement tidIndexElement = root
                    .GetProperty("dimension")
                    .GetProperty("Tid")
                    .GetProperty("category")
                    .GetProperty("index");

                JsonElement valuesElement = root.GetProperty("value");

                dict.Add(code, tidIndexElement
                    .EnumerateObject()
                    .Select(x => new
                    {
                        Month = x.Name,
                        Index = x.Value.GetInt32()
                    })
                    .OrderBy(x => x.Index)
                    .Where(x => x.Index >= 0 && x.Index < valuesElement.GetArrayLength())
                    .ToDictionary(
                        x => x.Month,
                        x =>
                        {
                            try
                            {
                                return valuesElement[x.Index].GetDecimal();
                            }
                            catch
                            {
                                return 0m;
                            }
                        }
                    ));
            }

            return dict;
        }
        #endregion Norway Info

        #region Spain Info
        public static void ProcessSpainTourismMetrics(ref IRepository<TourismMetric> repository)
        {
            IRepository<City> citiesRepo = Repository<City>.Create();
            var cities = citiesRepo.GetQueryable(x => x.Country.Code == "ES").ToList();
            var touristCount = ProcessSpainTouristCount(cities);
            var accomodationPrices = ProcessSpainAccomodationPrice(cities);
            var cityIds = cities.Select(x => x.Id).ToList();
            var metrics = repository.GetQueryable(x => cityIds.Contains(x.CityId)).ToList();
            var list = ConcatCityInfo(cities, touristCount, accomodationPrices);

            bool updated = false;

            List<TourismMetric> addeds = new List<TourismMetric>();
            foreach (var item in list)
            {
                var metric = metrics.Where(x => x.DateRecorded == item.Date && x.CityId == item.CityId).FirstOrDefault();
                if (metric is null)
                {
                    addeds.Add(new TourismMetric
                    {
                        DateRecorded = item.Date,
                        AvgAccommodationPrice = item.AccomodationPrices,
                        TouristCount = item.TouristCount,
                        CityId = item.CityId,
                        CountryId = item.CountryId,
                        CurrencyUsed = "EUR",
                        Guid = Guid.NewGuid(),
                        IsDeleted = false
                    });
                }
                else
                {
                    if (!metric.TouristCount.HasValue || (item.TouristCount.HasValue && item.TouristCount.Value > 0))
                    {
                        metric.TouristCount = item.TouristCount;
                        updated = true;
                    }
                    if (!metric.AvgAccommodationPrice.HasValue || (item.AccomodationPrices.HasValue && item.AccomodationPrices.Value > 0))
                    {
                        metric.AvgAccommodationPrice = item.AccomodationPrices;
                        updated = true;
                    }
                }
            }

            if (updated)
            {
                repository.SaveChanges();
            }
            if (addeds.Count > 0)
            {
                repository.InsertList(addeds);
            }
        }
        private static Dictionary<string, Dictionary<string, int>> ProcessSpainTouristCount(List<City> cities)
        {
            var dict = new Dictionary<string, Dictionary<string, int>>();
            foreach (var city in cities)
            {
                try
                {
                    var apiId = city.AdditionalData.NullToEmpty(true).Split([" "], StringSplitOptions.RemoveEmptyEntries).FirstOrDefault().NullToEmpty(true);

                    if (apiId == "") continue;

                    if (!dict.ContainsKey(city.Name)) dict.Add(city.Name, new Dictionary<string, int>());

                    ApiRequest request = new ApiRequest
                    {
                        ContentType = "application/x-www-form-urlencoded",
                        Url = "https://servicios.ine.es/wstempus/js/en/DATOS_TABLA/2074?tip=AM&",
                        Method = "POST",
                        Data = $"tv=115%3A{apiId}&tv=433%3A284332&tv=96%3A9975"
                    };
                    var response = request.SendAndReceiveRawResponse();
                    var fullData = JsonConvert.DeserializeObject<dynamic>(response);
                    var data = fullData[0]["Data"];

                    for (int i = 0; i < data.Count; i++)
                    {
                        var date = (DateTime)Convert.ToDateTime(Convert.ToString(data[i]["Fecha"])).Date;
                        var value = (int)Convert.ToInt32(Convert.ToString(data[i]["Valor"]));
                        string key = date.ToString("yyyy") + "M" + date.ToString("MM");
                        if (!dict[city.Name].ContainsKey(key))
                        {
                            dict[city.Name].Add(key, value);
                        }
                        else dict[city.Name][key] = value;

                    }
                }
                catch
                {
                }
            }

            return dict;
        }
        private static Dictionary<string, Dictionary<string, decimal>> ProcessSpainAccomodationPrice(List<City> cities)
        {
            var dict = new Dictionary<string, Dictionary<string, decimal>>();
            foreach (var city in cities)
            {
                try
                {
                    var apiId = city.AdditionalData.NullToEmpty(true).Split([" "], StringSplitOptions.RemoveEmptyEntries).LastOrDefault().NullToEmpty(true);

                    if (apiId == "") continue;

                    if (!dict.ContainsKey(city.Name)) dict.Add(city.Name, new Dictionary<string, decimal>());

                    ApiRequest request = new ApiRequest
                    {
                        ContentType = "application/x-www-form-urlencoded",
                        Url = "https://servicios.ine.es/wstempus/js/en/DATOS_TABLA/12156?tip=AM&",
                        Method = "POST",
                        Data = $"tv=3%3A83&tv=70%3A{apiId}"
                    };
                    var response = request.SendAndReceiveRawResponse();
                    var fullData = JsonConvert.DeserializeObject<dynamic>(response);
                    var data = fullData[0]["Data"];

                    for (int i = 0; i < data.Count; i++)
                    {
                        var date = (DateTime)Convert.ToDateTime(Convert.ToString(data[i]["Fecha"])).Date;
                        var value = (decimal)Convert.ToDecimal(Convert.ToString(data[i]["Valor"]));
                        string key = date.ToString("yyyy") + "M" + date.ToString("MM");
                        if (!dict[city.Name].ContainsKey(key))
                        {
                            dict[city.Name].Add(key, value);
                        }
                        else dict[city.Name][key] = value;

                    }
                }
                catch
                {
                }
            }

            return dict;
        }

        #endregion Spain Info

        #region Turkey Info
        public static void ProcessTurkeyTourismMetrics(ref IRepository<TourismMetric> repository)
        {
            var file = new FileInfo("country_data\\tr.json");
            if (!file.Exists) return;
            var list = JsonConvert.DeserializeObject<List<TourismMetricsModel>>(File.ReadAllText(file.FullName, Encoding.UTF8)) ?? new List<TourismMetricsModel>();
            IRepository<City> citiesRepo = Repository<City>.Create();
            var cities = citiesRepo.GetQueryable(x => x.Country.Code == "TR").ToList();
            var cityIds = cities.Select(x => x.Id).ToList();
            var metrics = repository.GetQueryable(x => cityIds.Contains(x.CityId)).ToList();

            bool updated = false;
            List<TourismMetric> addeds = new List<TourismMetric>();

            foreach (var item in list)
            {
                var metric = metrics.Where(x => x.DateRecorded == item.Date && x.CityId == item.CityId).FirstOrDefault();
                if (metric is null)
                {
                    addeds.Add(new TourismMetric
                    {
                        DateRecorded = item.Date,
                        AvgAccommodationPrice = item.AccomodationPrices,
                        TouristCount = item.TouristCount,
                        CityId = item.CityId,
                        CountryId = item.CountryId,
                        CurrencyUsed = "TRY",
                        Guid = Guid.NewGuid(),
                        IsDeleted = false
                    });
                }
                else
                {
                    if (!metric.TouristCount.HasValue || (item.TouristCount.HasValue && item.TouristCount.Value > 0))
                    {
                        metric.TouristCount = item.TouristCount;
                        updated = true;
                    }
                    if (!metric.AvgAccommodationPrice.HasValue || (item.AccomodationPrices.HasValue && item.AccomodationPrices.Value > 0))
                    {
                        metric.AvgAccommodationPrice = item.AccomodationPrices;
                        updated = true;
                    }
                }
            }

            if (updated)
            {
                repository.SaveChanges();
            }
            if (addeds.Count > 0)
            {
                repository.InsertList(addeds);
            }
        }
        #endregion Turkey Info

        #region Russia Info
        public static void ProcessRussiaTourismMetrics(ref IRepository<TourismMetric> repository)
        {
            var file = new FileInfo("country_data\\ru.json");
            if (!file.Exists) return;
            var list = JsonConvert.DeserializeObject<List<TourismMetricsModel>>(File.ReadAllText(file.FullName, Encoding.UTF8)) ?? new List<TourismMetricsModel>();
            IRepository<City> citiesRepo = Repository<City>.Create();
            var cities = citiesRepo.GetQueryable(x => x.Country.Code == "RU").ToList();
            var cityIds = cities.Select(x => x.Id).ToList();
            var metrics = repository.GetQueryable(x => cityIds.Contains(x.CityId)).ToList();

            bool updated = false;
            List<TourismMetric> addeds = new List<TourismMetric>();

            foreach (var item in list)
            {
                var metric = metrics.Where(x => x.DateRecorded == item.Date && x.CityId == item.CityId).FirstOrDefault();
                if (metric is null)
                {
                    addeds.Add(new TourismMetric
                    {
                        DateRecorded = item.Date,
                        AvgAccommodationPrice = item.AccomodationPrices,
                        TouristCount = item.TouristCount,
                        CityId = item.CityId,
                        CountryId = item.CountryId,
                        CurrencyUsed = "RUB",
                        Guid = Guid.NewGuid(),
                        IsDeleted = false
                    });
                }
                else
                {
                    if (!metric.TouristCount.HasValue || (item.TouristCount.HasValue && item.TouristCount.Value > 0))
                    {
                        metric.TouristCount = item.TouristCount;
                        updated = true;
                    }
                    if (!metric.AvgAccommodationPrice.HasValue || (item.AccomodationPrices.HasValue && item.AccomodationPrices.Value > 0))
                    {
                        metric.AvgAccommodationPrice = item.AccomodationPrices;
                        updated = true;
                    }
                }
            }

            if (updated)
            {
                repository.SaveChanges();
            }
            if (addeds.Count > 0)
            {
                repository.InsertList(addeds);
            }
        }
        #endregion Russia Info

    }

    public class TourismMetricsModel
    {
        public long CityId { get; set; }

        public DateTime Date { get; set; }

        public int? TouristCount { get; set; }

        public decimal? AccomodationPrices { get; set; }

        public long CountryId { get; set; }
    }
}


