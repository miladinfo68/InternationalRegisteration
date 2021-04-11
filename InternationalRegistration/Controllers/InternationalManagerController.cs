using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Web.Configuration;
using System.Web.Mvc;
using ISR.Commons;
using ISR.Commons.enums;
using ISR.Infrastrucrures;
using ISR.DAL.Amozesh_Initial;
using ISR.Services;
using ISR.web.Models;
using Newtonsoft.Json.Linq;

namespace ISR.web.Controllers
{

    [CustomAuthenticationFilter]
    //[CustomAuthorize(RoleIds.Admin, RoleIds.ISR_Manager)]
    [CustomAuthorize]
    public class InternationalManagerController : Controller
    {
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
        private readonly string currentTerm = WebConfigurationManager.AppSettings["Term"];


        public InternationalManagerController(IRequestService requestService
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
            , IUserLogService userLogService)
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
        }


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
                new RequestStatusDTO(){ID=((byte)RequestStatus.Ex_Accepted).ToString(),DispalyName=Resources.Resources.AcceptRequestByExpert} ,             //4
                new RequestStatusDTO(){ID=((byte)RequestStatus.M_Rejected).ToString(),DispalyName=Resources.Resources.M_Rejected} ,                         //5
                new RequestStatusDTO(){ID=((byte)RequestStatus.M_First_Accepted).ToString(),DispalyName=Resources.Resources.FirstAcceptRequestByManager} ,  //6
                //new RequestStatusDTO(){ID=((byte)RequestStatus.M_Final_Accepted).ToString(),DispalyName=Resources.Resources.FinalAcceptRequestByManager} , //7
                new RequestStatusDTO(){ID=((byte)RequestStatus.M_Enrollment_Accepted).ToString(),DispalyName=Resources.Resources.M_Enrollment_Accepted} ,   //8
                new RequestStatusDTO(){ID=((byte)RequestStatus.M_Enrollment_Rejected).ToString(),DispalyName=Resources.Resources.M_Enrollment_Rejected}     //9
            };
            var reqStatus = !string.IsNullOrEmpty(TempData["tdStatus"]?.ToString()) ? byte.Parse(TempData["tdStatus"].ToString()) : (byte)RequestStatus.Ex_Accepted;
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
            return PartialView("_RequestDetailsTable", model);
        }



        private List<RequestInfoViewModel> BindRequestViewModel(FilterRequestByParamDTO req)
        {
            var tterm = string.IsNullOrEmpty(req.Term) ? currentTerm : req.Term;
            var reqStatus2 = !string.IsNullOrEmpty(req.ReqStatus) ? Byte.Parse(req.ReqStatus) : (byte)RequestStatus.Ex_Accepted;
            var myModel = new List<RequestInfoViewModel>();
            var model = new List<RequestInfoViewModel>();
            myModel = _requestService.FetchMany(s => s.Term == req.Term && s.Status == reqStatus2).Select(s => new RequestInfoViewModel
            {
                RequestID = s.Id.ToString(),
                FirstName = s.Student.Person.FirstName,
                LastName = s.Student.Person.LastName,
                FatherName = s.Student.Person.FatherName,
                FieldID = _condidateService.FetchAll().FirstOrDefault(x => x.StudentId == s.Student.Id)?.FieldId.ToString(),
                CountryId = s.Student.Person.CitizenShips.FirstOrDefault(c => c.Person.Id == s.Student.Person.Id)?.CountryId.ToString(),
                Term = tterm,
                ContollerName = "InternationalManager"
            }).ToList();

            myModel.ForEach(xx => model.Add(new RequestInfoViewModel
            {
                RequestID = xx.RequestID,
                FirstName = xx.FirstName,
                LastName = xx.LastName,
                FatherName = xx.FatherName,
                FieldID = xx.FieldID,
                CountryId = xx.CountryId,
                CountryTitle = _countryService.FindOne(c => c.Id.ToString() == xx.CountryId)?.DisplayName ?? "-",
                FieldTitle = _fieldForForeignService.FindOne(f => f.Id.ToString() == xx.FieldID)?.Field_Name ?? "-",
                Term = xx.Term,
                ContollerName = xx.ContollerName
            }));

            if (!string.IsNullOrEmpty(req.Filter?.ToString().Trim()))
            {
                if (Helpers.IsNumeric(req.Filter.ToString().Trim()))
                {
                    model = model.Where(w => w.RequestID == req.Filter.ToString().Trim()).ToList();
                }
                else
                {
                    //myModel = myModel.Where(w => w.FirstName.Contains(req.Filter.ToString().Trim()) || w.LastName.Contains(req.Filter.ToString().Trim())).ToList();
                    model = model.Where(w => Helpers.ToPersianLetters(w.FirstName?.ToLower()).Contains(Helpers.ToPersianLetters(req.Filter.ToString().Trim().ToLower()))
                                                || Helpers.ToPersianLetters(w.LastName?.ToLower()).Contains(Helpers.ToPersianLetters(req.Filter.ToString().Trim().ToLower()))
                                                || Helpers.ToPersianLetters(w.FatherName?.ToLower()).Contains(Helpers.ToPersianLetters(req.Filter.ToString().Trim().ToLower()))
                                                || Helpers.ToPersianLetters(w.CountryTitle?.ToLower()).Contains(Helpers.ToPersianLetters(req.Filter.ToString().Trim().ToLower()))
                                                ).ToList();
                }
            }

            return model;
        }



        [HttpPost]
        public ActionResult GetRequestInfo(int id = 0, string term = null)
        {
            System.Threading.Thread.CurrentThread.CurrentCulture = new System.Globalization.CultureInfo("en-GB");
            System.Threading.Thread.CurrentThread.CurrentUICulture = new System.Globalization.CultureInfo("fa-IR");

            var reqVM = new RequestViewModel();
            if (id > 0)
            {
                var req = _requestService.FindById(id);

                if (req != null)
                {
                    CitizenShipViewModel citizenShipsVM = null;
                    CountryViewModel countryVM = null;
                    AddressViewModel addressVM = null;
                    CandidateFieldViewModel candidateFieldsVM = null;
                    FieldForForeignViewModel fieldForForeignVM = null;
                    EducationDegreeViewModel educationDegreeVM = null;
                    RequestDocViewModel documentVM = null;

                    var studentVM = new StudentViewModel();
                    var personVM = new PersonViewModel();
                    var citizenShipsListVM = new List<CitizenShipViewModel>();
                    var countryListVM = new CountryViewModel();
                    var addressListVM = new List<AddressViewModel>();
                    var candidateFieldsListVM = new List<CandidateFieldViewModel>();
                    var fieldForForeignListVM = new List<FieldForForeignViewModel>();
                    var educationDegreesListVM = new List<EducationDegreeViewModel>();
                    var documentsListVM = new List<RequestDocViewModel>();


                    var recommender = req.Student.Person.RelatedPersons?.FirstOrDefault(w => w.MainPersonRelationType == (byte)RelationType.Recommender);
                    var recommenderCode = recommender != null
                        ? _personService.FindById(recommender.RelatedPersonId).RecommenderCode ?? "--"
                        : "--";

                    reqVM.CreateDate = (DateTime)req.CreateDate;
                    reqVM.Id = req.Id;
                    reqVM.Status = Convert.ToByte(req.Status);
                    reqVM.StatusName = Resources.Resources.ResourceManager.GetString(((RequestStatus)req.Status).ToString());
                    reqVM.TargetLevel = Resources.Resources.ResourceManager.GetString((req.CurrentLevel == null ? Levels.UnKnown : (Levels)req.CurrentLevel).ToString());
                    reqVM.Discription = req.Status == (byte)RequestStatus.M_Enrollment_Rejected ? (!string.IsNullOrEmpty(req.Description) ? req.Description : "") : "";

                    //alert_danger_show is a class in requestReview view
                    reqVM.AlertMessage = req.Status == (byte)RequestStatus.M_Enrollment_Rejected ? (!string.IsNullOrEmpty(req.Description) ? "alert_danger_show" : "") : "";

                    var studentObject = _studentService.FindOne(x => x.Id == req.StudentId);
                    if (studentObject != null)
                    {
                        studentVM.ChildrenCount = studentObject.ChildrenCount ?? 0;
                        studentVM.Email = studentObject?.Email ?? "";
                        studentVM.HealthStatusTitle = studentObject.HealthStatus != null ? Resources.Resources.ResourceManager.GetString(((HealthStatus)studentObject.HealthStatus).ToString()) : Resources.Resources.ResourceManager.GetString((HealthStatus.CompleteHealth).ToString());
                        studentVM.Mobile = studentObject?.Mobile ?? "";
                        studentVM.ReligienTitle = Resources.Resources.ResourceManager.GetString(((Religion)studentObject.Religien).ToString());
                        studentVM.HealthStatus = studentObject.HealthStatus;

                        var personObject = _personService.FindOne(x => x.Id == studentObject.PersonId);
                        if (personObject != null)
                        {
                            personVM.FirstName = personObject.FirstName;
                            personVM.LastName = personObject.LastName;
                            personVM.MiddleName = personObject?.MiddleName ?? "";
                            personVM.FathersName = personObject?.FatherName ?? "";
                            personVM.MothersName = personObject?.MotherName ?? "";
                            personVM.GrandFathersName = personObject?.GrandFatherName ?? "";
                            personVM.BirthDate = personObject.BirthDate.Value.ToString("yyyy/MM/dd");
                            personVM.BirthPlace = personObject.BirthPlace;
                            personVM.Gender = personObject.Gender;
                            personVM.GenderTitle = Resources.Resources.ResourceManager.GetString(((Gender)personObject.Gender).ToString());
                            personVM.MarritalType = personObject.MarritalType;
                            personVM.MarritalTypeTitle = Resources.Resources.ResourceManager.GetString(((MarritalStatus)personObject.MarritalType).ToString());
                            personVM.RecommenderCode = recommenderCode;

                            var citizenshipsObject = _citizenShipService.FetchMany(x => x.PersonId == personObject.Id);
                            if (citizenshipsObject != null && citizenshipsObject.Count() > 0)
                            {
                                foreach (var citizen in citizenshipsObject)
                                {
                                    citizenShipsVM = new CitizenShipViewModel();
                                    //---------------------------
                                    citizenShipsVM.Active = citizen.Active;
                                    citizenShipsVM.PersonId = citizen.PersonId;
                                    citizenShipsVM.IssuePlace = citizen.IssuePlace;
                                    citizenShipsVM.IssueDate = citizen.IssueDate;
                                    citizenShipsVM.Id = citizen.Id;
                                    citizenShipsVM.DocType = string.IsNullOrEmpty(citizen.DocType.ToString()) ? 0 : citizen.DocType;
                                    citizenShipsVM.DocNo = citizen.DocNo;
                                    citizenShipsVM.CountryId = citizen.CountryId;
                                    //---------------------------
                                    if (!string.IsNullOrEmpty(citizen.CountryId?.ToString()))
                                    {
                                        var countryObject = _countryService.FetchMany(x => x.Id == citizen.CountryId ).FirstOrDefault();
                                        if (countryObject != null)
                                        {
                                            countryVM = new CountryViewModel();

                                            countryVM.Active = countryObject.Active;
                                            countryVM.CountryCode = countryObject.CountryCode;
                                            countryVM.DisplayName = countryObject.DisplayName;
                                            countryVM.Id = countryObject.Id;
                                            countryVM.LanguageCode = countryObject.LanguageCode;
                                            countryVM.Name = countryObject.Name;
                                            countryVM.PhoneCode = countryObject.PhoneCode;
                                            //---------------------------
                                            citizenShipsVM.Country = countryVM;
                                        }
                                    }
                                    //---------------------------
                                    citizenShipsListVM.Add(citizenShipsVM);
                                }
                                personVM.CitizenShips = citizenShipsListVM;
                            }

                            var addressListObject = _addressService.FetchMany(x => x.PersonId == personObject.Id);
                            if (addressListObject != null && addressListObject.Count() > 0)
                            {
                                foreach (var address in addressListObject)
                                {
                                    addressVM = new AddressViewModel();

                                    addressVM.Active = address.Active;
                                    addressVM.AddressType = address.AddressType;
                                    addressVM.City = address.City;
                                    addressVM.Mobile2 = address.Mobile;
                                    addressVM.Email2 = address.Email;
                                    addressVM.Id = address.Id;
                                    addressVM.PersonId = address.PersonId;
                                    addressVM.PhoneNo = address.PhoneNo;
                                    addressVM.PostalCode = address.PostalCode;
                                    addressVM.Plaque = address.Plaque;
                                    addressVM.PreCodeForMobile = address.PreCodeForMobile;
                                    addressVM.PreCodeForPhoneNo = address.PreCodeForPhoneNo;
                                    addressVM.Province = address.Province;
                                    addressVM.Street = address.Street;

                                    addressListVM.Add(addressVM);
                                }
                                personVM.Addresses = addressListVM;

                            }
                            studentVM.Person = personVM;

                        }

                        var candidateFieldsObject = _condidateService.FetchMany(x => x.StudentId == studentObject.Id);
                        if (candidateFieldsObject != null && candidateFieldsObject.Count() > 0)
                        {
                            foreach (var candidateField in candidateFieldsObject)
                            {
                                candidateFieldsVM = new CandidateFieldViewModel();

                                candidateFieldsVM.Active = candidateField.Active;
                                candidateFieldsVM.Selected = candidateField.Selected;
                                candidateFieldsVM.Id = candidateField.Id;
                                candidateFieldsVM.StudentId = candidateField.StudentId;

                                //---------------------------
                                fieldForForeignVM = new FieldForForeignViewModel();
                                //---------------------------
                                fieldForForeignVM.Code_Baygan = candidateField.FieldForForeign.Code_Baygan;
                                fieldForForeignVM.Field_Name = candidateField.FieldForForeign.Field_Name;
                                fieldForForeignVM.Id = candidateField.FieldForForeign.Id;
                                fieldForForeignVM.LanguageCode = candidateField.FieldForForeign.LanguageCode;
                                fieldForForeignVM.Sida_ID = candidateField.FieldForForeign.Sida_ID;
                                fieldForForeignVM.CollegeId = candidateField.FieldForForeign.CollegeId;

                                //---------------------------
                                candidateFieldsVM.FieldForForeign = fieldForForeignVM;

                                candidateFieldsListVM.Add(candidateFieldsVM);
                            }

                            candidateFieldsListVM.OrderByDescending(o => o.Selected);
                            studentVM.CandidateFields = candidateFieldsListVM;

                            //---------------------------
                            //foreach (var field in candidateFieldsListVM.Select(s => s.FieldForForeign))
                            //{
                            //    if (field.CollegeId != null && field.CollegeId > 0)
                            //    {
                            //        var col = _collegeService.FindById(field.CollegeId);
                            //        if (col != null)
                            //            field.College = new CollegeViewModel
                            //            {
                            //                Active = col.Active,
                            //                CollegeName = col.CollegeName,
                            //                LanguageCode = col.LanguageCode,
                            //                Id = col.Id,
                            //                SIDA_Code = col.SIDA_Code
                            //            };
                            //    }
                            //}

                        }

                        var educationDegreesObject = _educationDegreeService.FetchMany(x => x.SudentId == studentObject.Id);

                        if (educationDegreesObject != null && educationDegreesObject.Count() > 0)
                        {
                            foreach (var degree in educationDegreesObject)
                            {
                                educationDegreeVM = new EducationDegreeViewModel();

                                educationDegreeVM.Active = degree.Active;
                                educationDegreeVM.CountryName = degree.CountryName;
                                educationDegreeVM.EducationDegreePlace = degree.EducationDegreePlace;
                                educationDegreeVM.EndTimeInLevel = degree.EndTimeInLevel;
                                educationDegreeVM.FieldId = degree.FieldId;
                                educationDegreeVM.FieldTitle = degree.FieldTitle;
                                educationDegreeVM.Id = degree.Id;
                                educationDegreeVM.Level = degree.Level;
                                educationDegreeVM.LevelTitle = Resources.Resources.ResourceManager.GetString(((Levels)degree.Level).ToString());
                                educationDegreeVM.TotalAverage = degree.TotalAverage;
                                educationDegreeVM.UniversityName = degree.UniversityName;
                                educationDegreeVM.WrittenAverage = degree.WrittenAverage;

                                educationDegreesListVM.Add(educationDegreeVM);
                            }
                            studentVM.EducationDegrees = educationDegreesListVM;
                        }


                        var studentDocumentsObject = _studentDocService.FetchMany(x => x.SudentId == studentObject.Id && req.Term == x.Term);

                        if (studentDocumentsObject != null && studentDocumentsObject.Count() > 0)
                        {
                            foreach (var document in studentDocumentsObject)
                            {
                                documentVM = new RequestDocViewModel();

                                documentVM.Category = document.Category;
                                documentVM.CategoryTitle = Resources.Resources.ResourceManager.GetString(((DocType)document.Category).ToString());
                                documentVM.DocStatus = document.DocStatus;
                                documentVM.DocStatusTitle = Resources.Resources.ResourceManager.GetString(((DocStatus)document.DocStatus).ToString());
                                documentVM.FileName = document.FileName;
                                documentVM.Id = document.Id;
                                documentVM.Path = document.Path;
                                documentVM.StudentId = document.Student.Id;
                                documentVM.Term = document.Term;

                                documentsListVM.Add(documentVM);
                            }
                        }

                        reqVM.Student = studentVM;
                        reqVM.Documents = documentsListVM;

                    }
                }
            }
            return PartialView("_InternationalManager", reqVM);
        }



        [HttpPost]
        public JsonResult IsValidRequestId(int id = 0)
        {
            var flag = false;
            if (id > 0)
            {
                var req = _requestService.FindById(id);
                if (req != null)
                {
                    flag = true;
                }
            }
            return new JsonResult { Data = new { Result = flag } };
        }


        [HttpPost]
        public JsonResult ChangeRequestStatus(int id = 0, int acctiontype = 0, string description = "", string term = null, string studentCode = null)
        {
            var status = -1;
            decimal logTypeId = -1;
            if (id > 0)
            {
                if (acctiontype == 1)//تایید اولیه
                {
                    status = (byte)RequestStatus.M_First_Accepted;
                    logTypeId = (byte)LogsType.FirstAcceptReqeustByInternationalManager;
                }
                if (acctiontype == 2)//رد
                {
                    status = (byte)RequestStatus.M_Rejected;
                    logTypeId = (byte)LogsType.RejectRequestByInternationalManager;
                }
                if (acctiontype == 3)//تایید نهایی
                {
                    status = (byte)RequestStatus.M_Final_Accepted;
                    logTypeId = (byte)LogsType.FinalAcceptRequestByInternationalManager;
                }

                if (status != -1)
                {
                    if (status == (int)RequestStatus.M_Final_Accepted
                        && !string.IsNullOrEmpty(term)
                        && !string.IsNullOrEmpty(studentCode)
                        && Helpers.IsNumeric(studentCode)
                        )
                    {
                        var convertedTerm = $"{term.Substring(0, 2)}{term.Substring(6, 1)}";
                        var student = _newStudentService.FindOne(s => s.stcode == studentCode && s.term.ToString() == convertedTerm);
                        if (student != null)
                        {
                            student.RequestId = decimal.Parse(id.ToString());
                            _newStudentService.UpdatetItem(student);
                        }
                    }

                    var req = _requestService.FindById(id);
                    if (req != null && status > 0)
                    {
                        req.Status = Convert.ToByte(status);
                        req.Description = description;
                        _requestService.UpdatetItem(req);

                        if (logTypeId > 0)
                        {
                            var userId = (Session["UserCmsInfo"] as UserLoginCmsViewModel)?.UserId;
                            var deviceIP = Request.UserHostAddress;
                            var userLog = new ISR.DAL.Amozesh_Initial.UserLog()
                            {
                                UserLogTypeId = logTypeId,
                                LogDate = DateTime.Now,
                                ModifyId = id,
                                Description = $"reqId={int.Parse(id.ToString())}",
                                UserId = userId,
                                IP_dev = deviceIP
                            };
                            _userLogService.AddNewItem(userLog);
                        }
                        return new JsonResult { Data = new { Result = true, Message = "ok" } };
                    }
                    return new JsonResult { Data = new { Result = false, Message = "Invalid" } };
                }
                return new JsonResult { Data = new { Result = false, Message = "Invalid" } };
            }
            return new JsonResult { Data = new { Result = false, Message = "Invalid" } };
        }



        [HttpGet]
        public ActionResult InternationalManagerFinalConfirm(string term = null)
        {
            //if (Session["UserCmsInfo"] == null)
            //{
            //    return RedirectToAction("LoginCMS", "Account", new { lang = "fa" });
            //}
            var selectedTerm = string.IsNullOrEmpty(term) ? currentTerm : term;
            var convertedTerm = $"{selectedTerm.Substring(0, 2)}{selectedTerm.Substring(6, 1)}";

            var terms = _requestService.FetchAll().Select(s => s.Term).Distinct().OrderByDescending(o => o).ToList();
            var allTerms = new List<RequestStatusDTO>();
            terms.ForEach(f => allTerms.Add(new RequestStatusDTO() { ID = f.ToString(), DispalyName = f.ToString() }));
            ViewBag.Terms = new SelectList(allTerms, "ID", "DispalyName", selectedTerm);

            var newStudentsList = _newStudentService.FetchAll().Where(w => w.term == int.Parse(convertedTerm))//term is 3 degits
                .Select(s => new NewStudentViewModel
                {
                    StudentCode = s.stcode,
                    RequestId = s.RequestId?.ToString() ?? "",
                    FirstName = s.name,
                    LastName = s.family,
                    FatherName = s.namep,
                    FeildIdSazman = s.idreshSazman,
                    //FeildTitle = "---",
                    GraduateLevel = s.magh,
                    GraduateLevelTitle = EnumsPersianTitles.GetSidaLevelTitle(s.magh),
                    BirthDate = s.year_tav?.ToString() ?? "--"
                }).ToList();

            var model = (from ns in newStudentsList
                         join s in _sidaFieldService.FetchAll() on ns.FeildIdSazman equals s.CodeSazman into sidaFields
                         from sf in sidaFields.DefaultIfEmpty()
                         select new NewStudentViewModel()
                         {
                             StudentCode = ns.StudentCode,
                             RequestId = ns.RequestId?.ToString() ?? "",
                             FirstName = ns.FirstName,
                             LastName = ns.LastName,
                             FatherName = ns.FatherName,
                             FeildIdSazman = ns.FeildIdSazman,
                             FeildTitle = sf == null ? "---" : sf.SidaFieldName,
                             GraduateLevel = ns.GraduateLevel,
                             GraduateLevelTitle = EnumsPersianTitles.GetSidaLevelTitle(ns.GraduateLevel),
                             BirthDate = ns.BirthDate?.ToString() ?? "--"
                         }).ToList();

            return View(model);
        }



        [HttpPost]
        public ActionResult GetNewStudetByParams(string term = null, string studentCode = null, string filter = null)
        {
            try
            {
                var selectedTerm = string.IsNullOrEmpty(term) ? currentTerm : term;
                var convertedTerm = $"{selectedTerm.Substring(0, 2)}{selectedTerm.Substring(6, 1)}";
                var studentList = _newStudentService.FetchAll().Where(w => w.term == int.Parse(convertedTerm));

                if (!string.IsNullOrEmpty(studentCode) && Helpers.IsNumeric(studentCode))
                {
                    var student = studentList.Where(w => w.stcode == studentCode).Select(s => new NewStudentViewModel
                    {
                        StudentCode = s.stcode,
                        RequestId = s.RequestId?.ToString() ?? "",
                        FirstName = s.name,
                        LastName = s.family,
                        FatherName = s.namep,
                        FeildIdSazman = s.idreshSazman,
                        //FeildTitle = "---",
                        GraduateLevel = s.magh,
                        GraduateLevelTitle = EnumsPersianTitles.GetSidaLevelTitle(s.magh),
                        BirthDate = s.year_tav?.ToString() ?? "--"
                    }).FirstOrDefault();

                    var sidaField = _sidaFieldService.FindOne(s => s.CodeSazman == student.FeildIdSazman);
                    var model = new NewStudentViewModel
                    {
                        StudentCode = student.StudentCode,
                        RequestId = student.RequestId?.ToString() ?? "",
                        FirstName = student.FirstName,
                        LastName = student.LastName,
                        FatherName = student.FatherName,
                        FeildIdSazman = student.FeildIdSazman,
                        FeildTitle = sidaField == null ? "---" : sidaField.SidaFieldName,
                        GraduateLevel = student.GraduateLevel,
                        GraduateLevelTitle = EnumsPersianTitles.GetSidaLevelTitle(student.GraduateLevel),
                        BirthDate = student.BirthDate?.ToString() ?? "--",
                    };
                    return PartialView("_NewStudentDetails", model);
                }
                else
                {
                    if (!string.IsNullOrEmpty(filter?.Trim()))
                    {
                        var trimedFilter = filter.Trim();
                        if (Helpers.IsNumeric(trimedFilter))//studentCode or requestId or codeSazman
                        {
                            var model = (from ns in studentList
                                         join s in _sidaFieldService.FetchAll() on ns.idreshSazman equals s.CodeSazman //into sidaFields
                                         //from sf in sidaFields.DefaultIfEmpty()
                                         where (
                                             (!string.IsNullOrEmpty(ns.stcode?.Trim()) && ns.stcode.Trim() == trimedFilter) ||
                                             (!string.IsNullOrEmpty(ns.RequestId?.ToString().Trim()) && ns.RequestId.ToString().Trim() == trimedFilter) ||
                                             (!string.IsNullOrEmpty(ns.idreshSazman.Trim()) && ns.idreshSazman.Trim() == trimedFilter)
                                         )
                                         select new NewStudentViewModel()
                                         {
                                             StudentCode = ns.stcode,
                                             RequestId = ns.RequestId?.ToString() ?? "",
                                             FirstName = ns.name,
                                             LastName = ns.family,
                                             FatherName = ns.namep,
                                             FeildIdSazman = ns.idreshSazman,
                                             //FeildTitle = sf == null ? "---" : sf.SidaFieldName,
                                             FeildTitle = s == null ? "---" : s.SidaFieldName,
                                             GraduateLevel = ns.magh,
                                             GraduateLevelTitle = EnumsPersianTitles.GetSidaLevelTitle(ns.magh),
                                             BirthDate = ns.date_tav?.ToString() ?? "--"
                                         }).ToList();
                            return PartialView("_NewStudentList", model);
                        }
                        else //name or family or field or fathername
                        {
                            var model = (from ns in studentList
                                         join s in _sidaFieldService.FetchAll() on ns.idreshSazman equals s.CodeSazman //into sidaFields                                         
                                         where (
                                                    (!string.IsNullOrEmpty(ns.name) && Helpers.ToPersianLetters(ns.name.ToLower()).Contains(Helpers.ToPersianLetters(trimedFilter.ToLower())))
                                                 || (!string.IsNullOrEmpty(ns.family) && Helpers.ToPersianLetters(ns.family.ToLower()).Contains(Helpers.ToPersianLetters(trimedFilter.ToLower())))
                                                 || (!string.IsNullOrEmpty(ns.namep) && Helpers.ToPersianLetters(ns.namep.ToLower()).Contains(Helpers.ToPersianLetters(trimedFilter.ToLower())))
                                                 || (!string.IsNullOrEmpty(s.SidaFieldName) && Helpers.ToPersianLetters(s.SidaFieldName.ToLower()).Contains(Helpers.ToPersianLetters(trimedFilter.ToLower())))
                                            //|| (!string.IsNullOrEmpty(sf.SidaFieldName) && Helpers.ToPersianLetters(sf.SidaFieldName).Contains(Helpers.ToPersianLetters(trimedFilter)))
                                            )

                                         select new NewStudentViewModel()
                                         {
                                             StudentCode = ns.stcode,
                                             RequestId = ns.RequestId?.ToString() ?? "",
                                             FirstName = ns.name,
                                             LastName = ns.family,
                                             FatherName = ns.namep,
                                             FeildIdSazman = ns.idreshSazman,
                                             //FeildTitle = sf == null ? "---" : sf.SidaFieldName,
                                             FeildTitle = s == null ? "---" : s.SidaFieldName,
                                             GraduateLevel = ns.magh,
                                             GraduateLevelTitle = EnumsPersianTitles.GetSidaLevelTitle(ns.magh),
                                             BirthDate = ns.date_tav?.ToString() ?? "--"
                                         }).ToList();
                            return PartialView("_NewStudentList", model);
                        }
                    }
                    else
                    {
                        var model = (from ns in studentList
                                     join s in _sidaFieldService.FetchAll() on ns.idreshSazman equals s.CodeSazman //into sidaFields
                                     //from sf in sidaFields.DefaultIfEmpty()
                                     select new NewStudentViewModel()
                                     {
                                         StudentCode = ns.stcode,
                                         RequestId = ns.RequestId?.ToString() ?? "",
                                         FirstName = ns.name,
                                         LastName = ns.family,
                                         FatherName = ns.namep,
                                         FeildIdSazman = ns.idreshSazman,
                                         //FeildTitle = sf == null ? "---" : sf.SidaFieldName,
                                         FeildTitle = s == null ? "---" : s.SidaFieldName,
                                         GraduateLevel = ns.magh,
                                         GraduateLevelTitle = EnumsPersianTitles.GetSidaLevelTitle(ns.magh),
                                         BirthDate = ns.date_tav?.ToString() ?? "--"
                                     }).ToList();
                        return PartialView("_NewStudentList", model);
                    }

                }
            }
            catch (Exception x)
            {
                throw x;
            }

        }
    }


}