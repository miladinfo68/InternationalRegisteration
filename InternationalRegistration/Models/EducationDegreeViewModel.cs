using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ISR.web.Models
{
    public class EducationDegreeViewModel
    {
        public decimal Id { get; set; }
        public decimal? FieldId { get; set; }
        public string FieldTitle { get; set; }
        public FieldForForeignViewModel Field { get; set; }
        public decimal? TotalAverage { get; set; }
        public decimal? WrittenAverage { get; set; }
        public decimal? EducationDegreePlace { get; set; }
        public string UniversityName { get; set; }
        public string CountryName { get; set; }
        public bool? Active { get; set; }
        public byte? Level { get; set; }
        public string LevelTitle { get; set; }
        public DateTime? EndTimeInLevel { get; set; }
    }
}