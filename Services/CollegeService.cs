using ISR.DAL.Amozesh_Initial;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ISR.Services
{
    public class CollegeService : BaseService<College>, ICollegeService
    {
        public CollegeService() : base() { }
    }
}
