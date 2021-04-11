using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ISR.Repository.Interfaces;
using ISR.DAL.Amozesh_Initial;

namespace ISR.Services
{
    public class FieldForForeignService : BaseService<FieldForForeign> , IFieldForForeignService
    {
        public FieldForForeignService():base()
        {
        }
    }
}
