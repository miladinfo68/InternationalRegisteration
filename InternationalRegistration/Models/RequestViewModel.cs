using System;
using System.Collections.Generic;


namespace ISR.web.Models
{
    public class RequestViewModel
    {
        public decimal Id { get; set; }
        public DateTime CreateDate { get; set; }
        public string Term { get; set; }
        public byte? CurrentLevel { get; set; }
        public int Status { get; set; }
        public string StatusName { get; set; }
        public string Discription { get; set; }
        public string AlertMessage { get; set; }
        public string TargetLevel { get; set; }      
        public List<RequestDocViewModel> Documents { get; set; }
        public StudentViewModel Student { get; set; }
    }
}