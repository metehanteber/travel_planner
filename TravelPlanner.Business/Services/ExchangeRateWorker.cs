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
            _logger.LogInformation("Orijinal ECB Döviz Kuru Çekme Servisi başlatıldı...");

            while (!stoppingToken.IsCancellationRequested)
            {
                try
                {
                    _logger.LogInformation("ECB üzerinden güncel döviz kurları çekiliyor...");

                    var countryRepo = Repository<Country>.Create();
                    var exchangeRepo = Repository<ExchangeRate>.Create();

                    List<Country> countries = countryRepo.GetList() ?? new List<Country>();

                    // Döviz kodlarını temizleme (Senin orijinal mantığın)
                    countries.ForEach(c => c.ExchangeCode = c.ExchangeCode.NullToEmpty(true).ToUpper().Replace("İ", "I"));

                    // Orijinal ECB XML Endpoint
                    string apiUrl = "https://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml";

                    var response = await _httpClient.GetStringAsync(apiUrl, stoppingToken);

                    // XML Verisini Parse Etme
                    XDocument xmlDoc = XDocument.Parse(response);
                    XNamespace ecbNamespace = "http://www.ecb.int/vocabulary/2002-08-01/eurofxref";

                    // İçinde 'time' attribute'u olan ana Cube'u (günün tarihini) bul
                    var timeCube = xmlDoc.Descendants(ecbNamespace + "Cube")
                                         .FirstOrDefault(x => x.Attribute("time") != null);

                    if (timeCube != null)
                    {
                        DateTime dateRecorded = DateTime.Parse(timeCube.Attribute("time").Value);

                        // O günün tüm döviz kurlarını çek ve bellekte hızlı arama için bir Dictionary'e (Sözlük) aktar
                        var rateNodes = timeCube.Elements(ecbNamespace + "Cube").ToList();
                        var ecbRates = new Dictionary<string, decimal>();

                        foreach (var node in rateNodes)
                        {
                            var curr = node.Attribute("currency")?.Value;
                            var rateStr = node.Attribute("rate")?.Value;

                            if (!string.IsNullOrEmpty(curr) && !string.IsNullOrEmpty(rateStr))
                            {
                                // XML'den gelen noktalı sayıları sistemin kültür ayarına takılmadan parse ediyoruz
                                if (decimal.TryParse(rateStr, System.Globalization.NumberStyles.Any, System.Globalization.CultureInfo.InvariantCulture, out decimal parsedRate))
                                {
                                    ecbRates[curr] = parsedRate;
                                }
                            }
                        }

                        // Senin dinamik ülke döngün
                        foreach (var country in countries)
                        {
                            var exCode = country.ExchangeCode.NullToEmpty(true);
                            if (exCode == "") continue;

                            try
                            {
                                decimal? rate = null;

                                // Baz para birimi (EUR) kontrolü ve Sözlükten Kur Okuma
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
                                // Hata olursa diğer ülkeye geçmeye devam et
                            }
                        }

                        _logger.LogInformation($"Kurlar ({dateRecorded:yyyy-MM-dd}) başarıyla veritabanına işlendi.");
                    }
                }
                catch (Exception ex)
                {
                    _logger.LogError($"ECB döviz kurları çekilirken hata oluştu: {ex.Message}");
                }

                // 24 Saatte bir çalışacak şekilde ayarlamak genelde daha uygundur. Test için 1 dakika bırakabilirsin.
                await Task.Delay(TimeSpan.FromDays(1), stoppingToken);
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