using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ISR.web.Models
{
    public class PrintViewModel
    {
        public decimal RequestId { get; set; }
        public string RequestStutus { get; set; }
        public DateTime CreateDate { get; set; }
        public string PeronalImagePath { get; set; }
        public string FirstName { get; set; }   
        public string LastName { get; set; }
        public string FathersName { get; set; }    
        public string FirstCitizenShip { get; set; }      
        public string IdNo { get; set; }
        public string CurrentLavel { get; set; }
        public string LastLavel { get; set; }
        public List<SelectedFieldsViewModel> CandidateFields { get; set; }

    }
}