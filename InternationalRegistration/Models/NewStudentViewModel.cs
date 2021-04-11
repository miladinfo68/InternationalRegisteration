using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ISR.web.Models
{
    public class NewStudentViewModel
    {
        public string StudentCode { get; set; }
        public string RequestId { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string FatherName { get; set; }
        public string FeildIdSazman { get; set; }
        public string FeildTitle { get; set; }
        public byte? Gender { get; set; }
        public byte? GraduateLevel { get; set; }
        public string GraduateLevelTitle { get; set; }
        public string BirthDate { get; set; }
        public string Note { get; set; }     
    }
}