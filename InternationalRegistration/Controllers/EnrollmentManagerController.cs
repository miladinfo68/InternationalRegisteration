using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Configuration;
using System.Web.Mvc;
using ISR.Commons;
using ISR.Commons.enums;
using ISR.DAL.Amozesh_Initial;
using ISR.Infrastrucrures;
using ISR.Models;
using ISR.Repository;
using ISR.Services;
using ISR.web.Models;
using Newtonsoft.Json.Linq;

namespace ISR.web.Controllers
{

    [CustomAuthenticationFilter]
    //[CustomAuthorize(RoleIds.Admin, RoleIds.Enrollment_Manager)]
    [CustomAuthorize]
    public class EnrollmentManagerController : Controller
    {
        #region Fields
        private readonly IRequestService _requestService;
        private readonly IStudentDocService _studentDocService;
        private readonly ICollegeService _collegeService;
        private readonly IFieldForForeignService _fieldForForeignService;
        private readonly ICountryService _countryService;
        private readonly ICandidateFieldService _condidateService;
        private readonly IStudentService _studentService;
        private readonly IPersonService _personService;
        private readonly IRelatedPersonService _relatedPersonService;
        private readonly IAddressService _addressService;
        private readonly IEducationDegreeService _educationDegreeService;
        private readonly ICitizenShipService _citizenShipService;
        private readonly INewStudentService _newStudentService;
        private readonly ISidaFieldService _sidaFieldService;
        private readonly IUserLogService _userLogService;
        private readonly IAccountService _accountService;
        //InsertToSidaRepository
        private readonly string currentTerm = WebConfigurationManager.AppSettings["Term"];
        #endregion
        #region Ctor
        public EnrollmentManagerController(IRequestService requestService
            , IStudentDocService studentDocService
            , ICollegeService collegeService
            , IFieldForForeignService fieldForForeignService
            , ICountryService countryService
            , ICandidateFieldService condidateService
            , IStudentService studentService
            , IPersonService personService
            , IRelatedPersonService relatedPersonService
            , IAddressService addressService
            , IEducationDegreeService educationDegreeService
            , ICitizenShipService citizenShipService
            , INewStudentService newStudentService
            , ISidaFieldService sidaFieldService
            , IUserLogService userLogService
            , IAccountService accountService
            )
        {
            _requestService = requestService;
            _studentDocService = studentDocService;
            _collegeService = collegeService;
            _fieldForForeignService = fieldForForeignService;
            _countryService = countryService;
            _condidateService = condidateService;
            _studentService = studentService;
            _personService = personService;
            _relatedPersonService = relatedPersonService;
            _addressService = addressService;
            _educationDegreeService = educationDegreeService;
            _citizenShipService = citizenShipService;
            _newStudentService = newStudentService;
            _sidaFieldService = sidaFieldService;
            _userLogService = userLogService;
            _accountService = accountService;
        }
        #endregion
        // GET: Expert
        public ActionResult Index()
        {
            //if (Session["UserCmsInfo"] == null)
            //{
            //    return RedirectToAction("LoginCMS", "Account", new { lang = "fa" });
            //}
            return View();
        }
        public ActionResult ReviewRequests()
        {
            //if (Session["UserCmsInfo"] == null)
            //{
            //    return RedirectToAction("LoginCMS", "Account", new { lang = "fa" });
            //}

            var enumList = new List<RequestStatusDTO>()
            {
                new RequestStatusDTO(){ID=((byte)RequestStatus.M_Final_Accepted).ToString(),DispalyName=Resources.Resources.M_Final_Accepted} ,                  //6
                new RequestStatusDTO(){ID=((byte)RequestStatus.M_Enrollment_Accepted).ToString(),DispalyName=Resources.Resources.M_Enrollment_Accepted} ,        //8
                new RequestStatusDTO(){ID=((byte)RequestStatus.M_Enrollment_Rejected).ToString(),DispalyName=Resources.Resources.M_Enrollment_Rejected} ,        //9               
            };
            var reqStatus = !string.IsNullOrEmpty(TempData["tdStatus"]?.ToString()) ? byte.Parse(TempData["tdStatus"].ToString()) : (byte)RequestStatus.M_First_Accepted;
            var term = !string.IsNullOrEmpty(TempData["tdTerm"]?.ToString()) ? TempData["tdTerm"].ToString() : currentTerm;

            ViewBag.StatusList = new SelectList(enumList, "ID", "DispalyName", reqStatus);

            var terms = _requestService.FetchAll().Select(s => s.Term).Distinct().OrderByDescending(o => o).ToList();
            var allTerms = new List<RequestStatusDTO>();
            terms.ForEach(f => allTerms.Add(new RequestStatusDTO() { ID = f.ToString(), DispalyName = f.ToString() }));

            ViewBag.Terms = new SelectList(allTerms, "ID", "DispalyName", term);
            var reqDto = new FilterRequestByParamDTO
            {
                Term = term,
                ReqStatus = reqStatus.ToString()
            };

            //string actionName = this.ControllerContext.RouteData.Values["action"].ToString();
            //string controllerName = this.ControllerContext.RouteData.Values["controller"].ToString();
            var model = new List<RequestInfoViewModel>(); //BindRequestViewModel(reqDto);
            return View(model);

        }

        //[HttpPost]
        //public JsonResult ShowRequests(FilterRequestByParamDTO req)
        //{
        //    var model = BindRequestViewModel(req);
        //    TempData["tdTerm"] = req.Term;
        //    TempData["tdStatus"] = req.ReqStatus;
        //    var res = new JsonResult { Data = new { Result = model, Message = "ok" } };
        //    return res;
        //}

        [HttpPost]
        public PartialViewResult ShowRequests(FilterRequestByParamDTO req)
        {
            var model = BindRequestViewModel(req);
            TempData["tdTerm"] = req.Term;
            TempData["tdStatus"] = req.ReqStatus;
            //BindDropDownInEnrollmanagerFile();
            return PartialView("_RequestDetailsTableEnrollment", model);
        }

        private List<RequestInfoViewModel> BindRequestViewModel(FilterRequestByParamDTO req)
        {
            var tempModel = new List<RequestInfoViewModel>();
            var finalModel = new List<RequestInfoViewModel>();

            var tterm = string.IsNullOrEmpty(req.Term) ? currentTerm : req.Term;
            var reqStatus = !string.IsNullOrEmpty(req.ReqStatus) ? Byte.Parse(req.ReqStatus) : (byte)RequestStatus.M_First_Accepted;

            //var convertedTerm = $"{tterm.Substring(0, 2)}{tterm.Substring(6, 1)}";
            //var intTerm = int.Parse(convertedTerm);

            var filteredRequestByTerm = _requestService.FetchMany(s => s.Term == req.Term && s.Status == reqStatus).Distinct().ToList();

            if (filteredRequestByTerm.Count() == 0) return finalModel;

            var newStudentsList = _newStudentService.FetchMany(n => n.RequestId != null).Distinct().ToList();


            tempModel = (from rq in filteredRequestByTerm
                         join nsl in newStudentsList on rq.Id equals nsl.RequestId
                         select new RequestInfoViewModel
                         {
                             StudentCode = nsl.stcode,
                             RequestID = nsl.RequestId.ToString(),
                             FirstName = nsl.name,
                             LastName = nsl.family,
                             FatherName = nsl.namep,
                             FieldID = nsl.idreshSazman,
                             CountryId = rq.Student.Person.CitizenShips.FirstOrDefault()?.CountryId?.ToString() ?? "-1",
                             TermInNewStudent = nsl.term.ToString(),
                             Term = rq.Term,
                             Status = rq.Status,
                             ContollerName = "EnrollmentManager",
                         }).Distinct().ToList();

            finalModel = (from sr in tempModel
                          join c in _countryService.FetchAll() on sr.CountryId equals c.Id.ToString() into countryList
                          join f in _sidaFieldService.FetchAll() on sr.FieldID equals f.CodeSazman into sidaFields
                          from src in countryList.DefaultIfEmpty()
                          from srf in sidaFields.DefaultIfEmpty()
                          select new RequestInfoViewModel
                          {
                              StudentCode = sr.StudentCode,
                              RequestID = sr.RequestID,
                              FirstName = sr.FirstName,
                              LastName = sr.LastName,
                              FatherName = sr.FatherName,
                              FieldID = sr.FieldID,
                              CountryId = sr.CountryId,
                              FieldTitle = srf != null ? srf.SidaFieldName ?? "" : "",
                              CountryTitle = src != null ? src.DisplayName ?? "" : "",

                              //FieldTitle =f.SidaFieldName , //srf != null ? srf.SidaFieldName ?? "" : "",
                              //CountryTitle =c.DisplayName , //src != null ? src.DisplayName ?? "" : "",
                              Term = sr.Term,
                              TermInNewStudent = sr.TermInNewStudent,
                              ContollerName = sr.ContollerName
                          }).Distinct().ToList();



            if (!string.IsNullOrEmpty(req.Filter?.ToString().Trim()))
            {
                if (Helpers.IsNumeric(req.Filter.ToString().Trim()))
                {
                    finalModel = finalModel.Where(w => w.StudentCode == req.Filter.ToString().Trim() || w.RequestID == req.Filter.ToString().Trim()).ToList();
                }
                else
                {
                    finalModel = finalModel.Where(w => Helpers.ToPersianLetters(w.FirstName.ToLower()).Contains(Helpers.ToPersianLetters(req.Filter.ToString().Trim().ToLower()))
                                                || Helpers.ToPersianLetters(w.LastName.ToLower()).Contains(Helpers.ToPersianLetters(req.Filter.ToString().Trim().ToLower()))
                                                || Helpers.ToPersianLetters(w.FatherName.ToLower()).Contains(Helpers.ToPersianLetters(req.Filter.ToString().Trim().ToLower()))
                                                || Helpers.ToPersianLetters(w.CountryTitle.ToLower()).Contains(Helpers.ToPersianLetters(req.Filter.ToString().Trim().ToLower()))
                                                ).ToList();
                }
            }
            return finalModel;
        }

        [HttpPost]
        public ActionResult GetRequestInfo(int id = 0, string studentCode = "0", string currentTerm = null)
        {
            if (studentCode != "0" && id > 0)
            {
                var newStudent = _newStudentService.FindOne(x => x.stcode == studentCode && x.RequestId == id);
                if (newStudent != null)
                {
                    var req = _requestService.FindById(id);
                    if (req != null)
                    {
                        var account = _accountService.FindById(req.Student.Id);
                        var passportID = req.Student?.Person?.CitizenShips?.FirstOrDefault()?.DocNo ?? "";
                        string sidaAddress = "", email = "", mobile = "", postalCode = "", telephon = "";

                        string personId = req.Student?.Person?.Id.ToString() ?? "-1";
                        var countryId = req.Student?.Person?.CitizenShips?.FirstOrDefault()?.CountryId.ToString() ?? "-1";
                        var allAddresses = personId != "-1" ? _addressService.FetchMany(x => x.PersonId.ToString() == personId) : null;

                        if (allAddresses != null && allAddresses.Count() > 0)
                        {

                            var existAddress = allAddresses.Where(w => w.AddressType == (byte)AddressType.CitizenshipResidenceAddress).FirstOrDefault() != null
                                ? allAddresses.Where(w => w.AddressType == (byte)AddressType.CitizenshipResidenceAddress).FirstOrDefault()
                                : (
                                    allAddresses.Where(w => w.AddressType == (byte)AddressType.CitizenshipWorkPlaceAddress).FirstOrDefault() != null
                                    ? allAddresses.Where(w => w.AddressType == (byte)AddressType.CitizenshipWorkPlaceAddress).FirstOrDefault()
                                    : (
                                        allAddresses.Where(w => w.AddressType == (byte)AddressType.IranResidenceAddress).FirstOrDefault() != null
                                        ? allAddresses.Where(w => w.AddressType == (byte)AddressType.IranResidenceAddress).FirstOrDefault()
                                        : allAddresses.Where(w => w.AddressType == (byte)AddressType.CitizenshipWorkPlaceAddress).FirstOrDefault()
                                    )
                                );

                            if (existAddress != null && countryId != "-1")
                            {
                                var counrtyInfo = _countryService.FindById(decimal.Parse(countryId));
                                if (counrtyInfo != null)
                                {
                                    sidaAddress = $"{counrtyInfo.DisplayName?.ToLower()}/{existAddress.Province?.ToLower()}/{existAddress.City?.ToLower()}/{existAddress.Plaque}";
                                    mobile = $"00{existAddress.PreCodeForMobile}{existAddress.Mobile ?? account?.Mobile ?? ""}";
                                    email = $"{existAddress.Email ?? account?.Email ?? ""}";
                                    telephon = $"00{existAddress.PreCodeForPhoneNo}{existAddress.PhoneNo}";
                                    postalCode = existAddress.PostalCode;
                                }
                            }
                        }

                        //var convertedTerm = $"{newStudent.term.ToString().Substring(0, 2)}-{(int.Parse(newStudent.term.ToString().Substring(0, 2)) + 1).ToString()}-{newStudent.term.ToString().Substring(2, 1)}";
                        //var studentDocs = _studentDocService.FetchMany(x => x.SudentId == req.Student.Id && x.Term == convertedTerm).Select(s => new RequestDocViewModel
                        var studentDocs = _studentDocService.FetchMany(x => x.SudentId == req.Student.Id && x.Term == currentTerm).Select(s => new RequestDocViewModel
                        {

                            Category = s.Category,
                            CategoryTitle = Resources.Resources.ResourceManager.GetString(((DocType)s.Category).ToString()),
                            DocStatus = s.DocStatus,
                            DocStatusTitle = Resources.Resources.ResourceManager.GetString(((DocStatus)s.DocStatus).ToString()),
                            FileName = s.FileName,
                            Id = s.Id,
                            Path = s.Path,
                            StudentId = s.Student.Id,
                            Term = s.Term
                        }).ToList();


                        var sidaField = _sidaFieldService.FetchMany(x => x.CodeSazman == newStudent.idreshSazman).FirstOrDefault();
                        var selectedFieldId = _condidateService.FetchMany(s => s.StudentId == req.Student.Id && s.Selected == true).FirstOrDefault()?.FieldId?.ToString() ?? "-1";
                        var fieldTitle = selectedFieldId != "-1" ? _fieldForForeignService.FindById(decimal.Parse(selectedFieldId))?.Field_Name : "";
                        var freshId = sidaField != null && !string.IsNullOrEmpty(sidaField.SidaFieldId.ToString()) ? sidaField.SidaFieldId : 0;

                        var model = new NewStudentInfoViewModel()
                        {
                            StudentDocs = studentDocs,
                            stcode = newStudent.stcode,
                            StudentId = req.Student.Id,
                            term = newStudent.term,
                            CurrentTerm = currentTerm,
                            vorodi = newStudent.vorodi,

                            //stcodeTemp = newStudent.stcodeTemp,
                            name = newStudent.name,
                            family = newStudent.family,
                            namep = newStudent.namep,
                            //idd = (string.IsNullOrEmpty(newStudent.idd_meli) || newStudent.idd_meli == "0") ? passportID ?? "0" : newStudent.idd_meli,
                            idd_meli = (string.IsNullOrEmpty(newStudent.idd_meli) || newStudent.idd_meli == "0") ? passportID ?? "0" : newStudent.idd_meli,
                            sex = newStudent.sex,
                            magh = newStudent.magh,

                            idreshSazman = newStudent.idreshSazman,
                            SidaFieldTitle = sidaField != null ? sidaField.SidaFieldName : "",
                            InteFieldId = selectedFieldId != "-1" ? selectedFieldId : "",
                            InteFielTitle = fieldTitle,

                            idresh = freshId ,
                            year_tav = newStudent.year_tav,
                            date_tav = newStudent.date_tav,
                            radif_gh = newStudent.radif_gh,
                            rotbeh_gh = newStudent.rotbeh_gh,
                            nomreh_gh = newStudent.nomreh_gh,
                            code_posti = (string.IsNullOrEmpty(newStudent.code_posti) || newStudent.code_posti == "0") ? postalCode ?? "0" : newStudent.code_posti,
                            tel = (string.IsNullOrEmpty(newStudent.tel) || newStudent.tel == "0") ? telephon ?? "0" : newStudent.tel,
                            mobile = (string.IsNullOrEmpty(newStudent.mobile) || newStudent.mobile == "0") ? mobile ?? "0" : newStudent.mobile,
                            email = (string.IsNullOrEmpty(newStudent.email) || newStudent.email == "0") ? email ?? "0" : newStudent.email,
                            //Province = newStudent.Province,
                            //City = newStudent.City,
                            addressd = (string.IsNullOrEmpty(newStudent.addressd) || newStudent.addressd == "0") ? sidaAddress ?? "0" : newStudent.addressd,
                            //enteghal = newStudent.enteghal,
                            //dateenteghal = newStudent.dateenteghal,
                            //idgeraesh = newStudent.idgeraesh,
                            //nobat = newStudent.nobat,
                            //par = newStudent.par,
                            //dav = newStudent.dav,
                            //date_sabtenam = newStudent.date_sabtenam,
                            mahal_tav = newStudent.mahal_tav,
                            mahal_sodor = newStudent.mahal_sodor,
                            tahol = newStudent.tahol,
                            end_madrak = newStudent.end_madrak,
                            din = newStudent.din,
                            resh_endmadrak = newStudent.resh_endmadrak,
                            date_endmadrak = newStudent.date_endmadrak,
                            //avrg_payeh = newStudent.avrg_payeh,
                            //dip_avrg = newStudent.dip_avrg,
                            //sahmeh = newStudent.sahmeh,
                            //sahmeh_Ostan = newStudent.sahmeh_Ostan,
                            university = newStudent.university,
                            //bomi = newStudent.bomi,
                            jesm = newStudent.jesm,
                            meliat = newStudent.meliat,
                            //job = newStudent.job,
                            //sal_vorod = newStudent.sal_vorod,
                            //janbazi_darsad = newStudent.janbazi_darsad,
                            //janbazi_nesbat = newStudent.janbazi_nesbat,
                            //janbaz_rayaneh = newStudent.janbaz_rayaneh,
                            //azadeh_modat = newStudent.azadeh_modat,
                            //nezamvazife = newStudent.nezamvazife,
                            //mahal_khedmat = newStudent.mahal_khedmat,
                            //ersal_name = newStudent.ersal_name,
                            //khedmat_add = newStudent.khedmat_add,
                            //ozv_basij = newStudent.ozv_basij,
                            //ozv_lib = newStudent.ozv_lib,
                            //status = newStudent.status,
                            //id_paziresh = newStudent.id_paziresh,
                            //IsInstallment = newStudent.IsInstallment,
                            //DataEnterDate = newStudent.DataEnterDate,
                            //permitted = newStudent.permitted,
                            //resh_mortabet = newStudent.resh_mortabet,
                            Madrak_Status = newStudent.Madrak_Status,
                            //StudentLeaveStatus = newStudent.StudentLeaveStatus,
                            //StateWelfare = newStudent.StateWelfare,
                            //StateWelfareLetter = newStudent.StateWelfareLetter,
                            //IsEmployed = newStudent.IsEmployed,
                            //StateWelfareLetterDate = newStudent.StateWelfareLetterDate,
                            //StateWelfareState = newStudent.StateWelfareState,
                            //DisabilityType = newStudent.DisabilityType,
                            //UniversityType = newStudent.UniversityType,
                            //JobProvince = newStudent.JobProvince,
                            //JobCity = newStudent.JobCity,
                            //JobAddress = newStudent.JobAddress,
                            //JobTel = newStudent.JobTel,
                            //JobPostalcode = newStudent.JobPostalcode,
                            //JobType = newStudent.JobType,
                            //JobTime = newStudent.JobTime,
                            //JobContract = newStudent.JobContract,
                            //JobPosition = newStudent.JobPosition,
                            //ConnectionType = newStudent.ConnectionType,
                            //DeviceType = newStudent.DeviceType,
                            //SpouseFirstName = newStudent.SpouseFirstName,
                            //SpouseLastName = newStudent.SpouseLastName,
                            //SpouseIsEmployed = newStudent.SpouseIsEmployed,
                            //SpouseJobTitle = newStudent.SpouseJobTitle,
                            //Accessories = newStudent.Accessories,
                            //InternetProvider = newStudent.InternetProvider,
                            //IntroductionMethod = newStudent.IntroductionMethod,
                            //LocalFacilities = newStudent.LocalFacilities,
                            //LocalFacilityUnit = newStudent.LocalFacilityUnit,
                            //ReligionBranches = newStudent.ReligionBranches,
                            //SimultaneousEntrance = newStudent.SimultaneousEntrance,
                            //SimultaneousField = newStudent.SimultaneousField,
                            //SimultaneousLevel = newStudent.SimultaneousLevel,
                            //SimultaneousUni = newStudent.SimultaneousUni,
                            //SimultaneousUniType = newStudent.SimultaneousUniType,
                            //SimultaneousStudy = newStudent.SimultaneousStudy,
                            //AcceptationDescription = newStudent.AcceptationDescription,
                            RequestId = newStudent.RequestId,
                            NewStudentId = newStudent.NewStudentId,
                        };
                        BindDropDownInEnrollManagerFile(model.sex, model.magh, (byte)Nationality.Other, (byte)SidaHealthStatus.CompleteHealth, (byte)SidaMarritalStatus.Single, (byte)Religion.Islam, model.term, model.StudentId);
                        return PartialView("_EnrollmentManager", model);
                    }

                }
            }
            return PartialView("_EnrollmentManager", null);
        }

        void BindDropDownInEnrollManagerFile(byte? sex = (byte)Gender.UnKnown, byte? level = (byte)SazmanLevels.KarshenasiArshad_Peivasteh, byte? nationality = (byte)Nationality.Other, byte? helthStatus = (byte)SidaHealthStatus.CompleteHealth, byte? marritalStatus = (byte)SidaMarritalStatus.Single, byte religion = (byte)Religion.Islam, int term = 0, decimal studentId = 0)
        {
            TempData["drpGender"] = null;
            TempData["drpSazmanLevel"] = null;
            TempData["drpNationality"] = null;
            TempData["drpSidaHealthStatus"] = null;
            TempData["drpSidaMarritalStatus"] = null;
            TempData["drpReligion"] = null;

            var drpGender = new List<DropDownViewModel>()
            {
                new DropDownViewModel(){ID=((byte)Gender.UnKnown).ToString(),DispalyName=Resources.Resources.UnKnown} ,
                new DropDownViewModel(){ID=((byte)Gender.Male).ToString(),DispalyName=Resources.Resources.Male }  ,
                new DropDownViewModel(){ID=((byte)Gender.Female).ToString(),DispalyName=Resources.Resources.Female} ,
            };
            TempData["drpGender"] = new SelectList(drpGender, "ID", "DispalyName", drpGender.FirstOrDefault(x => x.ID == sex.ToString()).ID.ToString());

            var drpSazmanLevel = new List<DropDownViewModel>()
            {
                new DropDownViewModel(){ID=((byte)SazmanLevels.UnKnown).ToString(),DispalyName=Resources.Resources.UnKnown } ,
                new DropDownViewModel(){ID=((byte)SazmanLevels.Karshenasi).ToString(),DispalyName=Resources.Resources.KarshenasiPeivasteh} ,
                new DropDownViewModel(){ID=((byte)SazmanLevels.Karshenasi_Napeivasteh).ToString(),DispalyName=Resources.Resources.KarshenasiNaPeivasteh}  ,
                new DropDownViewModel(){ID=((byte)SazmanLevels.KarshenasiArshad_Peivasteh).ToString(),DispalyName=Resources.Resources.KarshenasiArshadPeivasteh}  ,
                new DropDownViewModel(){ID=((byte)SazmanLevels.KarshenasiArshad).ToString(),DispalyName=Resources.Resources.KarshenasiArshadNaPeivasteh}  ,
                //new DropDownViewModel(){ID=((byte)SazmanLevels.PerfessionalDoctorate).ToString(),DispalyName=Resources.Resources.PerfessionalDoctorate}  ,
                //new DropDownViewModel(){ID=((byte)SazmanLevels.SpecialDoctorate).ToString(),DispalyName=Resources.Resources.SpecialDoctorate}  ,
            };
            TempData["drpSazmanLevel"] = new SelectList(drpSazmanLevel, "ID", "DispalyName", drpSazmanLevel.FirstOrDefault(x => x.ID == level.ToString()).ID.ToString());


            var drpNationality = new List<DropDownViewModel>()
            {
                new DropDownViewModel(){ID=((byte)Nationality.UnKnown).ToString(),DispalyName=Resources.Resources.UnKnown } ,
                new DropDownViewModel(){ID=((byte)Nationality.Iran).ToString(),DispalyName=Resources.Resources.Nationatity_Iran} ,
                new DropDownViewModel(){ID=((byte)Nationality.Other).ToString(),DispalyName=Resources.Resources.Nationatity_NoIran}  ,
            };
            TempData["drpNationality"] = new SelectList(drpNationality, "ID", "DispalyName", drpNationality.FirstOrDefault(x => x.ID == nationality.ToString()).ID.ToString());

            var drpSidaHealthStatus = new List<DropDownViewModel>()
            {
                new DropDownViewModel(){ID=((byte)SidaHealthStatus.OtherDisabilities).ToString(),DispalyName=Resources.Resources.UnKnown } ,
                new DropDownViewModel(){ID=((byte)SidaHealthStatus.Veteran).ToString(),DispalyName=Resources.Resources.Veteran} ,
                new DropDownViewModel(){ID=((byte)SidaHealthStatus.DisabilityOfSpeech).ToString(),DispalyName=Resources.Resources.DisabilityOfSpeech}  ,
                new DropDownViewModel(){ID=((byte)SidaHealthStatus.Deaf).ToString(),DispalyName=Resources.Resources.Deaf}  ,
                new DropDownViewModel(){ID=((byte)SidaHealthStatus.Blind).ToString(),DispalyName=Resources.Resources.Blind}  ,
                new DropDownViewModel(){ID=((byte)SidaHealthStatus.CompleteHealth).ToString(),DispalyName=Resources.Resources.CompleteHealth}  ,
                new DropDownViewModel(){ID=((byte)SidaHealthStatus.DisabilityOfMovement).ToString(),DispalyName=Resources.Resources.DisabilityOfMovement}  ,
                new DropDownViewModel(){ID=((byte)SidaHealthStatus.DisabilityOfVision).ToString(),DispalyName=Resources.Resources.DisabilityOfVision}  ,
                new DropDownViewModel(){ID=((byte)SidaHealthStatus.DisabilityOfHearing).ToString(),DispalyName=Resources.Resources.DisabilityOfHearing}  ,

            };
            TempData["drpSidaHealthStatus"] = new SelectList(drpSidaHealthStatus, "ID", "DispalyName", drpSidaHealthStatus.FirstOrDefault(x => x.ID == helthStatus.ToString()).ID.ToString());

            var drpSidaMarritalStatus = new List<DropDownViewModel>()
            {
                new DropDownViewModel(){ID=((byte)SidaMarritalStatus.UnKnown).ToString(),DispalyName=Resources.Resources.UnKnown } ,
                new DropDownViewModel(){ID=((byte)SidaMarritalStatus.Single).ToString(),DispalyName=Resources.Resources.Single} ,
                new DropDownViewModel(){ID=((byte)SidaMarritalStatus.Married).ToString(),DispalyName=Resources.Resources.Married}  ,
            };
            TempData["drpSidaMarritalStatus"] = new SelectList(drpSidaMarritalStatus, "ID", "DispalyName", drpSidaMarritalStatus.FirstOrDefault(x => x.ID == marritalStatus.ToString()).ID.ToString());


            var drpReligion = new List<DropDownViewModel>()
            {
                new DropDownViewModel(){ID=((byte)Religion.Islam).ToString(),DispalyName=Resources.Resources.Islam } ,
                new DropDownViewModel(){ID=((byte)Religion.Christian).ToString(),DispalyName=Resources.Resources.Christian} ,
                new DropDownViewModel(){ID=((byte)Religion.Jewish).ToString(),DispalyName=Resources.Resources.Jewish}  ,
                new DropDownViewModel(){ID=((byte)Religion.Zoroastrian).ToString(),DispalyName=Resources.Resources.Zoroastrian}  ,
                new DropDownViewModel(){ID=((byte)Religion.Other).ToString(),DispalyName=Resources.Resources.Other}  ,

            };
            TempData["drpReligion"] = new SelectList(drpReligion, "ID", "DispalyName", drpReligion.FirstOrDefault(x => x.ID == religion.ToString()).ID.ToString());


            //var convertedTerm = $"{term.ToString().Substring(0, 2)}-{(int.Parse(term.ToString().Substring(0, 2)) + 1).ToString()}-{term.ToString().Substring(2, 1)}";
            //var personalImage = _studentDocService.FindOne(x => x.SudentId == studentId && x.Term == convertedTerm && x.Category == (byte)DocType.PersonalPicture);

            //var pa = $"/st_documents/{convertedTerm}/{personalImage.SudentId}/{personalImage.FileName}?ts={DateTime.Now.Ticks}";
            //TempData["imageUrl"] = pa;
        }

        [HttpPost]
        public JsonResult InsertToSida(string data)
        {
            var res = new JsonResult();
            var dataObject = JObject.Parse(data);
            if (dataObject != null && !string.IsNullOrEmpty(dataObject["requestId"].ToString()))
            {
                var reqId = decimal.Parse(dataObject["requestId"].ToString());
                var req = _requestService.FindById(reqId);
                //../../../st_documents/97-98-2/20012/PersonalPicture.jpg
                var currenterm = dataObject["currentTerm"].ToString();
                var sudentDocuments = _studentDocService.FetchMany(x => x.SudentId == req.Student.Id && x.Term == currenterm
                     && (x.Category != (byte)DocType.Master && x.Category != (byte)DocType.Phd)).ToList();

                StudentDoc personalImage, baseEducationDegreeImage, citizenshipDocImage;
                string personalImagePath, baseEducationDegreeImagePath, citizenshipDocImagePath, basePath;
                byte[] byteArrayPersonalImage = null, byteArrayBaseEducationDegreeImage = null, byteArrayCitizenshipDocImage = null;
                if (sudentDocuments.Count() > 0)
                {
                    personalImage = sudentDocuments.FirstOrDefault(x => x.SudentId == req.Student.Id && x.Term == currenterm && x.Category == (byte)DocType.PersonalPicture);

                    baseEducationDegreeImage = sudentDocuments.FirstOrDefault(x => x.SudentId == req.Student.Id && x.Term == currenterm
                                && (x.Category == (byte)DocType.Diploma || x.Category == (byte)DocType.Collage || x.Category == (byte)DocType.Bachelor));

                    citizenshipDocImage = sudentDocuments.FirstOrDefault(x => x.SudentId == req.Student.Id && x.Term == currenterm
                                && (x.Category == (byte)DocType.Passport || x.Category == (byte)DocType.RefugeeBooklet || x.Category == (byte)DocType.IdentityCardOfForeignCitizens || x.Category == (byte)DocType.LimitedTransitCard));

                    basePath = $"~/st_documents/{currenterm}/{req.Student.Id}";
                    //var tt = "PersonalPicture.png";
                    //personalImagePath = Server.MapPath($"{basePath}/{tt}");
                    personalImagePath = Server.MapPath($"{basePath}/{personalImage.FileName}");
                    baseEducationDegreeImagePath = Server.MapPath($"{basePath}/{baseEducationDegreeImage.FileName}");
                    citizenshipDocImagePath = Server.MapPath($"{basePath}/{citizenshipDocImage.FileName}");


                    byteArrayPersonalImage = Helpers.ImageToByteArray(personalImagePath);
                    byteArrayBaseEducationDegreeImage = Helpers.ImageToByteArray(baseEducationDegreeImagePath);
                    byteArrayCitizenshipDocImage = Helpers.ImageToByteArray(citizenshipDocImagePath);

                }

                var picIds = dataObject["picIds"].ToString();
                int term = int.Parse(dataObject["term"]?.ToString() ?? "0");
                decimal salVorood = (term != 0 && term.ToString().Length == 3) ? decimal.Parse(term.ToString().Substring(0, 2)) : 0;
                byte nimsalVorood = (term != 0 && term.ToString().Length == 3) ? byte.Parse(term.ToString().Substring(2, 1)) : (byte)0;
                int userId = (Session["UserCmsInfo"] as UserLoginCmsViewModel)?.UserId == null ? -1 : int.Parse((Session["UserCmsInfo"] as UserLoginCmsViewModel).UserId.ToString());

                var convertedCurrentTerm = $"{currentTerm.ToString().Substring(0, 2)}{currentTerm.ToString().Substring(6, 1)}";
                var model = new InsertToSida()
                {
                    requestId = reqId,
                    term = term,
                    currenterm = convertedCurrentTerm,//dataObject["currentTerm"].ToString(),
                    stcode = dataObject["studentCode"].ToString(),
                    studentId = req.Student.Id,
                    name = dataObject["firstName"].ToString(),
                    family = dataObject["lastName"].ToString(),
                    namep = dataObject["fathersName"].ToString(),
                    idd_meli = dataObject["nationalCode"].ToString(),
                    sex = byte.Parse(dataObject["gender"].ToString()),
                    magh = byte.Parse(dataObject["sazmanLevel"].ToString()),
                    idreshSazman = dataObject["idReshSazman"].ToString(),
                    sal_vorod = salVorood,
                    nimsal_vorod = nimsalVorood,
                    date_tav = "",
                    tahol = decimal.Parse(dataObject["sidaMarritalStatus"].ToString()),
                    radif_gh = dataObject["radifGhabooli"].ToString(),
                    rotbeh_gh = dataObject["rotbehGhabooli"].ToString(),
                    nomreh_gh = dataObject["nomrehGhabooli"].ToString(),
                    tarikhmohlat = null,
                    userId = userId,
                    end_madrak = 0,
                    university = 0,
                    date_endmadrak = "",
                    resh_endmadrak = 0,
                    mahal_tav = 0,
                    mahal_sodor = 0,
                    meliat = decimal.Parse(dataObject["nationality"].ToString()),
                    jesm = decimal.Parse(dataObject["sidaHealthStatus"].ToString()),
                    sahmeh = 0,//dataObject["sahmiyeh"].ToString(),
                    addressd = dataObject["address"].ToString(),
                    tel = dataObject["telephone"].ToString(),
                    mobile = dataObject["mobile"].ToString(),
                    code_posti = dataObject["postalCode"].ToString(),
                    email = dataObject["email"].ToString(),
                    ip = Request.UserHostAddress,
                    fsf2_date_endMadrak = null,
                    fsf2_din = decimal.Parse(dataObject["religion"].ToString()),
                    fsf2_nezam = 0,
                    fsf2_radif_gh = decimal.Parse(dataObject["radifGhabooli"].ToString()),
                    fsf2_rotbeh_gh = decimal.Parse(dataObject["rotbehGhabooli"].ToString()),
                    fsf2_nomreh_gh = dataObject["nomrehGhabooli"].ToString(),
                    fsf2_addressd = dataObject["address"].ToString(),
                    fsf2_email = dataObject["email"].ToString(),
                    fsf2_code_posti = dataObject["postalCode"].ToString(),
                    fsf2_local1 = "0",
                    fsf2_Ostan = 0,
                    fsf2_Shahrestan = 0,
                    personalImage = byteArrayPersonalImage,
                    baseEducationlImage = byteArrayBaseEducationDegreeImage,
                    citizenshipDocImage = byteArrayCitizenshipDocImage
                };
                var sidaMapper = new MapperSidaAndInitialRegisterationRepository();
                var res11 = sidaMapper.InsertInToSida(model);
                //var res11 = sidaMapper.InsertInToSida2(model);

                res = new JsonResult { Data = new { Result = true, Message = res11 } };
                return res;

            }

            return new JsonResult { Data = new { Result = true, Message = Resources.Resources.InvalidRequestType } };
        }

        [HttpPost]
        public JsonResult RejectRequest(string data)
        {
            var res = new JsonResult();
            var dataObject = JObject.Parse(data);
            if (dataObject != null && !string.IsNullOrEmpty(dataObject["requestId"].ToString()) && !string.IsNullOrEmpty(dataObject["studentCode"].ToString()))
            {
                var reqId = decimal.Parse(dataObject["requestId"].ToString());
                var studentCode = decimal.Parse(dataObject["studentCode"].ToString());
                var req = _requestService.FindById(reqId);
                if (req != null)
                {
                    req.Status = (byte)RequestStatus.M_Enrollment_Rejected;
                    req.Description = dataObject["description"].ToString();
                    _requestService.UpdatetItem(req);


                }
                var newStudent = _newStudentService.FindOne(x => x.stcode == studentCode.ToString());
                if (newStudent != null)
                {
                    newStudent.status = (byte)SidaStatus.Relinquishment;
                    _newStudentService.UpdatetItem(newStudent);
                }

                var userId = (Session["UserCmsInfo"] as UserLoginCmsViewModel)?.UserId;
                var deviceIP = Request.UserHostAddress;
                var userLog = new ISR.DAL.Amozesh_Initial.UserLog()
                {
                    UserLogTypeId = (byte)LogsType.RejectRequestByInternationalEnrollment,
                    LogDate = DateTime.Now,
                    ModifyId = req.Id,
                    Description = dataObject["description"].ToString(),
                    UserId = userId,
                    IP_dev = deviceIP
                };
                _userLogService.AddNewItem(userLog);

                return new JsonResult { Data = new { Result = true, Message = "" } };
            }
            return new JsonResult { Data = new { Result = false, Message = Resources.Resources.InvalidRequestType } };
        }


        [HttpGet]
        public ActionResult NewStudents()
        {
            var messagesViewModel = new ShowMessageViewModel()
            {
                Visibility = "hideMessage",
                AlertType = "",
                Message = ""
            };
            //ViewBag.DangerMessage = "hideMessage";
            //ViewBag.SuccessMessage = "hideMessage";
            //ViewBag.ErrorMessage = "hideMessage";
            return View(messagesViewModel);
        }

        [HttpPost]
        public ActionResult NewStudents(HttpPostedFileBase flNewStudentInfo, HttpPostedFileBase flNewStudentMobile)
        //public ActionResult NewStudents()
        {
            var files = ControllerContext.RequestContext.HttpContext.Request.Files;
            long? lenFile1 = ControllerContext.RequestContext.HttpContext.Request?.Files[0]?.InputStream?.Length;
            long? lenFile2 = ControllerContext.RequestContext.HttpContext.Request?.Files[1]?.InputStream?.Length;
            var messagesViewModel = new ShowMessageViewModel();
            if (lenFile1 == 0)
            {
                //ViewBag.DangerMessage = "showMessage";
                //ViewBag.SuccessMessage = "hideMessage";
                //ViewBag.ErrorMessage = "hideMessage";

                messagesViewModel.Visibility = "showMessage";
                messagesViewModel.AlertType = "alert-danger";
                messagesViewModel.Message = "کاربر محترم لطفا فایل حاوی اطلاعات دانشجو و فایل حاوی اطلاعات تماس دانشجو را باهم بارگذاری نمایید";

                return View(messagesViewModel);
            }

            Stream file1 = files[0]?.InputStream;
            Stream file2 = files[1]?.InputStream;
            Stream largerFile = file1.Length >= file2.Length ? file1 : file2;
            Stream smallerFile = file2.Length <= file1.Length ? file2 : file1;
            //فرمت فایل اکسل اطلاعات دانشجو
            DataTable dt = new DataTable();
            dt.Columns.Add("stcode", Type.GetType("System.String"));
            dt.Columns.Add("par", Type.GetType("System.String"));
            dt.Columns.Add("dav", Type.GetType("System.String"));
            dt.Columns.Add("name", Type.GetType("System.String"));
            dt.Columns.Add("family", Type.GetType("System.String"));
            dt.Columns.Add("namep", Type.GetType("System.String"));
            dt.Columns.Add("idd", Type.GetType("System.String"));
            dt.Columns.Add("idd_meli", Type.GetType("System.String"));
            dt.Columns.Add("year_tav", Type.GetType("System.String"));
            dt.Columns.Add("sex", Type.GetType("System.String"));
            dt.Columns.Add("term", Type.GetType("System.String"));
            dt.Columns.Add("idreshSazman", Type.GetType("System.String"));
            dt.Columns.Add("magh", Type.GetType("System.String"));
            //dt.Columns.Add("par", Type.GetType("System.String"));
            dt.Columns.Add("radif_gh", Type.GetType("System.String"));
            dt.Columns.Add("nomreh_gh", Type.GetType("System.String"));
            dt.Columns.Add("rotbeh_gh", Type.GetType("System.String"));
            dt.Columns.Add("id_paziresh", Type.GetType("System.String"));
            dt.Columns.Add("AcceptationDescription", Type.GetType("System.String"));

            //contact data table
            //فرمت فایل شامل ادرس ایمل و....
            DataTable dtcontact = new DataTable();
            dtcontact.Columns.Add("stcode", Type.GetType("System.String"));
            dtcontact.Columns.Add("Tel", Type.GetType("System.String"));
            dtcontact.Columns.Add("PreCode", Type.GetType("System.String"));
            dtcontact.Columns.Add("Mobile", Type.GetType("System.String"));
            dtcontact.Columns.Add("Email", Type.GetType("System.String"));
            dtcontact.Columns.Add("Address", Type.GetType("System.String"));
            dtcontact.Columns.Add("codeposti", Type.GetType("System.String"));

            List<string> listB = new List<string>();
            using (StreamReader inputStreamReader = new StreamReader(largerFile))
            {
                var reader = inputStreamReader;
                DataRow dtRow = dt.NewRow();
                while (!reader.EndOfStream)
                {
                    string line = reader.ReadLine();
                    var values = line.Split(',');
                    List<string> listA = new List<string>();
                    for (int i = 0; i < values.Length; i++)
                    {
                        listA.Add(values[i].ToString().Replace("\"", string.Empty));
                    }
                    if (listA.Count() >= 24)
                    {

                        dtRow["stcode"] = listA[0]?.ToString().Replace("\"", string.Empty) ?? "";
                        dtRow["par"] = listA[1]?.ToString().Replace("\"", string.Empty) ?? "";
                        dtRow["dav"] = listA[2]?.ToString().Replace("\"", string.Empty) ?? "";
                        dtRow["name"] = listA[3]?.ToString().Replace("\"", string.Empty) ?? "";
                        dtRow["family"] = listA[4]?.ToString().Replace("\"", string.Empty) ?? "";
                        dtRow["namep"] = listA[5]?.ToString().Replace("\"", string.Empty) ?? "";
                        dtRow["idd"] = listA[6]?.ToString().Replace("\"", string.Empty) ?? "";
                        dtRow["idd_meli"] = listA[7]?.ToString().Replace("\"", string.Empty) ?? "";
                        dtRow["year_tav"] = listA[8]?.ToString().Replace("\"", string.Empty) ?? "";
                        dtRow["sex"] = listA[9]?.ToString().Replace("\"", string.Empty) ?? "";
                        dtRow["term"] = listA[10]?.ToString().Replace("\"", string.Empty) ?? "";
                        dtRow["idreshSazman"] = listA[12]?.ToString().Replace("\"", string.Empty) ?? "";
                        dtRow["magh"] = listA[13]?.ToString().Replace("\"", string.Empty) ?? "";
                        dtRow["radif_gh"] = listA[19]?.ToString().Replace("\"", string.Empty) ?? "";
                        dtRow["nomreh_gh"] = listA[20]?.ToString().Replace("\"", string.Empty) ?? "";
                        dtRow["id_paziresh"] = listA[16]?.ToString().Replace("\"", string.Empty) ?? "";
                        dtRow["rotbeh_gh"] = listA[21]?.ToString().Replace("\"", string.Empty) ?? "";
                        dtRow["AcceptationDescription"] = listA[15]?.ToString().Replace("\"", string.Empty) ?? "";

                        dt.Rows.Add(dtRow);
                    }
                    dtRow = dt.NewRow();
                }
            }



            using (StreamReader inputStreamReader = new StreamReader(smallerFile))//flNewStudetMobile
            {
                var reader = inputStreamReader;
                DataRow drcontact = dtcontact.NewRow();
                while (!reader.EndOfStream)
                {
                    string line = reader.ReadLine();
                    var values = line.Split(',');
                    List<string> listA = new List<string>();
                    for (int i = 0; i < values.Length; i++)
                    {
                        listA.Add(values[i].ToString().Replace("\"", string.Empty));
                    }
                    if (listA.Count() >= 7)
                    {
                        drcontact["stcode"] = listA[0]?.ToString().Replace("\"", string.Empty) ?? "";
                        drcontact["Tel"] = listA[1]?.ToString().Replace("\"", string.Empty) ?? "";
                        drcontact["PreCode"] = listA[2]?.ToString().Replace("\"", string.Empty) ?? "";
                        drcontact["Mobile"] = listA[3]?.ToString().Replace("\"", string.Empty) ?? "";
                        drcontact["Email"] = listA[4]?.ToString().Replace("\"", string.Empty) ?? "";
                        drcontact["codeposti"] = listA[5]?.ToString().Replace("\"", string.Empty) ?? "";
                        drcontact["Address"] = listA[6]?.ToString().Replace("\"", string.Empty) ?? "";
                        dtcontact.Rows.Add(drcontact);
                    }

                    drcontact = dtcontact.NewRow();

                }
            }


            try
            {
                List<ISR.Models.NewStudentVM> newStudentList = new List<ISR.Models.NewStudentVM>();
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    var st = new ISR.Models.NewStudentVM();

                    st.term = int.Parse(dt.Rows[i]["term"].ToString().Trim());
                    st.vorodi = Convert.ToInt16(dt.Rows[i]["term"].ToString().Trim().Substring(2, 1));
                    st.stcode = dt.Rows[i]["stcode"].ToString().Trim();
                    st.name = dt.Rows[i]["name"].ToString().Trim();
                    st.family = dt.Rows[i]["family"].ToString().Trim();
                    st.namep = dt.Rows[i]["namep"].ToString().Trim();
                    st.idd = dt.Rows[i]["idd"].ToString().Trim();
                    st.idd_meli = dt.Rows[i]["idd_meli"].ToString().Trim();
                    if (Convert.ToInt16(dt.Rows[i]["sex"].ToString().Trim()) == 1) st.sex = 2;
                    if (Convert.ToInt16(dt.Rows[i]["sex"].ToString().Trim()) == 2) st.sex = 1;
                    st.magh = Convert.ToInt16(dt.Rows[i]["magh"].ToString().Trim());
                    st.idreshSazman = dt.Rows[i]["idreshSazman"].ToString().Trim();
                    st.year_tav = int.Parse(dt.Rows[i]["year_tav"].ToString().Trim());
                    st.radif_gh = dt.Rows[i]["radif_gh"].ToString().Trim();
                    st.rotbeh_gh = dt.Rows[i]["rotbeh_gh"].ToString();
                    st.nomreh_gh = dt.Rows[i]["nomreh_gh"].ToString().Trim();
                    st.par = dt.Rows[i]["par"].ToString().Trim();
                    st.dav = dt.Rows[i]["dav"].ToString().Trim();
                    st.id_paziresh = int.Parse(dt.Rows[i]["id_paziresh"].ToString().Trim());

                    for (int c = 0; c < dtcontact.Rows.Count; c++)
                    {
                        if (dtcontact.Rows[c]["stcode"].ToString() == st.stcode)
                        {
                            st.tel = (string.IsNullOrEmpty(dtcontact.Rows[c]["PreCode"]?.ToString().Trim()) ? "" : dtcontact.Rows[c]["PreCode"]?.ToString().Trim())
                                            + (string.IsNullOrEmpty(dtcontact.Rows[c]["Tel"]?.ToString().Trim()) ? "0" : dtcontact.Rows[c]["Tel"]?.ToString().Trim());

                            st.mobile = string.IsNullOrEmpty(dtcontact.Rows[c]["Mobile"]?.ToString().Trim()) ? "0" : dtcontact.Rows[c]["Mobile"]?.ToString().Trim();
                            st.email = string.IsNullOrEmpty(dtcontact.Rows[c]["Email"]?.ToString().Trim()) ? "" : dtcontact.Rows[c]["Email"]?.ToString().Trim();
                            st.addressd = string.IsNullOrEmpty(dtcontact.Rows[c]["Address"]?.ToString().Trim()) ? "" : dtcontact.Rows[c]["Address"]?.ToString().Trim();
                            st.code_posti = string.IsNullOrEmpty(dtcontact.Rows[c]["codeposti"]?.ToString().Trim()) ? "" : dtcontact.Rows[c]["codeposti"]?.ToString().Trim();


                            //st.mobile = dtcontact.Rows[c]["Mobile"].ToString().Trim();
                            //st.email = dtcontact.Rows[c]["Email"].ToString().Trim();
                            //st.addressd = dtcontact.Rows[c]["Address"].ToString().Trim();
                            //st.code_posti = dtcontact.Rows[c]["codeposti"].ToString().Trim();
                            break;
                        }
                    }

                    if (st.tel == null) st.tel = "0";
                    if (st.mobile == null) st.mobile = "0";
                    if (st.email == null) st.email = "";
                    if (st.code_posti == null) st.code_posti = "";
                    if (st.addressd == null) st.addressd = "";

                    st.AcceptationDescription = string.IsNullOrEmpty(dt.Rows[i]["AcceptationDescription"]?.ToString().Trim()) ? "" : dt.Rows[i]["AcceptationDescription"].ToString().Trim();
                    newStudentList.Add(st);
                }

                if (newStudentList.Count() > 0)
                {
                    //insert data into newatudent table
                    var initialRegMapper = new MapperSidaAndInitialRegisterationRepository();
                    var res11 = initialRegMapper.InsertInToNewStudent(newStudentList);
                    if (res11 == "1")
                    {
                        messagesViewModel.Visibility = "showMessage";
                        messagesViewModel.AlertType = "alert-success";
                        messagesViewModel.Message = "اطلاعات با موفقیت بارگذاری گردید";

                        //ViewBag.SuccessMessage = "showMessage";
                        //ViewBag.DangerMessage = "hideMessage";
                        //ViewBag.ErrorMessage = "hideMessage";
                    }
                    else
                    {
                        messagesViewModel.Visibility = "showMessage";
                        messagesViewModel.AlertType = "alert-danger";
                        messagesViewModel.Message = " خطا در روند ثبت اطلاعات دانشجو";

                        //ViewBag.ErrorMessage = "showMessage";
                        //ViewBag.SuccessMessage = "hideMessage";
                        //ViewBag.DangerMessage = "hideMessage";
                    }
                }

            }
            catch (Exception ex)
            {
                throw ex;
            }

            return View(messagesViewModel);
        }


        //[HttpPost]
        //public JsonResult ChangeRequestStatus(int id = 0, int acctiontype = 0, string term = null, string studentCode = null)
        //{
        //    var status = -1;
        //    decimal logTypeId = -1;
        //    if (id > 0)
        //    {
        //        if (acctiontype == 1)//تایید اولیه
        //        {
        //            status = (byte)RequestStatus.M_First_Accepted;
        //            logTypeId = (byte)LogsType.FirstAcceptReqeustByInternationalManager;
        //        }
        //        if (acctiontype == 2)//رد
        //        {
        //            status = (byte)RequestStatus.M_Rejected;
        //            logTypeId = (byte)LogsType.RejectRequestByInternationalManager;
        //        }
        //        if (acctiontype == 3)//تایید نهایی
        //        {
        //            status = (byte)RequestStatus.M_Final_Accepted;
        //            logTypeId = (byte)LogsType.FinalAcceptRequestByInternationalManager;
        //        }

        //        if (status != -1)
        //        {
        //            if (status == (int)RequestStatus.M_Final_Accepted
        //                && !string.IsNullOrEmpty(term)
        //                && !string.IsNullOrEmpty(studentCode)
        //                && Helpers.IsNumeric(studentCode)
        //                )
        //            {
        //                var convertedTerm = $"{term.Substring(0, 2)}{term.Substring(6, 1)}";
        //                var student = _newStudentService.FindOne(s => s.stcode == studentCode && s.term.ToString() == convertedTerm);
        //                if (student != null)
        //                {
        //                    student.RequestId = decimal.Parse(id.ToString());
        //                    _newStudentService.UpdatetItem(student);
        //                }
        //            }

        //            var req = _requestService.FindById(id);
        //            if (req != null && status > 0)
        //            {
        //                req.Status = Convert.ToByte(status);
        //                _requestService.UpdatetItem(req);

        //                if (logTypeId > 0)
        //                {
        //                    var userId = (Session["UserCmsInfo"] as UserLoginCmsViewModel)?.UserId;
        //                    var deviceIP = Request.UserHostAddress;
        //                    var userLog = new UserLog()
        //                    {
        //                        LogTypeId = logTypeId,
        //                        LogDate = DateTime.Now,
        //                        ModifyId = id,
        //                        Description = $"reqId={id}",
        //                        UserId = userId,
        //                        IP_dev = deviceIP
        //                    };
        //                    _userLogService.AddNewItem(userLog);
        //                }
        //                return new JsonResult { Data = new { Result = true, Message = "ok" } };
        //            }
        //            return new JsonResult { Data = new { Result = false, Message = "Invalid" } };
        //        }
        //        return new JsonResult { Data = new { Result = false, Message = "Invalid" } };
        //    }
        //    return new JsonResult { Data = new { Result = false, Message = "Invalid" } };



        //}


    }
}