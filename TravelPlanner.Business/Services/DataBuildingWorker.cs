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
            _logger.LogInformation("Yapay Zeka (Python) Tetikleme Servisi başlatıldı...");

            while (!stoppingToken.IsCancellationRequested)
            {
                try
                {
                    _logger.LogInformation("ARIMA ve LSTM Hibrit tahmin modeli çalıştırılıyor...");

                    string scriptPath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "App_Data", "main.py");

                    // 2. Terminal/Komut Satırı ayarlarını yapılandır
                    var startInfo = new ProcessStartInfo
                    {
                        FileName = "python",
                        Arguments = $"\"{scriptPath}\"",
                        RedirectStandardOutput = true,
                        RedirectStandardError = true,
                        UseShellExecute = false,
                        CreateNoWindow = true
                    };

                    // 3. Process'i (İşlemi) Başlat
                    using (var process = Process.Start(startInfo))
                    {
                        if (process != null)
                        {
                            // Python'dan gelen çıktıları (Standart ve Hata) asenkron olarak oku
                            var outputTask = process.StandardOutput.ReadToEndAsync();
                            var errorTask = process.StandardError.ReadToEndAsync();

                            // İşlemin bitmesini bekle
                            await process.WaitForExitAsync(stoppingToken);

                            // Çıktıları al
                            string output = await outputTask;
                            string error = await errorTask;

                            // .NET Logger'ına yazdır
                            if (!string.IsNullOrWhiteSpace(output))
                            {
                                _logger.LogInformation($"\n--- PYTHON ÇIKTISI ---\n{output}");
                            }

                            if (!string.IsNullOrWhiteSpace(error) && process.ExitCode != 0)
                            {
                                _logger.LogError($"\n--- PYTHON HATASI ---\n{error}");
                            }

                            _logger.LogInformation($"Python scripti {process.ExitCode} çıkış kodu ile tamamlandı.");
                        }
                    }
                }
                catch (Exception ex)
                {
                    _logger.LogError($"Python modeli tetiklenirken hata oluştu: {ex.Message}");
                }

                // Bu çok ağır bir veri işleme operasyonu olduğu için haftada 1 veya 3 günde 1 çalışması mantıklıdır.
                // Test için 5 dakikaya ayarlayabilirsin: TimeSpan.FromMinutes(5)
                await Task.Delay(TimeSpan.FromDays(7), stoppingToken);
            }
        }
    }
}