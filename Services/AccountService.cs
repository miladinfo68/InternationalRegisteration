using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ISR.DAL.Amozesh_Initial;
using ISR.Repository.Interfaces;
using ISR.Services;

namespace ISR.Services
{
    public class AccountService : BaseService<Account>, IAccountService
    {
        public AccountService() : base(){}
    }
}
