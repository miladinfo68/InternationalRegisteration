using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ISR.web.Models
{
    public class RelatedPersonViewModel
    {
        public decimal Id { get; set; }
        public decimal? MainPersonId { get; set; }
        public decimal? RelatedPersonId { get; set; }
        public byte? MainPersonRelationType { get; set; }
        public byte? RelatedPersonRelationType { get; set; }
        public string MainPersonRelationTypeTitle { get; set; }
        public string RelatedPersonRelationTypeTitle { get; set; }

        public virtual PersonViewModel MainPerson { get; set; }
        public virtual PersonViewModel Person { get; set; }
    }
}