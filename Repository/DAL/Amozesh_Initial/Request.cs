namespace ISR.DAL.Amozesh_Initial
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("International.Request")]
    public partial class Request
    {
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public decimal Id { get; set; }       

        [StringLength(7)]
        public string Term { get; set; }
        public byte? Status { get; set; }
        public DateTime? CreateDate { get; set; }
        public bool? Active { get; set; }
        public byte? CurrentLevel { get; set; }
        public string Description { get; set; }

        public decimal? StudentId { get; set; }
        public virtual Student Student { get; set; }
    }
}
