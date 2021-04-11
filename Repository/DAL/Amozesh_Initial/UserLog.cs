namespace ISR.DAL.Amozesh_Initial
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("International.UserLog")]
    public partial class UserLog
    {
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public decimal ID { get; set; } 
        public decimal? UserId { get; set; }
        public DateTime? LogDate { get; set; }

        [StringLength(400)]
        public string Description { get; set; }

        [StringLength(100)]
        public string IP_dev { get; set; }
        public decimal? ModifyId { get; set; }
        public decimal UserLogTypeId { get; set; }
        public virtual UserLogType UserLogType { get; set; }


    }
}
