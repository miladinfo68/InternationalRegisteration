namespace ISR.DAL.Amozesh_Initial
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("International.NewStudent")]
    public partial class NewStudent
    {
        public int term { get; set; }

        public byte vorodi { get; set; }

        [StringLength(11)]
        public string stcode { get; set; }

        [StringLength(11)]
        public string stcodeTemp { get; set; }

        [StringLength(100)]
        public string name { get; set; }

        [StringLength(200)]
        public string family { get; set; }

        [StringLength(100)]
        public string namep { get; set; }

        [StringLength(20)]
        public string idd { get; set; }

        [StringLength(20)]
        public string idd_meli { get; set; }

        public byte? sex { get; set; }

        public byte? magh { get; set; }

        [StringLength(10)]
        public string idreshSazman { get; set; }

        [Column(TypeName = "numeric")]
        public decimal? idresh { get; set; }

        public int? year_tav { get; set; }

        [StringLength(10)]
        public string date_tav { get; set; }

        [StringLength(10)]
        public string radif_gh { get; set; }

        [StringLength(10)]
        public string rotbeh_gh { get; set; }

        [StringLength(10)]
        public string nomreh_gh { get; set; }

        [StringLength(20)]
        public string code_posti { get; set; }

        [StringLength(50)]
        public string tel { get; set; }

        [StringLength(20)]
        public string mobile { get; set; }

        [StringLength(70)]
        public string email { get; set; }

        public byte? Province { get; set; }

        public int? City { get; set; }

        [StringLength(200)]
        public string addressd { get; set; }

        public byte? enteghal { get; set; }

        [StringLength(10)]
        public string dateenteghal { get; set; }

        [Column(TypeName = "numeric")]
        public decimal? idgeraesh { get; set; }

        public byte? nobat { get; set; }

        [StringLength(15)]
        public string par { get; set; }

        [StringLength(15)]
        public string dav { get; set; }

        [StringLength(10)]
        public string date_sabtenam { get; set; }

        [Column(TypeName = "numeric")]
        public decimal? mahal_tav { get; set; }

        [Column(TypeName = "numeric")]
        public decimal? mahal_sodor { get; set; }

        [Column(TypeName = "numeric")]
        public decimal? tahol { get; set; }

        [Column(TypeName = "numeric")]
        public decimal? end_madrak { get; set; }

        [Column(TypeName = "numeric")]
        public decimal? din { get; set; }

        [Column(TypeName = "numeric")]
        public decimal? resh_endmadrak { get; set; }

        [StringLength(10)]
        public string date_endmadrak { get; set; }

        [StringLength(5)]
        public string avrg_payeh { get; set; }

        [StringLength(5)]
        public string dip_avrg { get; set; }

        [Column(TypeName = "numeric")]
        public decimal? sahmeh { get; set; }

        [StringLength(50)]
        public string sahmeh_Ostan { get; set; }

        [Column(TypeName = "numeric")]
        public decimal? university { get; set; }

        [Column(TypeName = "numeric")]
        public decimal? bomi { get; set; }

        [Column(TypeName = "numeric")]
        public decimal? jesm { get; set; }

        [Column(TypeName = "numeric")]
        public decimal? meliat { get; set; }

        [StringLength(200)]
        public string job { get; set; }

        [Column(TypeName = "numeric")]
        public decimal? sal_vorod { get; set; }

        public byte? janbazi_darsad { get; set; }

        [StringLength(50)]
        public string janbazi_nesbat { get; set; }

        [StringLength(20)]
        public string janbaz_rayaneh { get; set; }

        public int? azadeh_modat { get; set; }

        public int? nezamvazife { get; set; }

        public int? mahal_khedmat { get; set; }

        public bool? ersal_name { get; set; }

        [StringLength(350)]
        public string khedmat_add { get; set; }

        public bool? ozv_basij { get; set; }

        public bool? ozv_lib { get; set; }

        public byte? status { get; set; }

        public int? id_paziresh { get; set; }

        public bool? IsInstallment { get; set; }

        [StringLength(10)]
        public string DataEnterDate { get; set; }

        public bool? permitted { get; set; }

        public int? resh_mortabet { get; set; }

        public int? Madrak_Status { get; set; }

        public int? StudentLeaveStatus { get; set; }

        public int StateWelfare { get; set; }

        [StringLength(50)]
        public string StateWelfareLetter { get; set; }

        public bool? IsEmployed { get; set; }

        [StringLength(10)]
        public string StateWelfareLetterDate { get; set; }

        public int? StateWelfareState { get; set; }

        public int? DisabilityType { get; set; }

        public int? UniversityType { get; set; }

        public int? JobProvince { get; set; }

        public int? JobCity { get; set; }

        [StringLength(200)]
        public string JobAddress { get; set; }

        [StringLength(50)]
        public string JobTel { get; set; }

        [StringLength(20)]
        public string JobPostalcode { get; set; }

        public int? JobType { get; set; }

        public int? JobTime { get; set; }

        public int? JobContract { get; set; }

        public int? JobPosition { get; set; }

        public int? ConnectionType { get; set; }

        public int? DeviceType { get; set; }

        [StringLength(30)]
        public string SpouseFirstName { get; set; }

        [StringLength(70)]
        public string SpouseLastName { get; set; }

        public bool? SpouseIsEmployed { get; set; }

        [StringLength(200)]
        public string SpouseJobTitle { get; set; }

        [StringLength(50)]
        public string Accessories { get; set; }

        public int? InternetProvider { get; set; }

        public int? IntroductionMethod { get; set; }

        [StringLength(50)]
        public string LocalFacilities { get; set; }

        public int? LocalFacilityUnit { get; set; }

        [Column(TypeName = "numeric")]
        public decimal? ReligionBranches { get; set; }

        [Column(TypeName = "numeric")]
        public decimal? SimultaneousEntrance { get; set; }

        [Column(TypeName = "numeric")]
        public decimal? SimultaneousField { get; set; }

        [Column(TypeName = "numeric")]
        public decimal? SimultaneousLevel { get; set; }

        [Column(TypeName = "numeric")]
        public decimal? SimultaneousUni { get; set; }

        [Column(TypeName = "numeric")]
        public decimal? SimultaneousUniType { get; set; }

        [Column(TypeName = "numeric")]
        public decimal SimultaneousStudy { get; set; }

        [StringLength(300)]
        public string AcceptationDescription { get; set; }

        public decimal? RequestId { get; set; }

        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public decimal NewStudentId { get; set; }
    }
}
