using System;
using System.Collections.Generic;

namespace TravelPlanner.Data.Entities
{
    public class Role : EntityBase
    {
        public string Name { get; set; } = null!;
        public ICollection<User> Users { get; set; } = new List<User>();
    }

    public class User : EntityBase
    {
        public long RoleId { get; set; }
        public string Username { get; set; } = null!;
        public string PasswordHash { get; set; } = null!;
        public string Email { get; set; } = null!;
        public bool IsActive { get; set; }

        public Role Role { get; set; } = null!;
    }

    public class Country : EntityBase
    {
        public string Name { get; set; } = null!;
        public string Code { get; set; } = null!;
        public string? ExchangeCode { get; set; }

        public ICollection<City> Cities { get; set; } = new List<City>();
        public ICollection<ExchangeRate> ExchangeRates { get; set; } = new List<ExchangeRate>();
        public ICollection<InflationRate> InflationRates { get; set; } = new List<InflationRate>();
        public ICollection<Forecast> Forecasts { get; set; } = new List<Forecast>();
    }

    public class City : EntityBase
    {
        public long CountryId { get; set; }
        public string Name { get; set; } = null!;
        public string? AdditionalData { get; set; }

        public Country Country { get; set; } = null!;
        public ICollection<TourismMetric> TourismMetrics { get; set; } = new List<TourismMetric>();
        public ICollection<Forecast> Forecasts { get; set; } = new List<Forecast>();
    }

    public class ExchangeRate : EntityBase, IMetrics
    {
        public long CountryId { get; set; }
        public string BaseCurrency { get; set; } = null!;
        public string TargetCurrency { get; set; } = null!;
        public decimal Rate { get; set; }
        public DateTime DateRecorded { get; set; }

        public Country Country { get; set; } = null!;
    }

    public class InflationRate : EntityBase, IMetrics
    {
        public long CountryId { get; set; }
        public decimal Rate { get; set; }
        public DateTime DateRecorded { get; set; }

        public Country Country { get; set; } = null!;
    }

    public class TourismMetric : EntityBase, IMetrics
    {
        public long CityId { get; set; }
        public int? TouristCount { get; set; }
        public decimal? AvgAccommodationPrice { get; set; }
        public string? CurrencyUsed { get; set; }
        public DateTime DateRecorded { get; set; }

        public City City { get; set; } = null!;
        public long CountryId { get; set; }
    }

    public class Forecast : EntityBase
    {
        public long? CityId { get; set; }
        public long? CountryId { get; set; }
        public string MetricType { get; set; } = null!;
        public DateTime ForecastDate { get; set; }
        public decimal PredictedValue { get; set; }
        public string ModelUsed { get; set; } = null!;

        public City? City { get; set; }
        public Country? Country { get; set; }
    }
}