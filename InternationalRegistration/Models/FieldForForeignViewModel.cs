
namespace ISR.web.Models
{
    public class FieldForForeignViewModel
    {
        public decimal Id { get; set; }
        public string Field_Name { get; set; }
        public long? Sida_ID { get; set; }
        public string Code_Baygan { get; set; }
        public decimal? CollegeId { get; set; }
        public CollegeViewModel College { get; set; }
        public string LanguageCode { get; set; }    
    }
}