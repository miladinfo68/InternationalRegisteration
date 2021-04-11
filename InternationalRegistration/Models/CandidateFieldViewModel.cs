
namespace ISR.web.Models
{
    public class CandidateFieldViewModel
    {
        public decimal Id { get; set; }
        public bool? Active { get; set; }
        public bool Selected { get; set; }
        public decimal? StudentId { get; set; }
        public virtual FieldForForeignViewModel FieldForForeign { get; set; }
    }
}