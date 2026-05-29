using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;

namespace TravelPlanner.Core
{
    public class ApiRequest
    {
        private string? _method { get; set; }
        private string? _url { get; set; }
        private string? _contentType { get; set; }
        private string? _accept { get; set; }

        private Dictionary<string, string>? _headers { get; set; }

        public string Method
        {
            get
            {
                _method = _method.NullToEmpty(true).ToUpper().Replace("İ", "I");
                if (_method == "")
                {
                    _method = "GET";
                }
                return _method;
            }
            set
            {
                _method = value.NullToEmpty(true).ToUpper().Replace("İ", "I");
                if (_method == "")
                {
                    _method = "GET";
                }
            }
        }

        public string ContentType { get => _contentType = _contentType.NullToEmpty(true).ToLower().Replace("ı", "i"); set => _contentType = value.NullToEmpty(true).ToLower().Replace("ı", "i"); }

        public string Accept { get => _accept.NullToEmpty(true).ToLower().Replace("ı", "i"); set => _accept = value.NullToEmpty(true).ToLower().Replace("ı", "i"); }

        public string Url { get => _url.NullToEmpty(true); set => _url = value.NullToEmpty(true); }

        public Dictionary<string, string> Headers
        {
            get
            {
                if (_headers is null) _headers = new Dictionary<string, string>();
                return _headers;
            }
            set
            {
                _headers = value ?? new Dictionary<string, string>();
            }
        }

        public object? ResponseData { get; set; }

        public object? Data { get; set; }

        public int? StatusCode { get; set; }

        public bool HasSent { get; set; }

        public string? ErrorMessage { get; set; }

        public T? SendAndReceive<T>()
        {
            try
            {
                ResponseData = null;
                ErrorMessage = null;
                HasSent = false;
                HasSent = false;
                StatusCode = null;
                var request = WebRequest.CreateHttp(Url);
                if (ContentType != "")
                {
                    request.ContentType = ContentType;
                }
                if (Accept != "")
                {
                    request.Accept = Accept;
                }
                request.Method = Method;

                foreach (var header in Headers)
                {
                    request.Headers.Add(header.Key, header.Value);
                }
                if (Data is not null)
                {
                    using (var writer = new StreamWriter(request.GetRequestStream()))
                    {
                        if (ContentType.StartsWith("application/json"))
                        {
                            writer.Write(JsonConvert.SerializeObject(Data));
                        }
                        else
                        {
                            writer.Write(Data.ToString());
                        }
                    }
                }
                else
                {
                    request.ContentLength = 0;
                }
                using (var response = request.GetResponse())
                {
                    using (var reader = new StreamReader(response.GetResponseStream()))
                    {
                        string text = reader.ReadToEnd().NullToEmpty();
                        if (text != "")
                        {
                            try
                            {
                                ResponseData = JsonConvert.DeserializeObject<T>(text);
                            }
                            catch
                            {
                                ResponseData = text;
                            }
                            finally
                            {
                                StatusCode = 200;
                            }
                        }
                        else
                        {
                            Data = null;
                        }
                    }
                }
                return ResponseData is not null && ResponseData is T ? (T)ResponseData : default;
            }
            catch (WebException ex)
            {
                StatusCode = ex.Status.Convert<int>();
                ErrorMessage = ex.Message.NullToEmpty(true);
                return default;
            }
            catch (Exception ex)
            {
                StatusCode = -1;
                ErrorMessage = ex.Message.NullToEmpty(true);
                return default;
            }
            finally
            {
                HasSent = true;
            }
        }

        public string SendAndReceiveRawResponse()
        {
            try
            {
                ResponseData = null;
                ErrorMessage = null;
                HasSent = false;
                HasSent = false;
                StatusCode = null;
                var request = WebRequest.CreateHttp(Url);
                if (ContentType != "")
                {
                    request.ContentType = ContentType;
                }
                if (Accept != "")
                {
                    request.Accept = Accept;
                }
                request.Method = Method;

                foreach (var header in Headers)
                {
                    request.Headers.Add(header.Key, header.Value);
                }
                if (Data is not null)
                {
                    using (var writer = new StreamWriter(request.GetRequestStream()))
                    {
                        if (ContentType.StartsWith("application/json"))
                        {
                            writer.Write(JsonConvert.SerializeObject(Data));
                        }
                        else
                        {
                            writer.Write(Data.ToString());
                        }
                    }
                }
                else
                {
                    request.ContentLength = 0;
                }
                using (var response = request.GetResponse())
                {
                    using (var reader = new StreamReader(response.GetResponseStream()))
                    {
                        ResponseData = reader.ReadToEnd().NullToEmpty();
                        StatusCode = 200;
                    }
                }
                return ResponseData.AsString();
            }
            catch (WebException ex)
            {
                StatusCode = ex.Status.Convert<int>();
                ErrorMessage = ex.Message.NullToEmpty(true);
                return "";
            }
            catch (Exception ex)
            {
                StatusCode = -1;
                ErrorMessage = ex.Message.NullToEmpty(true);
                return "";
            }
            finally
            {
                HasSent = true;
            }
        }
    }
}
