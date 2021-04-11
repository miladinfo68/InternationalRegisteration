using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Linq.Expressions;
using ISR.DAL;
using ISR.DAL.Amozesh_Initial;
using ISR.Repository.Interfaces;

namespace ISR.Repository
{
    public  class BaseRepository<T> : IRepository<T> where T : class
    {
        private readonly InitModel dbCntx = null;
        public BaseRepository()
        {            
            this.dbCntx = dbCntx ?? new InitModel();
        }
        //
        /// CRUD peration

        //CREAT
        //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        public bool AddNewItem(T entity)
        {
            try
            {
                //dbCntx.Set<T>().Add(entity);
                dbCntx.Entry(entity).State = EntityState.Added;
                return Convert.ToBoolean(dbCntx.SaveChanges());
            }
            catch (Exception x)
            {
                throw x;
            }
           
        }

        //==================
        public bool AddItemIfNotExist(object id, T entity)
        {
            try
            {
                var item = this.FindById(id);
                if (item != null) return false;

                //dbCntx.Set<T>().Add(entity);
                dbCntx.Entry(item).State = EntityState.Added;
                return Convert.ToBoolean(dbCntx.SaveChanges());
            }
            catch (Exception x)
            {
                throw x;
            }
        }


        //READ
        //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

        public virtual T FindById(object id )
        {
            try
            {
                return dbCntx.Set<T>().Find(id);
            }
            catch (Exception x)
            {
                throw x;
            }
        }
        //=====================
        public IEnumerable<T> FetchMany(Expression<Func<T, bool>> whereClause)
        {
            try
            {
                return dbCntx.Set<T>().AsNoTracking().Where(whereClause);
            }
            catch (Exception x)
            {
                throw x;
            }           
        }
        //=====================
        public T FindOne(Expression<Func<T, bool>> whereClause)
        {
            try
            {
                return dbCntx.Set<T>().AsNoTracking().FirstOrDefault(whereClause);
            }
            catch (Exception x)
            {
                throw x;
            }            
        }
        //==================
        public IEnumerable<T> FetchAll()
        {
            try
            {
                return dbCntx.Set<T>().ToList();
            }
            catch (Exception x)
            {
                throw x;
            }
        }


        //UPDATE
        //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        public bool UpdatetItem(T entity)
        {
                try
                {
                    dbCntx.Entry(entity).State = EntityState.Modified;
                    return Convert.ToBoolean(dbCntx.SaveChanges());
                }
                catch (Exception x)
                {
                    throw x;
                }
        }

        //=====================
        public object FindByIdAndUpdate(object id)
        {
            try
            {
                var entity = this.FindById(id);
                if (entity == null) return null;

                dbCntx.Entry(entity).State = EntityState.Modified;
                return dbCntx.SaveChanges();
            }
            catch (Exception x)
            {
                throw x;
            }
        }


        //DELETE
        //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        public bool FindByIdAndRemove(object id)
        {
            try
            {
                var entity = this.FindById(id);
                if (entity == null) return false;
                //dbCntx.Set<T>().Remove(item);
                dbCntx.Entry(entity).State = EntityState.Deleted;
                return Convert.ToBoolean(dbCntx.SaveChanges());
            }
            catch (Exception x)
            {
                throw x;
            }
        }

        //=====================
        public bool RemoveItem(T entity)
        {
            try
            {                
                dbCntx.Entry(entity).State = EntityState.Deleted;
                //dbCntx.Set<T>().Remove(entity);
                return Convert.ToBoolean(dbCntx.SaveChanges());
            }
            catch (Exception x)
            {
                throw x;
            }
        }

        //public bool RemoveItems(T entity)
        //{
        //    try
        //    {                
        //        //dbCntx.Entry(entity).State = EntityState.Deleted;
        //        dbCntx.Set<T>().Remove(entity);
        //        return Convert.ToBoolean(dbCntx.SaveChanges());
        //    }
        //    catch (Exception x)
        //    {
        //        throw x;
        //    }
        //}

        //=====================       

        public bool IsExistItem(Expression<Func<T, bool>> whereClause)
        {
            try
            {
                return dbCntx.Set<T>().Any(whereClause);
            }
            catch (Exception x)
            {
                throw x;
            }
        }

    }
}
