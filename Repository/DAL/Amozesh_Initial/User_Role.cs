namespace ISR.DAL.Amozesh_Initial
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("International.User_Role")]
    public partial class User_Role
    {
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public decimal Id { get; set; }
        public decimal? UserId { get; set; }
        public decimal? RoleId { get; set; }
        public virtual Role Role { get; set; }
        public virtual User User { get; set; }
    }
}
