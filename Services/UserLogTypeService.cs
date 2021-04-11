using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ISR.Repository.Interfaces;
using ISR.DAL.Amozesh_Initial;

namespace ISR.Services
{
    public class UserLogTypeService : BaseService<UserLogType> ,IUserLogTypeService
    {
        public UserLogTypeService():base()
        {
        }
    }
}
