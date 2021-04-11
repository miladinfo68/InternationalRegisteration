using System;
using System.Collections.Generic;
using System.Data;

namespace ISR.Repository.Interfaces
{
    public interface IMapperSidaAndInitialRegisterationRepository<T ,U> where T:class where U :class
    //public interface IMapperSidaAndInitialRegisterationRepository<T> where T : class 
    {
        string InsertInToSida(T model);
        string InsertInToNewStudent(List<U> items);
        //string InsertInToNewStudent(DataTable items);
    }


}
