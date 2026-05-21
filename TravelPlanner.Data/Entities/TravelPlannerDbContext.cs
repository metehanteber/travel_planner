using Microsoft.EntityFrameworkCore;

namespace TravelPlanner.Data.Entities
{
    public partial class TravelPlannerDbContext : DbContext
    {
        public DbSet<Role> Roles { get; set; }
        public DbSet<User> Users { get; set; }
        public DbSet<Country> Countries { get; set; }
        public DbSet<City> Cities { get; set; }
        public DbSet<ExchangeRate> ExchangeRates { get; set; }
        public DbSet<InflationRate> InflationRates { get; set; }
        public DbSet<TourismMetric> TourismMetrics { get; set; }
        public DbSet<Forecast> Forecasts { get; set; }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured)
            {
                optionsBuilder.UseNpgsql("Host=localhost;Database=travel_planner_db;Username=postgres;Password=1234");
            }
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.Entity<Role>(entity =>
            {
                entity.ToTable("roles");
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Id).HasColumnName("id").UseIdentityAlwaysColumn();
                entity.Property(e => e.Guid).HasColumnName("guid");
                entity.Property(e => e.IsDeleted).HasColumnName("is_deleted");

                entity.Property(e => e.Name).HasColumnName("name").HasMaxLength(50).IsRequired();
            });

            modelBuilder.Entity<User>(entity =>
            {
                entity.ToTable("users");
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Id).HasColumnName("id").UseIdentityAlwaysColumn();
                entity.Property(e => e.Guid).HasColumnName("guid");
                entity.Property(e => e.IsDeleted).HasColumnName("is_deleted");

                entity.Property(e => e.RoleId).HasColumnName("role_id");
                entity.Property(e => e.Username).HasColumnName("username").HasMaxLength(50).IsRequired();
                entity.Property(e => e.PasswordHash).HasColumnName("password_hash").HasMaxLength(255).IsRequired();
                entity.Property(e => e.Email).HasColumnName("email").HasMaxLength(100).IsRequired();
                entity.Property(e => e.IsActive).HasColumnName("is_active").HasDefaultValue(true);

                entity.HasOne(d => d.Role).WithMany(p => p.Users).HasForeignKey(d => d.RoleId).OnDelete(DeleteBehavior.ClientSetNull).HasConstraintName("fk_users_roles");
            });

            modelBuilder.Entity<Country>(entity =>
            {
                entity.ToTable("countries");
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Id).HasColumnName("id").UseIdentityAlwaysColumn();
                entity.Property(e => e.Guid).HasColumnName("guid");
                entity.Property(e => e.IsDeleted).HasColumnName("is_deleted");
                entity.Property(e => e.ExchangeCode).HasColumnName("exchange_code");

                entity.Property(e => e.Name).HasColumnName("name").HasMaxLength(100).IsRequired();
                entity.Property(e => e.Code).HasColumnName("code").HasMaxLength(10).IsRequired();
            });

            modelBuilder.Entity<City>(entity =>
            {
                entity.ToTable("cities");
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Id).HasColumnName("id").UseIdentityAlwaysColumn();
                entity.Property(e => e.Guid).HasColumnName("guid");
                entity.Property(e => e.IsDeleted).HasColumnName("is_deleted");

                entity.Property(e => e.CountryId).HasColumnName("country_id");
                entity.Property(e => e.Name).HasColumnName("name").HasMaxLength(100).IsRequired();

                entity.HasOne(d => d.Country).WithMany(p => p.Cities).HasForeignKey(d => d.CountryId).OnDelete(DeleteBehavior.ClientSetNull).HasConstraintName("fk_cities_countries");
            });

            modelBuilder.Entity<ExchangeRate>(entity =>
            {
                entity.ToTable("exchange_rates");
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Id).HasColumnName("id").UseIdentityAlwaysColumn();
                entity.Property(e => e.Guid).HasColumnName("guid");
                entity.Property(e => e.IsDeleted).HasColumnName("is_deleted");

                entity.Property(e => e.CountryId).HasColumnName("country_id");
                entity.Property(e => e.BaseCurrency).HasColumnName("base_currency").HasMaxLength(10).IsRequired();
                entity.Property(e => e.TargetCurrency).HasColumnName("target_currency").HasMaxLength(10).IsRequired();
                entity.Property(e => e.Rate).HasColumnName("rate").HasColumnType("numeric(18,6)").IsRequired();
                entity.Property(e => e.DateRecorded).HasColumnName("date_recorded").HasColumnType("date").IsRequired();

                entity.HasOne(d => d.Country).WithMany(p => p.ExchangeRates).HasForeignKey(d => d.CountryId).OnDelete(DeleteBehavior.ClientSetNull).HasConstraintName("fk_exchange_rates_countries");
            });

            modelBuilder.Entity<InflationRate>(entity =>
            {
                entity.ToTable("inflation_rates");
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Id).HasColumnName("id").UseIdentityAlwaysColumn();
                entity.Property(e => e.Guid).HasColumnName("guid");
                entity.Property(e => e.IsDeleted).HasColumnName("is_deleted");

                entity.Property(e => e.CountryId).HasColumnName("country_id");
                entity.Property(e => e.Rate).HasColumnName("rate").HasColumnType("numeric(8,4)").IsRequired();
                entity.Property(e => e.DateRecorded).HasColumnName("date_recorded").HasColumnType("date").IsRequired();

                entity.HasOne(d => d.Country).WithMany(p => p.InflationRates).HasForeignKey(d => d.CountryId).OnDelete(DeleteBehavior.ClientSetNull).HasConstraintName("fk_inflation_rates_countries");
            });

            modelBuilder.Entity<TourismMetric>(entity =>
            {
                entity.ToTable("tourism_metrics");
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Id).HasColumnName("id").UseIdentityAlwaysColumn();
                entity.Property(e => e.Guid).HasColumnName("guid");
                entity.Property(e => e.IsDeleted).HasColumnName("is_deleted");
                entity.Property(e => e.CountryId).HasColumnName("country_id");

                entity.Property(e => e.CityId).HasColumnName("city_id");
                entity.Property(e => e.TouristCount).HasColumnName("tourist_count");
                entity.Property(e => e.AvgAccommodationPrice).HasColumnName("avg_accommodation_price").HasColumnType("numeric(18,2)");
                entity.Property(e => e.CurrencyUsed).HasColumnName("currency_used").HasMaxLength(10);
                entity.Property(e => e.DateRecorded).HasColumnName("date_recorded").HasColumnType("date").IsRequired();

                entity.HasOne(d => d.City).WithMany(p => p.TourismMetrics).HasForeignKey(d => d.CityId).OnDelete(DeleteBehavior.ClientSetNull).HasConstraintName("fk_tourism_metrics_cities");
            });

            modelBuilder.Entity<Forecast>(entity =>
            {
                entity.ToTable("forecasts");
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Id).HasColumnName("id").UseIdentityAlwaysColumn();
                entity.Property(e => e.Guid).HasColumnName("guid");
                entity.Property(e => e.IsDeleted).HasColumnName("is_deleted");

                entity.Property(e => e.CityId).HasColumnName("city_id");
                entity.Property(e => e.CountryId).HasColumnName("country_id");
                entity.Property(e => e.MetricType).HasColumnName("metric_type").HasMaxLength(50).IsRequired();
                entity.Property(e => e.ForecastDate).HasColumnName("forecast_date").HasColumnType("date").IsRequired();
                entity.Property(e => e.PredictedValue).HasColumnName("predicted_value").HasColumnType("numeric(18,6)").IsRequired();
                entity.Property(e => e.ModelUsed).HasColumnName("model_used").HasMaxLength(50).IsRequired();

                entity.HasOne(d => d.City).WithMany(p => p.Forecasts).HasForeignKey(d => d.CityId).OnDelete(DeleteBehavior.ClientSetNull).HasConstraintName("fk_forecasts_cities");
                entity.HasOne(d => d.Country).WithMany(p => p.Forecasts).HasForeignKey(d => d.CountryId).OnDelete(DeleteBehavior.ClientSetNull).HasConstraintName("fk_forecasts_countries");
            });
        }
    }
}