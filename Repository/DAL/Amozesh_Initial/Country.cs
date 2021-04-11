namespace ISR.DAL.Amozesh_Initial
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("International.Country")]
    public partial class Country
    {
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public decimal Id { get; set; }

        [Required]
        [StringLength(200)]
        public string Name { get; set; }

        [StringLength(100)]
        public string DisplayName { get; set; }

        [StringLength(50)]
        public string LanguageCode { get; set; }

        [StringLength(50)]
        public string CountryCode { get; set; }
        public int? PhoneCode { get; set; }
        public bool? Active { get; set; }
    }
}
