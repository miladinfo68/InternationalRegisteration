namespace ISR.DAL.Amozesh_Initial
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("International.StudentDocs")]
    public partial class StudentDoc
    {
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public decimal Id { get; set; }        

        [StringLength(100)]
        public string FileName { get; set; }

        [StringLength(400)]
        public string Path { get; set; }
        public int? Category { get; set; }
        public byte? DocStatus { get; set; }

        [Required]
        [StringLength(7)]
        public string Term { get; set; }
        public bool? Active { get; set; }
        public string Description { get; set; }

        [Column(TypeName = "numeric")]
        public decimal? Web_msg_stu_Idnaghs { get; set; }

        public decimal? SudentId { get; set; }
        public virtual Student Student { get; set; }
        public virtual StudentDocType StudentDocType { get; set; }
    }
}
