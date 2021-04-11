namespace ISR.DAL.Amozesh_Initial
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("International.UserAccess")]
    public partial class UserAccess
    {
        public int Id { get; set; }

        [StringLength(100)]
        public string AreaName { get; set; }

        [Required]
        [StringLength(100)]
        public string ControllerName { get; set; }

        [Required]
        [StringLength(100)]
        public string ActionName { get; set; }

        [Required]
        [StringLength(100)]
        public string ViewName { get; set; }
        public decimal RoleId { get; set; }
    }
}
