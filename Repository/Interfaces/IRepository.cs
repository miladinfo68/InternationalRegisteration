using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

namespace ISR.Repository.Interfaces
{
    public interface IRepository<T> where T : class 
    {
        //CREATE
        bool AddNewItem(T entity);
        bool AddItemIfNotExist(object id , T entity);

        //READ
        T FindById(object id );
        T FindOne(Expression<Func<T, bool>> whereClause);
        IEnumerable<T> FetchMany(Expression<Func<T, bool>> whereClause);
        IEnumerable<T> FetchAll();
        bool IsExistItem(Expression<Func<T, bool>> whereClause);

        //Update
        bool UpdatetItem(T entity);
        object FindByIdAndUpdate(object id);
       

        //Delete
        bool RemoveItem(T entity);
        bool FindByIdAndRemove(object id);
        
    }
}
