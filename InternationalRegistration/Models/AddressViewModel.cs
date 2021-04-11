using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ISR.web.Models
{
    public class AddressViewModel
    {
        public decimal Id { get; set; }
        public byte? AddressType { get; set; }
        public string Province { get; set; }
        public string City { get; set; }
        public string Street { get; set; }
        public string Plaque { get; set; }
        public string PostalCode { get; set; }
        public string PhoneNo { get; set; }

        public string Email2 { get; set; }
        public string Mobile2 { get; set; }

        public string PreCodeForMobile { get; set; }
        public string PreCodeForPhoneNo { get; set; }

        public bool Active { get; set; }

        //Forien key
        public decimal? PersonId { get; set; }
        public virtual PersonViewModel Person { get; set; }
    }
}