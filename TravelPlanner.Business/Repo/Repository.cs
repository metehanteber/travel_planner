using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Query;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;
using TravelPlanner.Data;
using TravelPlanner.Data.Entities;

namespace TravelPlanner.Business.Repo
{
    public interface IRepository<T> where T : EntityBase
    {
        public T? Get(long id);

        public IQueryable<T> GetQueryable();

        public IQueryable<T> GetQueryable(Expression<Func<T, bool>> predicate);

        public List<T>? GetList();

        public List<T>? GetList(Expression<Func<T, bool>> predicate);

        public T Insert(T entity);

        public List<T> InsertList(List<T> entities);

        public T Update(T entity);

        public List<T> UpdateList(List<T> entities);

        public bool Delete(long id);

        public bool Delete(T entity);

        public int DeleteList(List<T> entities);

        public int DeleteList(List<long> ids);
    }


    public class Repository<T> : RepositoryBase<T, TravelPlannerDbContext> where T : EntityBase
    {
        public Repository(TravelPlannerDbContext context) : base(context) { }

        public static Repository<T, TravelPlannerDbContext> Create() => new Repository<T, TravelPlannerDbContext>(TravelPlannerDbContext.Instance);
    }

    public class Repository<T, TContext> : RepositoryBase<T, TContext> where T : EntityBase where TContext : DbContext
    {
        public Repository(TContext context) : base(context) { }
    }


    public abstract class RepositoryBase<T, TContext> : IRepository<T> where T : EntityBase where TContext : DbContext
    {
        public RepositoryBase(TContext context)
        {
            Context = context;
        }

        protected DbContext Context { get; set; }

        public IQueryable<T> GetQueryable()
        {
            return Context.Set<T>().Where(x => !x.IsDeleted);
        }

        public IQueryable<T> GetQueryable(Expression<Func<T, bool>> predicate)
        {
            return GetQueryable().Where(predicate);
        }

        public T? Get(long id)
        {
            return GetQueryable(x => x.Id == id).FirstOrDefault();
        }

        public List<T>? GetList()
        {
            return GetQueryable().ToList();
        }

        public List<T>? GetList(Expression<Func<T, bool>> predicate)
        {
            return GetQueryable(predicate).ToList();
        }

        public bool Delete(T entity)
        {
            var count = DeleteList(new List<T>() { entity });
            return count > 0;
        }

        public bool Delete(long id)
        {
            var entity = Get(id);
            if (entity is null) return false;
            return Delete(entity);
        }

        public int DeleteList(List<long> ids)
        {
            var list = GetList(x => ids.Contains(x.Id));
            if (list is null) return 0;
            return DeleteList(list);
        }

        public int DeleteList(List<T> entities)
        {
            if (entities is null || entities.Count < 1) return 0;
            foreach (var entity in entities)
            {
                var entry = Context.Entry(entity);
                if (entry is null || entry.Entity is null) return 0;
                entry.Entity.IsDeleted = true;
                entry.State = EntityState.Modified;
            }
            return Context.SaveChanges();
        }

        public T Insert(T entity)
        {
            var list = InsertList(new List<T>() { entity });
            if (list.Count < 1) throw new Exception();
            return list[0];
        }

        public List<T> InsertList(List<T> entities)
        {
            List<T> values = new List<T>();
            if (entities is null || entities.Count < 1) return values;
            foreach (T entity in entities)
            {
                if (entity.Guid == Guid.Empty) entity.Guid = Guid.NewGuid();
                var entry = Context.Entry(entity);
                entry.State = EntityState.Added;
                values.Add(entry.Entity);
            }
            var res = Context.SaveChanges();
            return res > 0 ? values : throw new Exception();
        }

        public T Update(T entity)
        {
            var list = UpdateList(new List<T>() { entity });
            if (list.Count < 1) throw new Exception();
            return list[0];
        }

        public List<T> UpdateList(List<T> entities)
        {
            List<T> values = new List<T>();
            if (entities is null || entities.Count < 1) return values;
            foreach (T entity in entities)
            {
                var entry = Context.Entry(entity);
                entry.State = EntityState.Modified;
                values.Add(entry.Entity);
            }
            return Context.SaveChanges() >= 0 ? values : throw new Exception();
        }

        public IIncludableQueryable<T, T2> Include<T2>(Expression<Func<T, T2>> preg)
        {
            return Context.Set<T>().Include(preg);
        }


    }
}
