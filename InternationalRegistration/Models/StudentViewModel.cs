using System.Collections.Generic;

namespace ISR.web.Models
{
    public class StudentViewModel
    {
        public decimal Id { get; set; }
        public byte? MarritalStatus { get; set; }
        public byte? ChildrenCount { get; set; }
        public byte? HealthStatus { get; set; }
        public string HealthStatusTitle { get; set; }
        public byte? Religien { get; set; }
        public string ReligienTitle { get; set; }
        public string Email { get; set; }
        public string Mobile { get; set; }
        public string Language { get; set; }
        public bool Active { get; set; }
        public PersonViewModel Person { get; set; }
        public List<CandidateFieldViewModel> CandidateFields { get; set; }
        public byte? MaritalStatus { get; set; }
        public string MaritalStatusTitle { get; set; }
        public virtual List<EducationDegreeViewModel> EducationDegrees { get; set; }
    }
}