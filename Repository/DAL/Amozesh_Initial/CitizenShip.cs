namespace ISR.DAL.Amozesh_Initial
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("International.CitizenShip")]
    public partial class CitizenShip
    {
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public decimal Id { get; set; } 
        public byte? DocType { get; set; }

        [StringLength(100)]
        public string DocNo { get; set; }
        public DateTime? IssueDate { get; set; }
        public decimal? IssuePlace { get; set; }
        public bool? Active { get; set; }
        public decimal? CountryId { get; set; }
        public Country Country { get; set; }
        public decimal? PersonId { get; set; }
        public virtual Person Person { get; set; }
    }
}
