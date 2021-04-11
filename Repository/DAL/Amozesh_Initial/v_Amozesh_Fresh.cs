namespace ISR.DAL.Amozesh_Initial
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("International.v_Amozesh_Fresh")]
    public partial class v_Amozesh_Fresh
    {
        [Key]
        [Column(TypeName = "numeric")]
        public decimal SidaFieldId { get; set; }     
        public string SidaFieldName { get; set; }       
        public string CodeSazman { get; set; }
    }
}
