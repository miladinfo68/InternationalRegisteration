namespace ISR.DAL.Amozesh_Initial
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("International.FieldForForeigns")]
    public partial class FieldForForeign
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public FieldForForeign()
        {
            CandidateFields = new HashSet<CandidateField>();
        }

        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public decimal Id { get; set; }

        [StringLength(300)]
        public string Field_Name { get; set; }

        [StringLength(20)]
        public string LanguageCode { get; set; }       
        public byte? FieldLevel { get; set; }
        public long? Sida_ID { get; set; }

        [StringLength(20)]
        public string Code_Baygan { get; set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<CandidateField> CandidateFields { get; set; }

        public decimal? CollegeId { get; set; }
        public virtual College College { get; set; }
    }
}
