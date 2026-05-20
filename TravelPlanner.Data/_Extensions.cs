using Microsoft.VisualBasic;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TravelPlanner.Core;

namespace TravelPlanner.Data.Entities
{
    public interface IEntity { }

    public abstract class EntityBase : IEntity
    {
        public long Id { get; set; }

        public Guid Guid { get; set; }

        public bool IsDeleted { get; set; }
    }

    public partial class TravelPlannerDbContext
    {
        private static TravelPlannerDbContext? _tsins { get; set; }

        public static TravelPlannerDbContext SingleInstance
        {
            get
            {
                if (_tsins is null)
                {
                    _tsins = new TravelPlannerDbContext();
                }
                return _tsins;
            }
            set
            {
                _tsins = value ?? new TravelPlannerDbContext();
            }
        }

        public static TravelPlannerDbContext Instance
        {
            get
            {
                try
                {
                    var q = Helpers.CurrentHttpContext.GetValueFromContext<TravelPlannerDbContext>("TravelPlannerDbContext");
                    if (q is null) throw new Exception();
                    return q;
                }
                catch
                {
                    try
                    {
                        var _instance = new TravelPlannerDbContext();
                        Helpers.CurrentHttpContext.SetValueToContext("TravelPlannerDbContext", _instance);
                        return _instance;
                    }
                    catch
                    {
                        return new TravelPlannerDbContext();
                    }
                }
            }
            set
            {
                try
                {
                    var q = value;
                    if (q is null) q = new TravelPlannerDbContext();
                    Helpers.CurrentHttpContext.SetValueToContext("TravelPlannerDbContext", q);
                }
                catch
                {
                }
            }
        }

        public static TravelPlannerDbContext TransitionalInstance { get => new TravelPlannerDbContext(); }
    }

    public interface IMetrics
    {
        long CountryId { get; set; }
    }
}
