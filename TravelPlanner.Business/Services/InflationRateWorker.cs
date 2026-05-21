using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json.Linq;
using System;
using System.Linq;
using System.Net.Http;
using System.Threading;
using System.Threading.Tasks;
using TravelPlanner.Business.Repo;
using TravelPlanner.Core;
using TravelPlanner.Data.Entities;

namespace TravelPlanner.Business.Services
{
    public class InflationWorker : BackgroundService
    {
        private readonly ILogger<InflationWorker> _logger;
        private readonly HttpClient _httpClient;

        public InflationWorker(ILogger<InflationWorker> logger)
        {
            _logger = logger;
            _httpClient = new HttpClient();
        }

        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {

            while (!stoppingToken.IsCancellationRequested)
            {
                try
                {
                    var countryRepo = Repository<Country>.Create();
                    var inflationRepo = Repository<InflationRate>.Create();


                    List<Country> countries = countryRepo.GetList() ?? new List<Country>();
                    countries = countries.Where(c => c.Code.NullToEmpty(true) != "").ToList();
                    countries.ForEach(c => c.Code = c.Code.NullToEmpty(true).ToUpper().Replace("I", "İ"));

                    int currentYear = DateTime.Now.Year;
                    string apiUrl = $"http://api.worldbank.org/v2/country/{string.Join(";", countries.Select(x => x.Code.Substring(0, 2)).ToList())}/indicator/FP.CPI.TOTL.ZG?format=json&date={currentYear - 5}:{currentYear}";

                    var response = await _httpClient.GetStringAsync(apiUrl, stoppingToken);
                    var data = JArray.Parse(response);

                    if (data.Count > 1)
                    {
                        var records = data[1];

                        foreach (var record in records)
                        {
                            try
                            {
                                if (record["value"] != null && record["value"].Type != JTokenType.Null)
                                {
                                    string countryCode = "";
                                    try
                                    {
                                        countryCode = record["country"]["id"].ToString();
                                        if (countryCode.Length != 2) throw new Exception();
                                    }
                                    catch
                                    {
                                        countryCode = record["countryiso3code"].ToString().Substring(0, 2);
                                    }
                                    decimal rate = record["value"].Value<decimal>();
                                    int year = record["date"].Value<int>();
                                    DateTime dateRecorded = new DateTime(year, 1, 1);

                                    var country = countries.Where(x => x.Code == countryCode).FirstOrDefault();

                                    if (country is not null)
                                    {
                                        SaveRateIfNotExists(inflationRepo, country.Id, rate, dateRecorded);
                                    }
                                }
                            }
                            catch
                            {
                            }
                        }
                    }
                }
                catch
                {
                }

                var spn = DateTime.Now.AddDays(7).Date - DateTime.Now;
                await Task.Delay(spn, stoppingToken);
            }
        }

        private void SaveRateIfNotExists(IRepository<InflationRate> repo, long countryId, decimal rate, DateTime date)
        {
            var exists = repo.GetQueryable(x => x.CountryId == countryId && x.DateRecorded.Year == date.Year).Any();
            if (!exists)
            {
                repo.Insert(new InflationRate
                {
                    CountryId = countryId,
                    Rate = rate,
                    DateRecorded = date
                });
            }
        }
    }
}