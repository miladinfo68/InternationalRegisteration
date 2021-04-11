using ISR.DAL.Amozesh_Initial;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ISR.web.Models
{
    public class NewStudentInfoViewModel
    {
        public int term { get; set; }
        public byte vorodi { get; set; }
        public string stcode { get; set; }
        public decimal StudentId { get; set; }
        public string CurrentTerm { get; set; }
        public string SidaFieldTitle { get; set; }
        public string InteFieldId { get; set; }
        public string InteFielTitle { get; set; }
        //public string stcodeTemp { get; set; }
        public string name { get; set; }
        public string family { get; set; }
        public string namep { get; set; }
        //public string idd { get; set; }
        public string idd_meli { get; set; }
        public Nullable<byte> sex { get; set; }
        public Nullable<byte> magh { get; set; }
        public string idreshSazman { get; set; }
        public Nullable<decimal> idresh { get; set; }
        public Nullable<int> year_tav { get; set; }
        public string date_tav { get; set; }
        public string radif_gh { get; set; }
        public string rotbeh_gh { get; set; }
        public string nomreh_gh { get; set; }
        public string code_posti { get; set; }
        public string tel { get; set; }
        public string mobile { get; set; }
        public string email { get; set; }
        //public Nullable<byte> Province { get; set; }
        //public Nullable<int> City { get; set; }
        public string addressd { get; set; }
        //public Nullable<byte> enteghal { get; set; }
        //public string dateenteghal { get; set; }
        //public Nullable<decimal> idgeraesh { get; set; }
        //public Nullable<byte> nobat { get; set; }
        //public string par { get; set; }
        //public string dav { get; set; }
        //public string date_sabtenam { get; set; }
        public Nullable<decimal> mahal_tav { get; set; }
        public Nullable<decimal> mahal_sodor { get; set; }
        public Nullable<decimal> tahol { get; set; }
        public Nullable<decimal> end_madrak { get; set; }
        public Nullable<decimal> din { get; set; }
        public Nullable<decimal> resh_endmadrak { get; set; }
        public string date_endmadrak { get; set; }
        //public string avrg_payeh { get; set; }
        //public string dip_avrg { get; set; }
        //public Nullable<decimal> sahmeh { get; set; }
        //public string sahmeh_Ostan { get; set; }
        public Nullable<decimal> university { get; set; }
        //public Nullable<decimal> bomi { get; set; }
        public Nullable<decimal> jesm { get; set; }
        public Nullable<decimal> meliat { get; set; }
        //public string job { get; set; }
        //public Nullable<decimal> sal_vorod { get; set; }
        //public Nullable<byte> janbazi_darsad { get; set; }
        //public string janbazi_nesbat { get; set; }
        //public string janbaz_rayaneh { get; set; }
        //public Nullable<int> azadeh_modat { get; set; }
        //public Nullable<int> nezamvazife { get; set; }
        //public Nullable<int> mahal_khedmat { get; set; }
        //public Nullable<bool> ersal_name { get; set; }
        //public string khedmat_add { get; set; }
        //public Nullable<bool> ozv_basij { get; set; }
        //public Nullable<bool> ozv_lib { get; set; }
        //public Nullable<byte> status { get; set; }
        public Nullable<int> id_paziresh { get; set; }
        //public Nullable<bool> IsInstallment { get; set; }
        //public string DataEnterDate { get; set; }
        //public Nullable<bool> permitted { get; set; }
        //public Nullable<int> resh_mortabet { get; set; }
        public Nullable<int> Madrak_Status { get; set; }
        //public Nullable<int> StudentLeaveStatus { get; set; }
        //public int StateWelfare { get; set; }
        //public string StateWelfareLetter { get; set; }
        //public Nullable<bool> IsEmployed { get; set; }
        //public string StateWelfareLetterDate { get; set; }
        public Nullable<int> StateWelfareState { get; set; }
        public Nullable<int> DisabilityType { get; set; }
        public Nullable<int> UniversityType { get; set; }
        //public Nullable<int> JobProvince { get; set; }
        //public Nullable<int> JobCity { get; set; }
        //public string JobAddress { get; set; }
        //public string JobTel { get; set; }
        //public string JobPostalcode { get; set; }
        //public Nullable<int> JobType { get; set; }
        //public Nullable<int> JobTime { get; set; }
        //public Nullable<int> JobContract { get; set; }
        //public Nullable<int> JobPosition { get; set; }
        //public Nullable<int> ConnectionType { get; set; }
        //public Nullable<int> DeviceType { get; set; }
        //public string SpouseFirstName { get; set; }
        //public string SpouseLastName { get; set; }
        //public Nullable<bool> SpouseIsEmployed { get; set; }
        //public string SpouseJobTitle { get; set; }
        //public string Accessories { get; set; }
        //public Nullable<int> InternetProvider { get; set; }
        //public Nullable<int> IntroductionMethod { get; set; }
        //public string LocalFacilities { get; set; }
        //public Nullable<int> LocalFacilityUnit { get; set; }
        //public Nullable<decimal> ReligionBranches { get; set; }
        //public Nullable<decimal> SimultaneousEntrance { get; set; }
        //public Nullable<decimal> SimultaneousField { get; set; }
        //public Nullable<decimal> SimultaneousLevel { get; set; }
        //public Nullable<decimal> SimultaneousUni { get; set; }
        //public Nullable<decimal> SimultaneousUniType { get; set; }
        //public decimal SimultaneousStudy { get; set; }
        //public string AcceptationDescription { get; set; }
        public Nullable<decimal> RequestId { get; set; }
        public decimal NewStudentId { get; set; }
        public List<RequestDocViewModel> StudentDocs { get; set; }
        public List<v_Amozesh_Fresh> SidaFields { get; set; }
        public List<FieldForForeign> InternationalFields { get; set; }

    }
}