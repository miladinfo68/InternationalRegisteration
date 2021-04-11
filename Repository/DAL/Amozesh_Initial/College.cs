namespace ISR.DAL.Amozesh_Initial
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("International.Colleges")]
    public partial class College
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public College()
        {
            FieldForForeigns = new HashSet<FieldForForeign>();
        }

        public decimal Id { get; set; }

        [Required]
        [StringLength(100)]
        public string CollegeName { get; set; }

        public decimal? SIDA_Code { get; set; }

        [StringLength(20)]
        public string LanguageCode { get; set; }
        public bool Active { get; set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<FieldForForeign> FieldForForeigns { get; set; }
    }
}
