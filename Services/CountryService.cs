using ISR.DAL.Amozesh_Initial;
using ISR.Services;
using ISR.Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ISR.Services
{
    public class CountryService : BaseService<Country>, ICountryService
    {
        public CountryService() : base(){}
    }
   
}
