using System.Collections.Generic;

namespace ISR.web.Models
{
    public class CountryViewModel
    {
        public decimal Id { get; set; }
        public string Name { get; set; }
        public string DisplayName { get; set; }
        public string LanguageCode { get; set; }
        public string CountryCode { get; set; }
        public bool? Active { get; set; }

        public virtual List<CitizenShipViewModel> CitizenShips { get; set; }
        public int? PhoneCode { get; set; }
    }
}