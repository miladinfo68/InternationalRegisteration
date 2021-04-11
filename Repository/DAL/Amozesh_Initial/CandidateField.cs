namespace ISR.DAL.Amozesh_Initial
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("International.CandidateField")]
    public partial class CandidateField
    {
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public decimal Id { get; set; }
        public decimal? FieldId { get; set; }
        public bool? Active { get; set; }
        public bool Selected { get; set; }
        public virtual FieldForForeign FieldForForeign { get; set; }
        public decimal? StudentId { get; set; }
        public virtual Student Student { get; set; }
    }
}
