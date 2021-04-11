namespace ISR.DAL.Amozesh_Initial
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("International.User")]
    public partial class User
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public User()
        {
            User_Role = new HashSet<User_Role>();
        }

        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public decimal Id { get; set; }

        [StringLength(200)]
        public string Username { get; set; }

        [StringLength(200)]
        public string DisplayName { get; set; }

        [Required]
        [StringLength(400)]
        public string Password { get; set; }

        [StringLength(400)]
        public string ResetPasswordToken { get; set; }

        public DateTime? ResetPasswordTokenExpire { get; set; }

        public DateTime? CreateDate { get; set; }

        public bool? Active { get; set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<User_Role> User_Role { get; set; }
    }
}
