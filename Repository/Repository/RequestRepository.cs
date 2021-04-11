using ISR.DAL;
using ISR.DAL.Amozesh_Initial;
using ISR.Repository.Interfaces;
using System;
using System.Data.Entity;
using System.Linq;

namespace ISR.Repository
{
    public class RequestRepository : BaseRepository<Request>, IRequestRepository
    {
        private readonly InitModel dbCntx = null;
        public RequestRepository() : base()
        {
            this.dbCntx = dbCntx ?? new InitModel();
        }

        public override Request FindById(object id)
        {
            try
            {
                return dbCntx.Set<Request>()
                    .Where(w => w.Id == (decimal)id)
                    .Include(i=> i.Student)
                    .Include(i=> i.Student.Requests)
                    .Include(i=> i.Student.CandidateFields)
                    .Include(i=> i.Student.CandidateFields.Select(s=> s.FieldForForeign.College))
                    .FirstOrDefault();
            }
            catch (Exception x)
            {
                throw x;
            }
        }
    }
}
