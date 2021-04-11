namespace ISR.DAL.Amozesh_Initial
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("International.Person")]
    public partial class Person
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public Person()
        {
            Addresses = new HashSet<Address>();
            CitizenShips = new HashSet<CitizenShip>();
            RelatedPersons = new HashSet<RelatedPerson>();    
        }

        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public decimal Id { get; set; }

        [StringLength(100)]
        public string FirstName { get; set; }

        [StringLength(100)]
        public string LastName { get; set; }

        [StringLength(100)]
        public string FatherName { get; set; }

        [StringLength(100)]
        public string MotherName { get; set; }

        [StringLength(100)]
        public string GrandFatherName { get; set; }

        [Column(TypeName = "date")]
        public DateTime? BirthDate { get; set; }

        [StringLength(100)]
        public string BirthPlace { get; set; }

        public byte? Gender { get; set; }

        [StringLength(100)]
        public string IdNo { get; set; }

        [StringLength(10)]
        public string NationalCode { get; set; }

        public byte? MarritalType { get; set; }

        [StringLength(100)]
        public string IssuePlace { get; set; }

        public bool? Active { get; set; }

        [StringLength(100)]
        public string MiddleName { get; set; }

        [StringLength(100)]
        public string Job { get; set; }

        [StringLength(100)]
        public string RecommenderCode { get; set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Address> Addresses { get; set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<CitizenShip> CitizenShips { get; set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<RelatedPerson> RelatedPersons { get; set; }


        //public decimal? StudentId { get; set; }

        //[System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        //public virtual Student Student { get; set; }
    }
}
