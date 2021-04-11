using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ISR.web.Models
{
    public class CitizenShipViewModel
    {
        public decimal Id { get; set; }
        public byte? DocType { get; set; }
        public string DocTypeTitle { get; set; }
        public string DocNo { get; set; }
        public System.DateTime? IssueDate { get; set; } = DateTime.Now;
        public decimal? IssuePlace { get; set; }

        public decimal? PersonId { get; set; }
        public virtual PersonViewModel Person { get; set; }

        public decimal? CountryId { get; set; }
        public virtual CountryViewModel Country { get; set; }
        public bool? Active { get; set; }
    }
}