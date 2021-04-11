using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ISR.web.Models
{
    public class RequestInfoViewModel
    {
        public string RequestID { get; set; }
        public string StudentCode { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string FatherName { get; set; }
        public string FieldID { get; set; }
        public string FieldTitle { get; set; }
        public string CountryId { get; set; }
        public string CountryTitle { get; set; }

        public byte? Status { get; set; }
        public string StatusTitle { get; set; }
        public string Term { get; set; }
        public string TermInNewStudent { get; set; }
        public string ContollerName { get; set; }        
    }
}