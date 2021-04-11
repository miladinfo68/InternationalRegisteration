namespace ISR.DAL.Amozesh_Initial
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("International.Address")]
    public partial class Address
    {
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public decimal Id { get; set; }  
        public byte? AddressType { get; set; }

        [StringLength(100)]
        public string Province { get; set; }

        [StringLength(100)]
        public string City { get; set; }

        [StringLength(100)]
        public string Street { get; set; }

        [StringLength(100)]
        public string Plaque { get; set; }

        [StringLength(100)]
        public string PostalCode { get; set; }

        [StringLength(30)]
        public string PhoneNo { get; set; }

        [StringLength(100)]
        public string Email { get; set; }

        [StringLength(30)]
        public string Mobile { get; set; }

        [StringLength(20)]
        public string PreCodeForMobile { get; set; }

        [StringLength(20)]
        public string PreCodeForPhoneNo { get; set; }
        public bool Active { get; set; }

        public decimal? PersonId { get; set; }
        public virtual Person Person { get; set; }
    }
}
