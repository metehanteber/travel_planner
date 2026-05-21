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
        public static string NullToEmpty(this string? value, bool autoTrim = false) => value == null ? "" : autoTrim ? value.Trim() : value;

        public static T? Convert<T>(this object? value) where T : struct, IConvertible
        {
            try
            {
                if (value is null) return null;
                return (T?)System.Convert.ChangeType(value, typeof(T));
            }
            catch
            {
                return null;
            }
        }

        public static bool IsBetween<T>(this T value, T min, T max) where T : IComparable => value.CompareTo(min) >= 0 && value.CompareTo(max) <= 0;

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

        public static List<T> GetMutualValues<T>(List<T>? list1, List<T>? list2)
        {
            if (list1 == null || list2 == null || list1.Count < 1 || list2.Count < 1) return new List<T>();
            return list1.Where(list2.Contains).ToList();
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
    }
}
