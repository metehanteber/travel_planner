using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json.Linq;
using System;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using TravelPlanner.Business.Repo;
using TravelPlanner.Core;
using TravelPlanner.Data.Entities;

namespace TravelPlanner.Business.Services
{
    public class TourismDataWorker : BackgroundService
    {
        private readonly ILogger<TourismDataWorker> _logger;
        private readonly HttpClient _httpClient;

        public TourismDataWorker(ILogger<TourismDataWorker> logger)
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
                    IRepository<TourismMetric> tourismMetricsRepo = Repository<TourismMetric>.Create();
                    ServicesHelper.ProcessNorwayTourismMetrics(ref tourismMetricsRepo);
                    ServicesHelper.ProcessSpainTourismMetrics(ref tourismMetricsRepo);
                    ServicesHelper.ProcessTurkeyTourismMetrics(ref tourismMetricsRepo);
                }
                catch
                {
                }
                await Task.Delay(TimeSpan.FromDays(7), stoppingToken);
            }
        }
    }
}