using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ISR.Repository.Interfaces;
using System.Web;
using ISR.DAL.Amozesh_Initial;

namespace ISR.Services
{
    public class StudentDocService : BaseService<StudentDoc>  ,IStudentDocService
    {
        public StudentDocService():base(){ }
    }
}
