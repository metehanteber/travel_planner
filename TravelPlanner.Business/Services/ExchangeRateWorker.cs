using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Threading;
using System.Threading.Tasks;
using System.Xml.Linq;
using TravelPlanner.Business.Repo;
using TravelPlanner.Core;
using TravelPlanner.Data.Entities;
using static System.Runtime.InteropServices.JavaScript.JSType;

namespace TravelPlanner.Business.Services
{
    public class ExchangeRateWorker : BackgroundService
    {
        private readonly ILogger<ExchangeRateWorker> _logger;
        private readonly HttpClient _httpClient;

        public ExchangeRateWorker(ILogger<ExchangeRateWorker> logger)
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
                    var exchangeRepo = Repository<ExchangeRate>.Create();

                    List<Country> countries = countryRepo.GetList() ?? new List<Country>();
                    countries.ForEach(c => c.ExchangeCode = c.ExchangeCode.NullToEmpty(true).ToUpper().Replace("İ", "I"));
                    string apiUrl = "https://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml";

                    var response = await _httpClient.GetStringAsync(apiUrl, stoppingToken);
                    XDocument xmlDoc = XDocument.Parse(response);
                    XNamespace ecbNamespace = "http://www.ecb.int/vocabulary/2002-08-01/eurofxref";
                    var timeCube = xmlDoc.Descendants(ecbNamespace + "Cube")
                                         .FirstOrDefault(x => x.Attribute("time") != null);

                    if (timeCube != null)
                    {
                        DateTime dateRecorded = DateTime.Parse(timeCube.Attribute("time").Value);

                        var rateNodes = timeCube.Elements(ecbNamespace + "Cube").ToList();
                        var ecbRates = new Dictionary<string, decimal>();

                        foreach (var node in rateNodes)
                        {
                            var curr = node.Attribute("currency")?.Value;
                            var rateStr = node.Attribute("rate")?.Value;

                            if (!string.IsNullOrEmpty(curr) && !string.IsNullOrEmpty(rateStr))
                            {
                                if (decimal.TryParse(rateStr, System.Globalization.NumberStyles.Any, System.Globalization.CultureInfo.InvariantCulture, out decimal parsedRate))
                                {
                                    ecbRates[curr] = parsedRate;
                                }
                            }
                        }

                        foreach (var country in countries)
                        {
                            var exCode = country.ExchangeCode.NullToEmpty(true);
                            if (exCode == "") continue;

                            try
                            {
                                decimal? rate = null;

                                if (exCode == "EUR")
                                {
                                    rate = 1;
                                }
                                else if (ecbRates.ContainsKey(exCode))
                                {
                                    rate = ecbRates[exCode];
                                }

                                if (!rate.HasValue) continue;

                                SaveRateIfNotExists(exchangeRepo, country.Id, "EUR", exCode, rate.Value, dateRecorded);
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

                var spn = DateTime.Now.AddDays(1).Date - DateTime.Now;
                await Task.Delay(spn, stoppingToken);
            }
        }

        private void SaveRateIfNotExists(IRepository<ExchangeRate> repo, long countryId, string baseCur, string targetCur, decimal rate, DateTime date)
        {
            var exists = repo.GetQueryable(x => x.CountryId == countryId && x.DateRecorded == date).Any();

            if (!exists)
            {
                repo.Insert(new ExchangeRate
                {
                    CountryId = countryId,
                    BaseCurrency = baseCur,
                    TargetCurrency = targetCur,
                    Rate = rate,
                    DateRecorded = date
                });
            }
        }
    }
}