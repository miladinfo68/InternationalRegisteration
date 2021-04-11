namespace ISR.DAL.Amozesh_Initial
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("International.EducationDegree")]
    public partial class EducationDegree
    {
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public decimal Id { get; set; }       
        public decimal? FieldId { get; set; }
        public decimal? TotalAverage { get; set; }
        public decimal? WrittenAverage { get; set; }
        public decimal? EducationDegreePlace { get; set; }

        [StringLength(200)]
        public string UniversityName { get; set; }

        [StringLength(200)]
        public string CountryName { get; set; }

        public bool? Active { get; set; }

        [Column(TypeName = "date")]
        public DateTime? EndTimeInLevel { get; set; }

        public byte? Level { get; set; }

        [StringLength(400)]
        public string FieldTitle { get; set; }

        public decimal? SudentId { get; set; }
        public virtual Student Student { get; set; }
    }
}
