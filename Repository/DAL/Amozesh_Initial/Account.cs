namespace ISR.DAL.Amozesh_Initial
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("International.Account")]
    public partial class Account
    {
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public decimal Id { get; set; }       

        [StringLength(100)]
        public string Email { get; set; }

        [Required]
        [StringLength(200)]
        public string Password { get; set; }

        [StringLength(20)]
        public string Mobile { get; set; }

        [StringLength(500)]
        public string ResetPasswordToken { get; set; }
        public DateTime? ResetPasswordTokenExpire { get; set; }
        public DateTime? CreateDate { get; set; }
        public bool Active { get; set; }

        public decimal? StudentId { get; set; }
        public virtual Student Student { get; set; }
    }
}
