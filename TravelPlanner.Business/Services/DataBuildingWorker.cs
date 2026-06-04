using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using System;
using System.Diagnostics;
using System.IO;
using System.Threading;
using System.Threading.Tasks;

namespace TravelPlanner.Business.Services
{
    public class DataBuildingWorker : BackgroundService
    {
        private readonly ILogger<DataBuildingWorker> _logger;

        public DataBuildingWorker(ILogger<DataBuildingWorker> logger)
        {
            _logger = logger;
        }

        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {
            while (!stoppingToken.IsCancellationRequested)
            {
                try
                {
                    string scriptPath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "App_Data", "main.py");

                    var startInfo = new ProcessStartInfo
                    {
                        FileName = "python",
                        Arguments = "\"" + scriptPath + "\"",
                        RedirectStandardOutput = false,
                        RedirectStandardError = false,
                        UseShellExecute = true,
                        CreateNoWindow = false
                    };

                    using (var process = Process.Start(startInfo))
                    {
                        if (process != null)
                        {
                            await process.WaitForExitAsync(stoppingToken);
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
    }
}