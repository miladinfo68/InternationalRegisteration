using ISR.Repository.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using ISR.Repository;

namespace ISR.Services
{
    public abstract class BaseService<T> : IService<T> where T : class 
    {
        //private readonly BaseRepository<T> repository = null;
        private readonly IRepository<T> repository;
        protected BaseService()
        {
            this.repository = this.repository ?? new BaseRepository<T>();
        }
        protected BaseService(IRepository<T> rep)
        {
            this.repository = this.repository ?? new BaseRepository<T>();
        }

        public bool AddItemIfNotExist(object id, T entity)
        {
            return repository.AddItemIfNotExist(id, entity);
            //throw new NotImplementedException();
        }

        public bool AddNewItem(T entity)
        {
            return repository.AddNewItem(entity);
            //throw new NotImplementedException();
        }

        public IEnumerable<T> FetchAll()
        {
            return repository.FetchAll().ToList();
            //throw new NotImplementedException();
        }

        public IEnumerable<T> FetchMany(Expression<Func<T, bool>> whereClause)
        {
            return repository.FetchMany(whereClause).ToList();
            //throw new NotImplementedException();
        }

        public T FindById(object id)
        {
            return repository.FindById(id);
            //throw new NotImplementedException();
        }

        public bool FindByIdAndRemove(object id)
        {
            return repository.FindByIdAndRemove(id);
            //throw new NotImplementedException();
        }

        public object FindByIdAndUpdate(object id)
        {
            return repository.FindByIdAndUpdate(id);
            //throw new NotImplementedException();
        }

        public T FindOne(Expression<Func<T, bool>> whereClause)
        {
            return repository.FindOne(whereClause);
            //throw new NotImplementedException();
        }

        public bool IsExistItem(Expression<Func<T, bool>> whereClause)
        {
            return repository.IsExistItem(whereClause);
            //throw new NotImplementedException();
        }

        public bool RemoveItem(T entity)
        {
            return repository.RemoveItem(entity);
            //throw new NotImplementedException();
        }

        public bool UpdatetItem(T entity)
        {
            return repository.UpdatetItem(entity);
            //throw new NotImplementedException();
        }
    }
}
