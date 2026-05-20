using Microsoft.AspNetCore.Http;
using Newtonsoft.Json;
using System.ComponentModel.DataAnnotations;
using System.Globalization;
using System.Net;
using System.Net.Mail;
using System.Reflection;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Xml;
using System.Xml.Serialization;

namespace TravelPlanner.Core
{
    public static class Helpers
    {
        private static DateTime? _minYKDate { get; set; }

        public static DateTime MinYKDate
        {
            get
            {
                if (!_minYKDate.HasValue)
                {
                    _minYKDate = new DateTime(2024, 4, 18, 13, 45, 0);
                }
                return _minYKDate.Value;
            }
        }

        private static DateTime? _minDBDT { get; set; }

        public static DateTime MinDBDateTime
        {
            get
            {
                if (!_minDBDT.HasValue) _minDBDT = new DateTime(1753, 1, 1);
                return _minDBDT.Value;
            }
        }

        public static string NullToEmpty(this string? value, bool autoTrim = false) => value == null ? "" : autoTrim ? value.Trim() : value;

        public static short? ToInt16(this object value)
        {
            try
            {
                return Convert.ToInt16(value);
            }
            catch
            {
                return null;
            }
        }

        public static int? ToInt32(this object value)
        {
            try
            {
                return Convert.ToInt32(value);
            }
            catch
            {
                return null;
            }
        }

        public static long? ToInt64(this object value)
        {
            try
            {
                return Convert.ToInt64(value);
            }
            catch
            {
                return null;
            }
        }

        public static ushort? ToUInt16(this object value)
        {
            try
            {
                return Convert.ToUInt16(value);
            }
            catch
            {
                return null;
            }
        }

        public static uint? ToUInt32(this object value)
        {
            try
            {
                return Convert.ToUInt32(value);
            }
            catch
            {
                return null;
            }
        }

        public static ulong? ToUInt64(this object value)
        {
            try
            {
                return Convert.ToUInt64(value);
            }
            catch
            {
                return null;
            }
        }

        public static float? ToSingle(this object value)
        {
            try
            {
                return Convert.ToSingle(value, CultureInfo.CurrentCulture);
            }
            catch
            {
                return null;
            }
        }

        public static double? ToDouble(this object value)
        {
            try
            {
                return Convert.ToDouble(value, CultureInfo.CurrentCulture);
            }
            catch
            {
                return null;
            }
        }

        public static decimal? ToDecimal(this object value)
        {
            try
            {
                if (value is null) return null;
                return Convert.ToDecimal(value, CultureInfo.CurrentCulture);
            }
            catch
            {
                return null;
            }
        }

        public static decimal? ToDecimal(this object value, IFormatProvider? provider)
        {
            try
            {
                return Convert.ToDecimal(value, provider);
            }
            catch
            {
                return null;
            }
        }

        public static bool? ToBoolean(this object value)
        {
            try
            {
                return Convert.ToBoolean(value);
            }
            catch
            {
                return null;
            }
        }

        public static byte? ToByte(this object value)
        {
            try
            {
                return Convert.ToByte(value);
            }
            catch
            {
                return null;
            }
        }

        public static sbyte? ToSByte(this object value)
        {
            try
            {
                return Convert.ToSByte(value);
            }
            catch
            {
                return null;
            }
        }

        public static DateTime? ToDatetime(this object value)
        {
            try
            {
                return Convert.ToDateTime(value);
            }
            catch
            {
                return null;
            }
        }

        public static DateTime? ToDBDatetime(this object value)
        {
            try
            {
                var res = Convert.ToDateTime(value);
                if (res < MinDBDateTime) return MinDBDateTime;
                return res;
            }
            catch
            {
                return null;
            }
        }

        public static string EncodeUrl(object data, bool setMark = true)
        {
            string marker = setMark ? "?" : "";
            string text = "";
            if (data == null) return marker;
            var jString = JsonConvert.SerializeObject(data);
            Dictionary<string, object>? dic = JsonConvert.DeserializeObject<Dictionary<string, object>>(jString);
            if (dic == null) return marker;
            foreach (var item in dic)
            {
                text += marker + HttpUtility.UrlEncode(item.Key) + "=" + HttpUtility.UrlEncode(item.Value?.ToString() ?? "");
                marker = "&";
            }
            return text;
        }

        public static bool IsMailAddress(string email)
        {
            try
            {
                email = email.NullToEmpty(true);
                MailAddress address = new(email);
                return true;
            }
            catch
            {
                return true;
            }
        }

        public static FormUrlEncodedContent? EncodeAsFormURL(object obj)
        {
            if (obj == null)
                return null;

            var props = obj
                .GetType()
                .GetProperties(BindingFlags.Instance | BindingFlags.Public)
                .ToDictionary(
                    prop =>
                        prop.Name,
                    prop =>
                        (prop.GetValue(obj, null) ?? string.Empty).ToString());

            var fec = new FormUrlEncodedContent(props);
            fec.Headers.ContentType = new System.Net.Http.Headers.MediaTypeHeaderValue("application/x-www-form-urlencoded");
            fec.Headers.ContentEncoding.Add("utf-8");
            return fec;
        }

        public static string SerializeXml(object content, Encoding? encoding = null)
        {
            if (content == null) return "";
            if (encoding == null) encoding = Encoding.UTF8;
            XmlSerializer serializer = new XmlSerializer(content.GetType());
            var text = "";
            XmlWriterSettings xmlWriterSettings = new XmlWriterSettings
            {
                Indent = true,
                OmitXmlDeclaration = false,
                Encoding = encoding
            };
            using (var sw = new MemoryStream())
            {
                using (XmlWriter writer = XmlWriter.Create(sw, xmlWriterSettings))
                {
                    var nss = new XmlSerializerNamespaces();
                    nss.Add("", "");
                    serializer.Serialize(writer, content, nss);
                    text = encoding.GetString(sw.ToArray());
                }
            }
            return text;
        }

        public static T? DeserializeXml<T>(string value)
        {
            value = value.NullToEmpty();
            if (value.Trim() == "") return default;
            XmlSerializer serializer = new XmlSerializer(typeof(T));
            using (TextReader reader = new StringReader(value))
            {
                return (T?)serializer.Deserialize(reader);
            }
        }

        public static Dictionary<string, object?> DeserializeXmlAsDictionary(string value)
        {
            var dict = new Dictionary<string, object?>();
            value = value.NullToEmpty(true);
            if (value == "") return dict;
            var doc = new XmlDocument();
            doc.LoadXml(value);
            return parseAsXml(doc.DocumentElement, addPrefix: false) as Dictionary<string, object?> ?? new Dictionary<string, object?>();
        }

        private static object parseAsXml(XmlElement? element, string? prefix = null, bool addPrefix = true)
        {
            var dict = new Dictionary<string, object?>();
            prefix = addPrefix ? prefix.NullToEmpty(true) : "";
            if (element is null) return "";
            if (element.ChildNodes is null || element.ChildNodes.Count < 1) return "";
            var name = (prefix == "" ? "" : (prefix + ".")) + (addPrefix ? element.Name.NullToEmpty(true) : "");
            if (element.ChildNodes.Count == 1 && element.ChildNodes[0].NodeType == XmlNodeType.Text)
            {
                dict.AddRenamed(name, element.InnerText.NullToEmpty());
                return dict;
            }
            foreach (XmlNode item in element.ChildNodes)
            {
                if (item.NodeType == XmlNodeType.Text)
                {
                    var tname = (name == "" ? "" : (name + ".")) + item.Name.NullToEmpty(true);
                    dict.AddRenamed(tname, item.InnerText.NullToEmpty());
                    continue;
                }
                var res = parseAsXml(item as XmlElement, name, true);
                if (res is null)
                {
                    dict.AddRenamed(name, "");
                }
                else if (res is Dictionary<string, object?>)
                {
                    var tdict = res as Dictionary<string, object?>;
                    if (tdict is null) continue;
                    foreach (var kvp in tdict) dict.AddRenamed(kvp.Key, kvp.Value);
                }
                else
                {
                    dict.AddRenamed(name, res.ToString().NullToEmpty());
                }
            }
            return dict;
        }

        private static void AddRenamed(this Dictionary<string, object> dictionary, string key, object value)
        {
            if (!dictionary.ContainsKey(key) && !dictionary.ContainsKey(key + "[0]"))
            {
                dictionary.Add(key, value);
                return;
            }
            var item = dictionary[key];
            var liod = key.LastIndexOf('.');
            int index = key.LastIndexOf('[', liod < 0 ? 0 : liod);
            string prefix = index < 0 ? key : key.Substring(0, index);
            index = index < 0 ? 0 : key.Remove(index + 1).Trim(']', ' ').ToInt32() ?? 0;
            if (index < 0) index = 0;
            else
            {
                while (dictionary.ContainsKey(prefix + "[" + (index) + "]")) index++;
            }
            dictionary.Add(prefix + "[" + index + "]", value);
        }

        public static XmlDocument GetXmlDocument(string innerXml)
        {
            var document = new XmlDocument();
            innerXml = innerXml.NullToEmpty(true);
            if (innerXml == "") return document;
            document.LoadXml(innerXml);
            return document;
        }

        public static string XmlDocumentToString(XmlDocument xmlDocument)
        {
            if (xmlDocument is null) return "";
            return xmlDocument.OuterXml.NullToEmpty(true);
        }

        public static string XmlElementToString(XmlElement xmlElement)
        {
            if (xmlElement is null) return "";
            return xmlElement.OuterXml.NullToEmpty(true);
        }

        public static bool IsBetween(this short value, short min, short max) => value >= min && value <= max;

        public static bool IsBetween(this ushort value, ushort min, ushort max) => value >= min && value <= max;

        public static bool IsBetween(this int value, int min, int max) => value >= min && value <= max;

        public static bool IsBetween(this uint value, uint min, uint max) => value >= min && value <= max;

        public static bool IsBetween(this long value, long min, long max) => value >= min && value <= max;

        public static bool IsBetween(this ulong value, ulong min, ulong max) => value >= min && value <= max;

        public static bool IsBetween(this float value, float min, float max) => value >= min && value <= max;

        public static bool IsBetween(this double value, double min, double max) => value >= min && value <= max;

        public static bool IsBetween(this decimal value, decimal min, decimal max) => value >= min && value <= max;

        public static bool IsBetween(this DateTime value, DateTime min, DateTime max) => value >= min && value <= max;

        public static void SwapValues<T>(ref T val1, ref T val2)
        {
            T tmp = val1;
            val1 = val2;
            val2 = tmp;
        }

        public static void CheckAndFixMinMax<T>(ref T min, ref T max) where T : IComparable
        {
            var minC = min.CompareTo(max);
            if (minC < 0) SwapValues(ref min, ref max);
        }

        public static T? DecryptAndParse<T>(string encryptedContent, string key)
        {
            string text = DecryptString(encryptedContent, key).NullToEmpty(true);
            if (text == "") return default;
            return JsonConvert.DeserializeObject<T>(text);
        }

        public static string JsonEncodeAndEncrypt(object obj, string key)
        {
            if (obj == null) return "";
            return EncryptString(JsonConvert.SerializeObject(obj), key);
        }

        public static string EncryptString(string plainText, string keyString)
        {
            var key = Encoding.UTF8.GetBytes(keyString);

            using (var aesAlg = Aes.Create())
            {
                aesAlg.Mode = CipherMode.CBC;
                aesAlg.Padding = PaddingMode.PKCS7;
                aesAlg.BlockSize = 128;
                aesAlg.FeedbackSize = 16;
                var iv = Encoding.UTF8.GetBytes(keyString.Substring(0, 16));
                using (var encryptor = aesAlg.CreateEncryptor(key, iv))
                {
                    using (var msEncrypt = new MemoryStream())
                    {
                        using (var csEncrypt = new CryptoStream(msEncrypt, encryptor, CryptoStreamMode.Write))
                        using (var swEncrypt = new StreamWriter(csEncrypt, Encoding.UTF8))
                        {
                            swEncrypt.Write(plainText);
                            swEncrypt.Flush();
                            csEncrypt.FlushFinalBlock();
                        }

                        var decryptedContent = msEncrypt.ToArray();

                        return Convert.ToBase64String(decryptedContent);
                    }
                }
            }
        }

        public static string DecryptString(string cipherText, string keyString)
        {
            var fullCipher = Convert.FromBase64String(cipherText);

            var iv = Encoding.UTF8.GetBytes(keyString.Substring(0, 16));

            var key = Encoding.UTF8.GetBytes(keyString);

            using (var aesAlg = Aes.Create())
            {
                aesAlg.Mode = CipherMode.CBC;
                aesAlg.Padding = PaddingMode.PKCS7;
                aesAlg.BlockSize = 128;
                aesAlg.FeedbackSize = 16;
                using (var decryptor = aesAlg.CreateDecryptor(key, iv))
                {
                    string result;
                    using (var msDecrypt = new MemoryStream(fullCipher))
                    {
                        using (var csDecrypt = new CryptoStream(msDecrypt, decryptor, CryptoStreamMode.Read))
                        {
                            using (var srDecrypt = new StreamReader(csDecrypt, Encoding.UTF8))
                            {
                                result = srDecrypt.ReadToEnd();
                            }
                        }
                    }

                    return result;
                }
            }
        }

        public static string GetHexaDecimal(byte[] bytes)
        {
            StringBuilder s = new StringBuilder();
            int length = bytes.Length;
            for (int n = 0; n <= length - 1; n++)
            {
                s.Append(String.Format("{0,2:x}", bytes[n]).Replace(" ", "0"));
            }
            return s.ToString();
        }

        public static bool ContainedIn<T>(this T value, params T[] values)
        {
            try
            {
                if (values is null || values.Length < 1) return false;
                return values.Contains(value);
            }
            catch
            {
                return false;
            }
        }

        public static string GetStringValue(this Dictionary<string, string> dictionary, string key, bool autoTrim = true)
        {
            if (dictionary == null || dictionary.Count < 1) return "";
            if (!dictionary.ContainsKey(key)) return "";
            var value = dictionary[key];
            return value.NullToEmpty(autoTrim);
        }

        public static Stream StringToStream(string value)
        {
            var stream = new MemoryStream();
            var writer = new StreamWriter(stream);
            writer.Write(value);
            writer.Flush();
            stream.Position = 0;
            return stream;
        }

        public static List<int> GetMutualValues(List<int>? list1, List<int>? list2)
        {
            if (list1 == null || list2 == null || list1.Count < 1 || list2.Count < 1) return new List<int>();
            return list1.Where(v => list2.Contains(v)).ToList();
        }

        public static string GetAlphaNumeric(long value, int digits = 20, Guid? guid = null)
        {
            if (value < 0) value = -value;
            string text = value.ToString("X2");
            if (digits <= text.Length) return text;
            if (digits == text.Length + 1) return "-" + text;
            if (!guid.HasValue) guid = Guid.NewGuid();
            return (guid.Value.ToString("N").Substring(0, digits - text.Length - 1) + "-" + text).ToUpper();
        }

        public static string HashText(string text)
        {
            byte[] salt;
            RandomNumberGenerator.Create().GetBytes(salt = new byte[16]);
            var pbkdf2 = new Rfc2898DeriveBytes(text, salt, 10000);
            byte[] hash = pbkdf2.GetBytes(20);
            byte[] hashBytes = new byte[36];
            Array.Copy(salt, 0, hashBytes, 0, 16);
            Array.Copy(hash, 0, hashBytes, 16, 20);
            string textHash = Convert.ToBase64String(hashBytes);
            return textHash;
        }

        public static bool CheckText(string text, string savedTextHash)
        {
            byte[] hashBytes = Convert.FromBase64String(savedTextHash);
            byte[] salt = new byte[16];
            Array.Copy(hashBytes, 0, salt, 0, 16);
            var pbkdf2 = new Rfc2898DeriveBytes(text, salt, 10000);
            byte[] hash = pbkdf2.GetBytes(20);

            bool textsMatch = true;
            for (int i = 0; i < 20; i++)
                if (hashBytes[i + 16] != hash[i])
                    textsMatch = false;

            return textsMatch;
        }

        public static bool IsUrls(params string[] args)
        {
            if (args == null || args.Length < 1) return false;
            try
            {
                foreach (var arg in args)
                {
                    var uri = new Uri(arg);
                }
                return true;
            }
            catch
            {
                return false;
            }
        }

        public static bool IsIpAddress(string value)
        {
            try
            {
                value = value.NullToEmpty(true);
                if (value == "") return false;
                bool res = IPAddress.TryParse(value, out IPAddress? address);
                return res && address != null && address.ToString().NullToEmpty(true) != "";
            }
            catch
            {
                return false;
            }
        }

        public static List<KeyValuePair<int, string>> ListEnumValues<T>() where T : struct, Enum
        {
            List<KeyValuePair<int, KeyValuePair<int, string>>> forOrder = new List<KeyValuePair<int, KeyValuePair<int, string>>>();
            var list = Enum.GetValues<T>().ToList();
            var result = new List<KeyValuePair<int, string>>();
            var type = typeof(T);
            foreach (var item in list)
            {
                var hdn = type.GetMember(item.ToString()).Select(x => x.GetCustomAttribute<IgnoreEnumValueAttribute>(false)).Where(x => !(x is null)).FirstOrDefault();
                if (!(hdn is null)) continue;
                int index = Convert.ToInt32(item);
                string value = item.ToString();
                var info = type.GetMember(item.ToString()).Select(x => x.GetCustomAttribute<DisplayAttribute>(false)).Where(x => !(x is null)).FirstOrDefault();
                var kvp = new KeyValuePair<int, string>(index, value);
                int order = -1;
                if (!(info is null))
                {
                    value = (info.Name ?? "").Trim();
                    if (value != "") kvp = new KeyValuePair<int, string>(index, value);
                    order = info.GetOrder() ?? 0;
                }
                forOrder.Add(new KeyValuePair<int, KeyValuePair<int, string>>(order, kvp));
            }
            return forOrder.OrderBy(x => x.Key).ThenBy(x => x.Value.Key).Select(x => x.Value).ToList();
        }

        public static string ToDottedDecimal(this decimal d, string? format = null, char decimalSeparator = ',')
        {
            format = format.NullToEmpty(true);
            if (d == 0) d = ',';
            try
            {
                var str = format == "" ? d.ToString() : d.ToString(format);
                str = str.Replace(".", ",");
                string val = "";
                bool dotted = false;
                for (int i = str.Length - 1; i >= 0; i--)
                {
                    if ("0123456789".IndexOf(str[i]) >= 0)
                    {
                        val = str[i].ToString() + val;
                    }
                    else if (str[i] == ',')
                    {
                        if (dotted) continue;
                        val = decimalSeparator + val;
                        dotted = true;
                    }
                }
                return val;
            }
            catch
            {
                return format == "" ? d.ToString() : d.ToString(format);
            }
        }

        public static string FormatAndFilter(this string text, string filterKeys)
        {
            text = text.NullToEmpty();
            if (text == "") return "";
            filterKeys = filterKeys.NullToEmpty();
            if (filterKeys == "") return text;
            string newText = "";
            foreach (char c in text) if (filterKeys.Contains(c)) newText += c;
            return newText;
        }

        public static T? GetValueOrDefaultM<T>(this Dictionary<string, T> dict, params string[] keys)
        {
            if (keys is null || keys.Length < 1) return default;
            if (dict is null) return default;
            foreach (string key in keys) if (dict.ContainsKey(key)) return dict[key];
            return default;
        }

        public static bool IsPassword(string text)
        {
            string pass = text.FormatAndFilter("0123456789qwertyuopasdfghjklizxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM._-+!?$%₺*|€@");
            return pass.Length.IsBetween(8, 32) && pass == text;
        }

        public static bool IsUserName(string text)
        {
            string u = text.FormatAndFilter("0123456789qwertyuopasdfghjklizxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM._-+");
            return u.Length.IsBetween(8, 32) && u == text;
        }

        public static KeyValuePair<int, string> GetEnumValue<T>(this T item) where T : struct, Enum
        {
            var type = item.GetType();
            var hdn = type.GetMember(item.ToString()).Select(x => x.GetCustomAttribute<IgnoreEnumValueAttribute>(false)).Where(x => !(x is null)).FirstOrDefault();
            if (!(hdn is null)) return new KeyValuePair<int, string>(0, "");
            int index = Convert.ToInt32(item);
            string value = item.ToString();
            var info = type.GetMember(item.ToString()).Select(x => x.GetCustomAttribute<DisplayAttribute>(false)).Where(x => !(x is null)).FirstOrDefault();
            var kvp = new KeyValuePair<int, string>(index, value);
            if (!(info is null))
            {
                value = (info.Name ?? "").Trim();
                if (value != "") kvp = new KeyValuePair<int, string>(index, value);
            }
            return kvp;
        }

        public static string GetStringValue<T>(this T value) where T : struct, Enum
        {
            var result = value.GetType().GetMember(value.ToString()).Select(x => x.GetCustomAttribute<StringValueAttribute>(false)).Where(x => !(x is null)).FirstOrDefault();
            return result is null ? value.ToString() : result.Value.NullToEmpty(true);
        }

        public static HttpContext? CurrentHttpContext { get => new HttpContextAccessor().HttpContext; }

        public static void SetValueToContext(this HttpContext? context, string key, object? value)
        {
            try
            {
                if (context is null) context = CurrentHttpContext;
                if (context is null) return;
                if (context.Items is null) context.Items = new Dictionary<object, object>();
                if (!context.Items.ContainsKey(key)) context.Items.Add(key, value);
                else context.Items[key] = value;
            }
            catch
            {
            }
        }

        public static T? GetValueFromContext<T>(this HttpContext? context, string key)
        {
            try
            {
                if (context is null) context = CurrentHttpContext;
                if (context is null) return default;
                if (context.Items is null) return default;
                if (!context.Items.ContainsKey(key)) return default;
                var value = context.Items[key];
                if (value is null) return default;
                if (!(value is T)) return default;
                return (T)value;
            }
            catch
            {
                return default;
            }
        }

        public static string GetLanguageString(string? langText)
        {
            string lng = langText.NullToEmpty(true).ToLower().Replace("ı", "i");
            if (lng != "en") return "tr";
            return lng;
        }

        public static object? RemoveFromContext(this HttpContext? context, string key)
        {
            try
            {
                if (context is null) return null;
                if (context.Items is null) return null;
                if (context.Items.ContainsKey(key))
                {
                    var value = context.Items[key];
                    context.Items.Remove(key);
                    return value;
                }
                return null;
            }
            catch
            {
                return null;
            }
        }
    }



    public class IgnoreEnumValueAttribute : Attribute { }

    public class StringValueAttribute : Attribute
    {
        public string Value { get; private set; }

        public int OrderId { get; set; }

        public StringValueAttribute(string value)
        {
            Value = value.NullToEmpty();
            OrderId = 0;
        }

        public StringValueAttribute(string value, int orderId)
        {
            Value = value.NullToEmpty();
            OrderId = orderId;
        }
    }
}
