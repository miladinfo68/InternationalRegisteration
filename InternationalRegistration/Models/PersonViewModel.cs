using ISR.web.Models;
using System.Collections.Generic;

namespace ISR.web.Models
{
    public class PersonViewModel
    {
        public decimal Id { get; set; } = -1;
        public string FirstName { get; set; }
        public string MiddleName { get; set; }
        public string LastName { get; set; }
        public string FathersName { get; set; }
        public string MothersName { get; set; }
        public string GrandFathersName { get; set; }
        public string BirthDate { get; set; }
        public string BirthPlace { get; set; }
        public byte? Gender { get; set; }
        public string GenderTitle { get; set; }
        public byte? MarritalType { get; set; }
        public string MarritalTypeTitle { get; set; }
        public string IdNo { get; set; }
        public string IssuePlace { get; set; }
        public string NationalCode { get; set; }
        public string Job { get; set; }
        public string RecommenderCode { get; set; }
        public List<CitizenShipViewModel> CitizenShips { get; set; }
        public virtual List<AddressViewModel> Addresses { get; set; }
        public virtual List<RelatedPersonViewModel> RelatedPersons { get; set; }
    }
}