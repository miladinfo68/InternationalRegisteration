namespace ISR.DAL.Amozesh_Initial
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("International.RelatedPerson")]
    public partial class RelatedPerson
    {
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public decimal Id { get; set; }
        public decimal? RelatedPersonId { get; set; }
        public byte? MainPersonRelationType { get; set; }
        public byte? RelatedPersonRelationType { get; set; }
        public decimal? MainPersonId { get; set; }
        public Person MainPerson { get; set; }
    }
}
