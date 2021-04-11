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
    //[CustomAuthorize(RoleIds.Admin, RoleIds.Enrollment_Manager, RoleIds.ISR_Expert)]
    [CustomAuthorize]
    public class InternationalExpertController : Controller
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
        private readonly IUserLogService _userLogService;
        private readonly INewStudentService _newStudentService;
        private readonly ISidaFieldService _sidaFieldService;

        private readonly string currentTerm = WebConfigurationManager.AppSettings["Term"];
        #endregion

        #region Ctor
        public InternationalExpertController(IRequestService requestService
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
            , IUserLogService userLogService
            , INewStudentService newStudentService
            , ISidaFieldService sidaFieldService
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
            _userLogService = userLogService;
            _newStudentService = newStudentService;
            _sidaFieldService = sidaFieldService;
        }
        #endregion

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
                new RequestStatusDTO(){ID=((byte)RequestStatus.DocsUploaded).ToString(),DispalyName=Resources.Resources.InProgressRequests} ,              //1
                new RequestStatusDTO(){ID=((byte)RequestStatus.Ex_Rejected).ToString(),DispalyName=Resources.Resources.RejectRequestByExpert} ,            //3
                new RequestStatusDTO(){ID=((byte)RequestStatus.Ex_Accepted).ToString(),DispalyName=Resources.Resources.AcceptRequestByExpert}  ,           //4
                new RequestStatusDTO(){ID=((byte)RequestStatus.M_Rejected).ToString(),DispalyName=Resources.Resources.RejectRequestByManager}             //5

               // new RequestStatusDTO(){ID=((byte)RequestStatus.M_Enrollment_Rejected).ToString(),DispalyName=Resources.Resources.M_Enrollment_Rejected}    //9
            };

            if (!string.IsNullOrEmpty((Session["UserCmsInfo"] as UserLoginCmsViewModel).UserRoles))
            {
                var strUserRoles = (Session["UserCmsInfo"] as UserLoginCmsViewModel).UserRoles.Trim().ToLower();
                if (strUserRoles.Contains(RoleIds.Admin) || strUserRoles.Contains(RoleIds.ISR_Manager))
                {
                    enumList.Add(new RequestStatusDTO() { ID = ((byte)RequestStatus.M_Enrollment_Accepted).ToString(), DispalyName = Resources.Resources.M_Enrollment_Accepted });
                    enumList.Add(new RequestStatusDTO() { ID = ((byte)RequestStatus.M_Enrollment_Rejected).ToString(), DispalyName = Resources.Resources.M_Enrollment_Rejected });
                }
            }

            var reqStatus = !string.IsNullOrEmpty(TempData["tdStatus"]?.ToString()) ? byte.Parse(TempData["tdStatus"].ToString()) : (byte)RequestStatus.DocsUploaded;
            var term = !string.IsNullOrEmpty(TempData["tdTerm"]?.ToString()) ? TempData["tdTerm"].ToString() : currentTerm;

            ViewBag.StatusList = new SelectList(enumList, "ID", "DispalyName", reqStatus);

            var terms = _requestService.FetchAll().Select(s => s.Term).Distinct().OrderByDescending(o => o).ToList();
            var allTerms = new List<RequestStatusDTO>();
            terms.ForEach(f => allTerms.Add(new RequestStatusDTO() { ID = f.ToString(), DispalyName = f.ToString() }));

            ViewBag.Terms = new SelectList(allTerms, "ID", "DispalyName", term);
            var reqTermDto = new FilterRequestByParamDTO
            {
                Term = term,
                ReqStatus = reqStatus.ToString()
            };


            var model = new List<RequestInfoViewModel>(); //BindRequestViewModel(reqTermDto);
            return View(model);

        }


        [HttpPost]
        public PartialViewResult ShowRequests(FilterRequestByParamDTO req)
        {
            var model = BindRequestViewModel(req);
            TempData["tdTerm"] = req.Term;
            TempData["tdStatus"] = req.ReqStatus;

            return PartialView("_RequestDetailsTable", model);
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

        private List<RequestInfoViewModel> BindRequestViewModel(FilterRequestByParamDTO req)
        {
            var tterm = string.IsNullOrEmpty(req.Term) ? currentTerm : req.Term;
            var reqStatus2 = !string.IsNullOrEmpty(req.ReqStatus) ? Byte.Parse(req.ReqStatus) : (byte)RequestStatus.DocsUploaded;
            var myModel = new List<RequestInfoViewModel>();
            var model = new List<RequestInfoViewModel>();

            myModel = _requestService.FetchMany(s => s.Term == req.Term && s.Status == reqStatus2).Select(s => new RequestInfoViewModel
            {
                RequestID = s.Id.ToString(),
                FirstName = s.Student.Person.FirstName,
                LastName = s.Student.Person.LastName,
                FatherName = s.Student.Person.FatherName,
                FieldID = _condidateService.FetchAll().FirstOrDefault(x => x.StudentId == s.Student.Id)?.FieldId?.ToString() ?? "-1",
                CountryId = s.Student.Person.CitizenShips.FirstOrDefault(c => c.Person.Id == s.Student.Person.Id)?.CountryId?.ToString() ?? "-1",
                Term = req.Term,
                ContollerName = "InternationalExpert"
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
                    model = model.Where(w => Helpers.ToPersianLetters(w.FirstName.ToLower()).Contains(Helpers.ToPersianLetters(req.Filter.ToString().Trim().ToLower()))
                                                 || Helpers.ToPersianLetters(w.LastName.ToLower()).Contains(Helpers.ToPersianLetters(req.Filter.ToString().Trim().ToLower()))
                                                 || Helpers.ToPersianLetters(w.FatherName.ToLower()).Contains(Helpers.ToPersianLetters(req.Filter.ToString().Trim().ToLower()))
                                                 || Helpers.ToPersianLetters(w.CountryTitle.ToLower()).Contains(Helpers.ToPersianLetters(req.Filter.ToString().Trim().ToLower()))
                                                 ).ToList();
                }
            }
            return model;
        }


        public ActionResult RequestDetails(int id = 0, string term = null)
        {
            //if (Session["UserCmsInfo"] == null)
            //{
            //    return RedirectToAction("LoginCMS", "Account", new { lang = "fa" });
            //}        

            System.Threading.Thread.CurrentThread.CurrentCulture = new System.Globalization.CultureInfo("en-GB");
            System.Threading.Thread.CurrentThread.CurrentUICulture = new System.Globalization.CultureInfo("fa-IR");
            var reqVM = new RequestViewModel();
            if (id > 0)
            {
                var req = _requestService.FindById(id);

                if (req != null)
                {
                    var fid = req.Student.CandidateFields.FirstOrDefault()?.FieldId;
                    var langCode = fid == null ? "fa" : _fieldForForeignService.FindById(fid)?.LanguageCode;

                    var listOfCountries = _countryService.FetchAll().OrderBy(o => o.Name).ToList();
                    listOfCountries.Insert(0, new Country() { Id = 0, DisplayName = "-انتخاب کنید-" });

                    var lstCountries = _countryService.FetchAll().ToList().Select(s => new Country
                    {
                        Id = Convert.ToDecimal(string.IsNullOrEmpty(s.PhoneCode?.ToString()) ? "-1" : s.PhoneCode?.ToString()),
                        DisplayName =$"(+{ s.PhoneCode?.ToString()??""}) {s.DisplayName}"
                    }).ToList();

                    lstCountries.Insert(0, new Country() { Id = 0, DisplayName = "-انتخاب کنید-" });

                    var allCitizenships = req.Student.Person.CitizenShips.ToList();
                    var firstCitizenship = allCitizenships.FirstOrDefault()?.CountryId.ToString() ?? "0";
                    var secondCitizenship = allCitizenships.FirstOrDefault(f => f.CountryId != decimal.Parse(firstCitizenship))?.CountryId?.ToString() ?? "0";
                    var prePhoneCodeSecondCountry = req.Student.Person.Addresses.FirstOrDefault(w => w.AddressType == (byte)AddressType.CitizenshipResidenceAddress)?.PreCodeForPhoneNo;
                    var preMobileCodeSecondCountry = req.Student.Person.Addresses.FirstOrDefault(w => w.AddressType == (byte)AddressType.CitizenshipResidenceAddress)?.PreCodeForMobile;

                    var relatedPersons = req.Student.Person.RelatedPersons?.Where(w => w.MainPersonRelationType == (byte)RelationType.FamilyMember).ToList();
                    var recommenderObject = req.Student.Person.RelatedPersons.FirstOrDefault(w => w.MainPersonRelationType == (byte)RelationType.Recommender);
                    string recommenderCode = null;
                    if (recommenderObject != null)
                        recommenderCode = _personService.FindById(recommenderObject.RelatedPersonId)?.RecommenderCode ?? "--";

                    ViewBag.reqId = id;
                    ViewBag.StdId = req.Student.Id;
                    ViewBag.ParentPersonId = req.Student.Person.Id;
                    ViewBag.CountryList = new SelectList(listOfCountries, "Id", "DisplayName", "0");
                    ViewBag.firstCitizenshipDrp = new SelectList(listOfCountries, "Id", "DisplayName", firstCitizenship);
                    ViewBag.secondCitizenshipDrp = new SelectList(listOfCountries, "Id", "DisplayName", secondCitizenship);
                    ViewBag.RelatedPersons = relatedPersons;
                    ViewBag.RecommenderCode = recommenderCode;
                    ViewBag.PhoneCodes = new SelectList(lstCountries, "Id", "DisplayName", prePhoneCodeSecondCountry);
                    ViewBag.MobileNumbers = new SelectList(lstCountries, "Id", "DisplayName", preMobileCodeSecondCountry);
                    ViewBag.Sexulity = req.Student.Person.Gender == 1 ? Resources.Resources.Male : (req.Student.Person.Gender == 2 ? Resources.Resources.Female : Resources.Resources.Dropdown_Choose);
                    ViewBag.MaratalStatus = Commons.EnumsPersianTitles.GetMaretalStatus(req.Student.Person.MarritalType);
                    ViewBag.HealthStatus = Commons.EnumsPersianTitles.GetHealthStatus(req.Student.HealthStatus);
                    ViewBag.Relegion = Commons.EnumsPersianTitles.GetRelegion(req.Student.Religien);
                    ViewBag.MotherMarritalType = Commons.EnumsPersianTitles.GetMaretalType(req.Student.Person.RelatedPersons?.FirstOrDefault(x => x.MainPersonRelationType == (byte)RelationType.Mother)?.MainPerson?.MarritalType);


                    var AllFields = (from f in _fieldForForeignService.FetchAll()
                                         //left join
                                     join fa in (from x in _fieldForForeignService.FetchAll() where x.LanguageCode == "fa" select x) on f.Sida_ID equals fa.Sida_ID into persianFields
                                     from ff in persianFields.DefaultIfEmpty()
                                         //where f.LanguageCode == langCode
                                     select new FieldDTO
                                     {
                                         FieldId = f.Id.ToString(),
                                         FieldTitle = f.LanguageCode != "fa" ?
                                                f.Field_Name + (!string.IsNullOrEmpty(ff?.Field_Name) ? " ( " + ff?.Field_Name + " ) " : "")
                                                : f.Field_Name,
                                         LangCode = f.LanguageCode,
                                         SidaId = f.Sida_ID.ToString()

                                     }).Distinct().ToList().OrderBy(ord => ord.LangCode);

                    var xx = AllFields.Select(s => new SelectListItem { Value = s.FieldId, Text = s.FieldTitle }).ToList();

                    ViewBag.AllFields = xx;

                    CitizenShipViewModel citizenShipsVM = null;
                    CountryViewModel countryVM = null;
                    AddressViewModel addressVM = null;
                    CandidateFieldViewModel candidateFieldsVM = null;
                    FieldForForeignViewModel fieldForForeignVM = null;
                    EducationDegreeViewModel educationDegreeVM = null;
                    RequestDocViewModel documentVM = null;
                    RelatedPersonViewModel relatedPersonVM = null;

                    var studentVM = new StudentViewModel();
                    var personVM = new PersonViewModel();
                    var citizenShipsListVM = new List<CitizenShipViewModel>();
                    var countryListVM = new CountryViewModel();
                    var addressListVM = new List<AddressViewModel>();
                    var candidateFieldsListVM = new List<CandidateFieldViewModel>();
                    var fieldForForeignListVM = new List<FieldForForeignViewModel>();
                    var educationDegreesListVM = new List<EducationDegreeViewModel>();
                    var documentsListVM = new List<RequestDocViewModel>();
                    var relatedPersonsListVM = new List<RelatedPersonViewModel>();

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
                                        var countryObject = _countryService.FetchMany(x => x.Id == citizen.CountryId && x.LanguageCode == "fa").FirstOrDefault();
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

                            if (relatedPersons != null && relatedPersons.Count() > 0)
                            {
                                foreach (var relatedPerson in relatedPersons)
                                {
                                    relatedPersonVM = new RelatedPersonViewModel();
                                    relatedPersonVM.RelatedPersonRelationTypeTitle = Resources.Resources.ResourceManager.GetString(((RelationType)relatedPerson.RelatedPersonRelationType).ToString());
                                    relatedPersonVM.MainPersonRelationType = relatedPerson.MainPersonRelationType;
                                    relatedPersonVM.Id = relatedPerson.Id;
                                    //relatedPersonVM.MainPersonId = relatedPerson.MainPersonId;
                                    //relatedPersonVM.RelatedPersonRelationType = relatedPerson.RelatedPersonRelationType;
                                    //relatedPersonVM.MainPersonRelationTypeTitle = Resources.Resources.ResourceManager.GetString(((RelationType)relatedPerson.MainPersonRelationType).ToString());

                                    string relatedPersonId = relatedPerson?.RelatedPersonId?.ToString() ?? "-1";
                                    if (relatedPersonId != "-1")
                                    {
                                        var rpId = decimal.Parse(relatedPersonId);
                                        var reletedPersonObject = _personService.FindOne(x => x.Id == rpId);
                                        if (reletedPersonObject != null)
                                        {
                                            var relatedPersonVM2 = new PersonViewModel();

                                            relatedPersonVM2.FirstName = reletedPersonObject.FirstName;
                                            relatedPersonVM2.LastName = reletedPersonObject.LastName;
                                            //relatedPersonVM2.MiddleName = reletedPersonObject?.MiddleName ?? "";
                                            relatedPersonVM2.FathersName = reletedPersonObject?.FatherName ?? "";
                                            relatedPersonVM2.MothersName = reletedPersonObject?.MotherName ?? "";
                                            relatedPersonVM2.GrandFathersName = reletedPersonObject?.GrandFatherName ?? "";
                                            relatedPersonVM2.BirthDate = reletedPersonObject.BirthDate.Value.ToString("yyyy/MM/dd");
                                            relatedPersonVM2.BirthPlace = reletedPersonObject?.BirthPlace ?? "";


                                            var citizenships = _citizenShipService.FetchMany(x => x.PersonId == rpId);
                                            if (citizenships != null && citizenships.Count() > 0)
                                            {
                                                CitizenShipViewModel ctizen = null;
                                                CountryViewModel ctntry = null;
                                                List<CitizenShipViewModel> ctizenList = new List<CitizenShipViewModel>();

                                                foreach (var ciniz in citizenships)
                                                {
                                                    ctizen = new CitizenShipViewModel();

                                                    ctizen.Active = ciniz.Active;
                                                    ctizen.PersonId = ciniz.PersonId;
                                                    ctizen.IssuePlace = ciniz.IssuePlace;
                                                    ctizen.IssueDate = ciniz.IssueDate;
                                                    ctizen.Id = ciniz.Id;
                                                    ctizen.DocType = string.IsNullOrEmpty(ciniz.DocType.ToString()) ? 0 : ciniz.DocType;
                                                    ctizen.DocTypeTitle = !string.IsNullOrEmpty(ciniz.DocType.ToString()) ? Resources.Resources.ResourceManager.GetString(((DocType)ciniz.DocType).ToString()) : string.Empty;
                                                    ctizen.DocNo = ciniz.DocNo;
                                                    ctizen.CountryId = ciniz.CountryId;

                                                    var cntryObj = _countryService.FindOne(x => x.Id == ciniz.CountryId);
                                                    if (cntryObj != null)
                                                    {
                                                        ctntry = new CountryViewModel();

                                                        ctntry.Active = cntryObj.Active;
                                                        ctntry.CountryCode = cntryObj.CountryCode;
                                                        ctntry.DisplayName = cntryObj.DisplayName;
                                                        ctntry.Id = cntryObj.Id;
                                                        ctntry.LanguageCode = cntryObj.LanguageCode;
                                                        ctntry.Name = cntryObj.Name;
                                                        ctntry.PhoneCode = cntryObj.PhoneCode;

                                                        ctizen.Country = ctntry;
                                                    }
                                                    ctizenList.Add(ctizen);
                                                }
                                                relatedPersonVM2.CitizenShips = ctizenList;
                                            }
                                            relatedPersonVM.Person = relatedPersonVM2;
                                        }
                                    }
                                    relatedPersonsListVM.Add(relatedPersonVM);
                                }
                                personVM.RelatedPersons = relatedPersonsListVM;
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

                    return View(reqVM);
                    //var model = new RequestViewModel
                    //{
                    //    CreateDate = (DateTime)req.CreateDate,
                    //    Id = req.Id,
                    //    Status = Convert.ToByte(req.Status),
                    //    StatusName = Resources.Resources.ResourceManager.GetString(((RequestStatus)req.Status).ToString()),
                    //    Discription = req.Description,
                    //    Student = new StudentViewModel
                    //    {
                    //        ChildrenCount = req.Student.ChildrenCount ?? 0,
                    //        Email = req.Student.Email,
                    //        HealthStatusTitle = req.Student.HealthStatus != null ? Resources.Resources.ResourceManager.GetString(((HealthStatus)req.Student.HealthStatus).ToString()) : Resources.Resources.ResourceManager.GetString((HealthStatus.CompleteHealth).ToString()),
                    //        Mobile = req.Student.Mobile,
                    //        Person = new PersonViewModel
                    //        {
                    //            FirstName = req.Student.Person.FirstName,
                    //            LastName = req.Student.Person.LastName,
                    //            MiddleName = req.Student.Person.MiddleName,
                    //            FathersName = req.Student.Person.FatherName,
                    //            MothersName = req.Student.Person.MotherName,
                    //            GrandFathersName = req.Student.Person.GrandFatherName,
                    //            BirthDate = req.Student.Person.BirthDate.Value.ToString("yyyy/MM/dd"),
                    //            BirthPlace = req.Student.Person.BirthPlace,
                    //            Gender = req.Student.Person.Gender,
                    //            GenderTitle = Resources.Resources.ResourceManager.GetString(((Gender)req.Student.Person.Gender).ToString()),
                    //            MarritalType = req.Student.Person.MarritalType,
                    //            MarritalTypeTitle = Resources.Resources.ResourceManager.GetString(((MarritalStatus)req.Student.Person.MarritalType).ToString()),
                    //            CitizenShips = req.Student.Person.CitizenShips?.Select(s => new CitizenShipViewModel
                    //            {
                    //                Active = s.Active,
                    //                PersonId = s.PersonId,
                    //                IssuePlace = s.IssuePlace,
                    //                IssueDate = s.IssueDate,
                    //                Id = s.Id,
                    //                DocType = string.IsNullOrEmpty(s.DocType.ToString()) ? 0 : s.DocType,
                    //                DocNo = s.DocNo,
                    //                CountryId = s.CountryId,
                    //                Country = new CountryViewModel
                    //                {
                    //                    Active = s.Country.Active,
                    //                    CountryCode = s.Country.CountryCode,
                    //                    DisplayName = s.Country.DisplayName,
                    //                    Id = s.Country.Id,
                    //                    LanguageCode = s.Country.LanguageCode,
                    //                    Name = s.Country.Name,
                    //                    PhoneCode = s.Country.PhoneCode
                    //                }

                    //            }).ToList(),
                    //            Addresses = req.Student.Person?.Addresses.Select(s => new AddressViewModel
                    //            {
                    //                Active = s.Active,
                    //                AddressType = s.AddressType,
                    //                City = s.City,
                    //                Mobile2 = s.Mobile2,
                    //                Email2 = s.Email2,
                    //                Id = s.Id,
                    //                PersonId = s.PersonId,
                    //                PhoneNo = s.PhoneNo,
                    //                PostalCode = s.PostalCode,
                    //                Plaque = s.Plaque,
                    //                PreCodeForMobile = s.PreCodeForMobile,
                    //                PreCodeForPhoneNo = s.PreCodeForPhoneNo,
                    //                Province = s.Province,
                    //                Street = s.Street
                    //            }).ToList()
                    //            ,
                    //            RelatedPersons = relatedPersons.Select(s => new RelatedPersonViewModel
                    //            {
                    //                RelatedPersonId = s.RelatedPersonId,
                    //                MainPersonRelationType = s.MainPersonRelationType,
                    //                MainPersonRelationTypeTitle = s.MainPersonRelationType != null ? Resources.Resources.ResourceManager.GetString(((RelationType)s.MainPersonRelationType).ToString()) : string.Empty,
                    //                RelatedPersonRelationType = s.RelatedPersonRelationType,
                    //                RelatedPersonRelationTypeTitle = s.RelatedPersonRelationType != null ? Resources.Resources.ResourceManager.GetString(((RelationType)s.RelatedPersonRelationType).ToString()) : string.Empty,
                    //                Id = s.Id,
                    //                Person = new PersonViewModel
                    //                {
                    //                    BirthDate = ((DateTime)s.Person1.BirthDate).ToString("yyyy/MM/dd"),
                    //                    BirthPlace = s.Person1.BirthPlace,
                    //                    FathersName = s.Person1.FatherName,
                    //                    FirstName = s.Person1.FirstName,
                    //                    Gender = s.Person1.Gender,
                    //                    GenderTitle = s.Person1.Gender != null ? Resources.Resources.ResourceManager.GetString(((Gender)s.Person1.Gender).ToString()) : string.Empty,
                    //                    GrandFathersName = s.Person1.GrandFatherName,
                    //                    LastName = s.Person1.LastName,
                    //                    MarritalType = s.Person1.MarritalType,
                    //                    MarritalTypeTitle = s.Person1.MarritalType != null ? Resources.Resources.ResourceManager.GetString(((MarritalStatus)s.Person1.MarritalType).ToString()) : string.Empty,
                    //                    MiddleName = s.Person1.MiddleName,
                    //                    MothersName = s.Person1.MotherName,
                    //                    IdNo = s.Person1.IdNo,
                    //                    IssuePlace = s.Person1.IssuePlace,
                    //                    NationalCode = s.Person1.NationalCode,
                    //                    Job = s.Person1.Job,
                    //                    Addresses = s.Person1.Addresses.Select(sa => new AddressViewModel
                    //                    {
                    //                        Active = sa.Active,
                    //                        AddressType = sa.AddressType,
                    //                        City = sa.City,
                    //                        Mobile2 = sa.Mobile2,
                    //                        Email2 = sa.Email2,
                    //                        Id = sa.Id,
                    //                        PersonId = sa.PersonId,
                    //                        PhoneNo = sa.PhoneNo,
                    //                        PostalCode = sa.PostalCode,
                    //                        Plaque = sa.Plaque,
                    //                        PreCodeForMobile = sa.PreCodeForMobile,
                    //                        PreCodeForPhoneNo = sa.PreCodeForPhoneNo,
                    //                        Province = sa.Province,
                    //                        Street = sa.Street
                    //                    }).ToList(),
                    //                    CitizenShips = s.Person.CitizenShips?.Select(sc => new CitizenShipViewModel
                    //                    {
                    //                        Active = sc.Active,
                    //                        PersonId = sc.PersonId,
                    //                        IssuePlace = sc.IssuePlace,
                    //                        IssueDate = sc.IssueDate,
                    //                        Id = sc.Id,
                    //                        DocType = sc.DocType,
                    //                        //DocTypeTitle = sc.DocType != null ?  MapperDocType(sc.DocType) : "",
                    //                        DocTypeTitle = sc.DocType != null ? Resources.Resources.ResourceManager.GetString(((DocType)sc.DocType).ToString()) : string.Empty,
                    //                        DocNo = sc.DocNo,
                    //                        CountryId = sc.CountryId,
                    //                        Country = new CountryViewModel
                    //                        {
                    //                            Active = sc.Country.Active,
                    //                            CountryCode = sc.Country.CountryCode,
                    //                            DisplayName = sc.Country.DisplayName,
                    //                            Id = sc.Country.Id,
                    //                            LanguageCode = sc.Country.LanguageCode,
                    //                            Name = sc.Country.Name,
                    //                            PhoneCode = sc.Country.PhoneCode
                    //                        }
                    //                    }).ToList()
                    //                }
                    //            }).ToList()
                    //        }
                    //        ,
                    //        CandidateFields = req.Student.CandidateFields.Select(s => new CandidateFieldViewModel
                    //        {
                    //            Active = s.Active,
                    //            Selected = s.Selected,
                    //            Id = s.Id,
                    //            StudentId = s.StudentId,
                    //            FieldForForeign = new FieldForForeignViewModel
                    //            {
                    //                Code_Baygan = s.FieldForForeign.Code_Baygan,
                    //                Field_Name = s.FieldForForeign.Field_Name,
                    //                Id = s.FieldForForeign.Id,
                    //                LanguageCode = s.FieldForForeign.LanguageCode,
                    //                Sida_ID = s.FieldForForeign.Sida_ID,
                    //                CollegeId = s.FieldForForeign.CollegeId,
                    //            }
                    //        }).OrderByDescending(ord => ord.Selected).ToList()
                    //,
                    //        ReligienTitle = Resources.Resources.ResourceManager.GetString(((Religion)req.Student.Religien).ToString()),
                    //        HealthStatus = req.Student.HealthStatus,
                    //        EducationDegrees = req.Student.EducationDegrees.Select(s => new EducationDegreeViewModel
                    //        {
                    //            Active = s.Active,
                    //            CountryName = s.CountryName,
                    //            EducationDegreePlace = s.EducationDegreePlace,
                    //            EndTimeInLevel = s.EndTimeInLevel,
                    //            FieldId = s.FieldId,
                    //            FieldTitle = s.FieldTitle,
                    //            Id = s.Id,
                    //            Level = s.Level,
                    //            LevelTitle = Resources.Resources.ResourceManager.GetString(((Levels)s.Level).ToString()),
                    //            TotalAverage = s.TotalAverage,
                    //            UniversityName = s.UniversityName,
                    //            WrittenAverage = s.WrittenAverage
                    //        }).ToList()
                    //    }
                    //    ,
                    //    Documents = req.Student.StudentDocs.Where(w => w.Term == term).Select(s => new RequestDocViewModel
                    //    {
                    //        Category = s.Category,
                    //        CategoryTitle = Resources.Resources.ResourceManager.GetString(((DocType)s.Category).ToString()),
                    //        DocStatus = s.DocStatus,
                    //        DocStatusTitle = Resources.Resources.ResourceManager.GetString(((DocStatus)s.DocStatus).ToString()),
                    //        FileName = s.FileName,
                    //        Id = s.Id,
                    //        Path = s.Path,
                    //        StudentId = s.Student.Id,
                    //        Term = s.Term
                    //    }).ToList()
                    //};
                    //foreach (var field in model.Student.CandidateFields.Select(s => s.FieldForForeign))
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

                    //return View(model);

                }
                else
                    return RedirectToAction("Index");
            }
            else
                return RedirectToAction("Index");
        }


        [HttpPost]
        public JsonResult AddRecommenderPerson(string data)
        {
            var res = new JsonResult();
            var dataObject = JObject.Parse(data);

            var userId = (Session["UserCmsInfo"] as UserLoginCmsViewModel)?.UserId;
            var deviceIP = Request.UserHostAddress;

            if (dataObject != null)
            {
                var requestId = decimal.Parse(dataObject["ParentPersonId"].ToString() ?? "-1");
                var relatadPersonRecomender_ParentId = decimal.Parse(dataObject["ParentPersonId"].ToString() ?? "-1");
                var recomenderInRelatedPerson = relatadPersonRecomender_ParentId == -1 ? null : _relatedPersonService.FindOne(x => x.MainPersonId == relatadPersonRecomender_ParentId && x.MainPersonRelationType == (byte)RelationType.Recommender);

                if (recomenderInRelatedPerson != null)
                {
                    var recomenderPerson = _personService.FindById(recomenderInRelatedPerson.RelatedPersonId);
                    if (recomenderPerson != null)
                    {
                        recomenderPerson.RecommenderCode = dataObject["RecommenderCode"].ToString();
                        var x1 = _personService.UpdatetItem(recomenderPerson);
                    }
                    else //if recommender person not exist
                    {

                        recomenderPerson.RecommenderCode = dataObject["RecommenderCode"].ToString();
                    }
                }
                else
                {
                    if (relatadPersonRecomender_ParentId != -1)
                    {
                        var recomenderPerson = new Person();
                        recomenderPerson.Active = true;
                        recomenderPerson.RecommenderCode = dataObject["RecommenderCode"].ToString();
                        var x1 = _personService.AddNewItem(recomenderPerson);
                        var recommPersID = recomenderPerson.Id;

                        recomenderInRelatedPerson = new RelatedPerson();
                        //add related person for recommender
                        recomenderInRelatedPerson.MainPersonId = relatadPersonRecomender_ParentId;
                        recomenderInRelatedPerson.RelatedPersonId = recommPersID;
                        recomenderInRelatedPerson.MainPersonRelationType = (byte)RelationType.Recommender;
                        var xx12 = _relatedPersonService.AddNewItem(recomenderInRelatedPerson);
                        var x13 = _personService.AddNewItem(recomenderPerson);

                        var userLog = new ISR.DAL.Amozesh_Initial.UserLog()
                        {
                            UserLogTypeId = decimal.Parse((((byte)LogsType.AddRecommenderForStudentByInternationalExpert).ToString()).ToString()),
                            LogDate = DateTime.Now,
                            ModifyId = int.Parse(requestId.ToString()),
                            Description = $"recommPersonId={int.Parse(recommPersID.ToString())}",
                            UserId = userId,
                            IP_dev = deviceIP
                        };
                        _userLogService.AddNewItem(userLog);
                    }
                }
            }
            else
            {
                res = new JsonResult { Data = new { Result = false, Message = Resources.Resources.InvalidRequestType } };
                return res;
            }

            res = new JsonResult { Data = new { Result = true, Message = Resources.Resources.RelatedPersonAdded } };
            return res;

        }


        [HttpPost]
        public JsonResult AddRelatedPerson(string data)
        {
            var res = new JsonResult();
            var dataObject = JObject.Parse(data);

            var userId = (Session["UserCmsInfo"] as UserLoginCmsViewModel)?.UserId;
            var deviceIP = Request.UserHostAddress;
            var requestId = decimal.Parse(dataObject["requestId"].ToString() ?? "-1");


            bool chkFlag = false;
            var msg = "";
            if (dataObject != null)
            {
                var parentPersonId = decimal.Parse(dataObject["parentPersonId"].ToString() ?? "-1");
                var parentPerson = parentPersonId == -1 ? null : _personService.FindById(parentPersonId);
                if (parentPerson != null)
                {
                    DateTime parsedDate;
                    DateTime.TryParseExact(dataObject["relatedPersonBirthDate"].ToString(), "yyyy/MM/dd", new CultureInfo("en-GB"), DateTimeStyles.None, out parsedDate);
                    //var cc = DateTime.Parse(dataObject["relatedPersonBirthDate"].ToString());

                    var childPerson = new Person()
                    {
                        FirstName = dataObject["relatedPersonFirstName"].ToString(),
                        LastName = dataObject["relatedPersonFirstName"].ToString(),
                        FatherName = dataObject["relatedPersonFatherName"].ToString(),
                        GrandFatherName = dataObject["relatedPersonGrandPa"].ToString(),
                        BirthDate = parsedDate,
                        Job = dataObject["relatedPersonJobTitle"].ToString(),
                        Active = true
                    };

                    chkFlag = _personService.AddNewItem(childPerson);
                    if (chkFlag)
                    {
                        var citizenShipChildPerson = new CitizenShip()
                        {
                            PersonId = childPerson.Id,
                            CountryId = decimal.Parse(dataObject["relatedPersonCitizenShip"].ToString()),
                            DocType = byte.Parse(dataObject["relatedPersonDocType"].ToString()),
                            DocNo = dataObject["relatedPersonDocNo"].ToString(),
                            IssueDate = DateTime.Now,
                            Active = true
                        };
                        chkFlag = _citizenShipService.AddNewItem(citizenShipChildPerson);
                        if (chkFlag)
                        {
                            var relPerson = new RelatedPerson()
                            {
                                MainPersonId = parentPersonId,
                                RelatedPersonId = childPerson.Id,
                                MainPersonRelationType = (byte)RelationType.FamilyMember,
                                RelatedPersonRelationType = byte.Parse(dataObject["relationType"].ToString())
                            };
                            chkFlag = _relatedPersonService.AddNewItem(relPerson);
                            if (!chkFlag)
                            {
                                msg = Resources.Resources.ErrorInDurationOfOperation;
                            }
                        }
                        else
                        {
                            msg = Resources.Resources.ErrorInDurationOfOperation;
                        }
                    }
                    else
                    {
                        msg = Resources.Resources.ErrorInDurationOfOperation;
                    }

                    //add log 
                    var userLog = new ISR.DAL.Amozesh_Initial.UserLog()
                    {
                        UserLogTypeId = decimal.Parse((((byte)LogsType.AddFamilyToStudentByInternationalExpert).ToString()).ToString()),
                        LogDate = DateTime.Now,
                        ModifyId = int.Parse(requestId.ToString()),
                        Description = $"relationType={EnumsPersianTitles.GetRecommenderRelationship(byte.Parse(dataObject["relationType"].ToString()))}",
                        UserId = userId,
                        IP_dev = deviceIP
                    };
                    _userLogService.AddNewItem(userLog);
                }
            }
            else
            {
                res = new JsonResult { Data = new { Result = false, Message = Resources.Resources.InvalidRequestType } };
                return res;
            }


            if (chkFlag)
            {
                res = new JsonResult { Data = new { Result = true, Message = Resources.Resources.RelatedPersonAdded } };
                return res;
            }
            else
            {
                res = new JsonResult { Data = new { Result = false, Message = msg } };
                return res;
            }

        }


        [HttpPost]
        public JsonResult RemoveRelatedPerson(string data)
        {
            var res = new JsonResult();
            var dataObject = JObject.Parse(data);
            bool chkFlag = false;
            var msg = "";
            if (dataObject != null)
            {
                var userId = (Session["UserCmsInfo"] as UserLoginCmsViewModel)?.UserId;
                var deviceIP = Request.UserHostAddress;
                var requestId = decimal.Parse(dataObject["requestId"].ToString() ?? "-1");

                var Id_RelatadPerson = decimal.Parse(dataObject["relatadPersonId"].ToString() ?? "-1");
                var relatedPerson = Id_RelatadPerson == -1 ? null : _relatedPersonService.FindById(Id_RelatadPerson);
                if (relatedPerson != null)
                {
                    chkFlag = _relatedPersonService.RemoveItem(relatedPerson);
                    if (chkFlag)
                    {
                        var relatedPersonId = decimal.Parse(relatedPerson?.RelatedPersonId.ToString() ?? "-1");
                        var childPerson = _personService.FindById(relatedPersonId);
                        if (childPerson != null)
                        {
                            //remove all related object to child person
                            _citizenShipService.FetchMany(c => c.PersonId == relatedPersonId).ToList().ForEach(prsn => chkFlag = _citizenShipService.RemoveItem(prsn));
                            _addressService.FetchMany(c => c.PersonId == relatedPersonId).ToList().ForEach(address => chkFlag = _addressService.RemoveItem(address));

                            //remove person in person table
                            chkFlag = _personService.RemoveItem(childPerson);

                            var userLog = new ISR.DAL.Amozesh_Initial.UserLog()
                            {
                                UserLogTypeId = decimal.Parse((((byte)LogsType.RemoveFamilyFromStudentByInternationalExpert).ToString()).ToString()),
                                LogDate = DateTime.Now,
                                ModifyId = int.Parse(requestId.ToString()),
                                Description = $"RelatedPersonRelationType={EnumsPersianTitles.GetRecommenderRelationship(relatedPerson?.RelatedPersonRelationType)}",
                                UserId = userId,
                                IP_dev = deviceIP
                            };
                            _userLogService.AddNewItem(userLog);
                        }
                        else
                            msg = Resources.Resources.InvalidRequestType;
                    }
                    else
                        msg = Resources.Resources.ErrorInDurationOfOperation;
                }
                else
                    msg = Resources.Resources.InvalidRequestType; ;
            }
            else
                msg = Resources.Resources.InvalidRequestType;

            if (chkFlag)
            {
                res = new JsonResult { Data = new { Result = true, Message = Resources.Resources.RelatedPersonAdded } };
                return res;
            }
            else
            {
                res = new JsonResult { Data = new { Result = false, Message = msg } };
                return res;
            }

        }


        [HttpPost]
        public ActionResult AddCandidateField(string studentId = "0", string fieldId = "0", string requestId = "0")
        {
            var OK = false;
            var userId = (Session["UserCmsInfo"] as UserLoginCmsViewModel)?.UserId;
            var deviceIP = Request.UserHostAddress;
            var reqId = decimal.Parse(requestId);
            if (studentId != "0" && fieldId != "0" && requestId != "0")
            {
                var stdId = decimal.Parse(studentId);
                var fId = decimal.Parse(fieldId);
                var student = _studentService.FindOne(s => s.Id == stdId);
                if (student != null && !student.CandidateFields.Any(a => a.StudentId == stdId && a.FieldId == fId))
                {
                    //student.CandidateFields.Add(new CandidateField() { StudentId = stdId, FieldId = fId, Active = true });
                    var res = _condidateService.AddNewItem(new CandidateField() { StudentId = stdId, FieldId = fId, Active = true });
                    OK = true;

                    var userLog = new ISR.DAL.Amozesh_Initial.UserLog()
                    {
                        UserLogTypeId = decimal.Parse((((byte)LogsType.AddNewStudentCondidateFieldByInternationalExpert).ToString()).ToString()),
                        LogDate = DateTime.Now,
                        ModifyId = int.Parse(reqId.ToString()),
                        Description = $"fieldId={fId.ToString()}",
                        UserId = userId,
                        IP_dev = deviceIP
                    };
                    _userLogService.AddNewItem(userLog);

                }
            }
            return new JsonResult { Data = new { IsTrue = OK } };
        }

        [HttpPost]
        public ActionResult DeleteField(string studentId = "0", string fieldId = "0", string requestId = "0")
        {
            JsonResult res;
            var msg = "";
            var flag = false;
            var userId = (Session["UserCmsInfo"] as UserLoginCmsViewModel)?.UserId;
            var deviceIP = Request.UserHostAddress;
            var reqId = decimal.Parse(requestId);

            if (studentId != "0" && fieldId != "0" && requestId != "0")
            {
                var stdId = decimal.Parse(studentId);
                var fId = decimal.Parse(fieldId);
                var student = _studentService.FindOne(s => s.Id == stdId);
                if (student != null && student.CandidateFields.Any(a => a.FieldId == fId))
                {
                    var candidateField = _condidateService.FindOne(s => s.FieldId == fId);
                    //var res = student.CandidateFields.Remove(candidateField);
                    var xx = _condidateService.RemoveItem(candidateField);
                    msg = Resources.Resources.SuccessOperation;
                    flag = true;

                    var userLog = new ISR.DAL.Amozesh_Initial.UserLog()
                    {
                        UserLogTypeId = decimal.Parse((((byte)LogsType.RemoveStudentCondidateFieldByInternationalExpert).ToString()).ToString()),
                        LogDate = DateTime.Now,
                        ModifyId = reqId,
                        Description = $"fieldId={fId.ToString()}",
                        UserId = userId,
                        IP_dev = deviceIP
                    };
                    _userLogService.AddNewItem(userLog);
                }
            }
            else
            {
                msg = Resources.Resources.InvalidRequestType;
            }
            res = new JsonResult { Data = new { IsTrue = flag, Message = msg } };
            return res;

            //return RedirectToRoute("Default", new { lang ="fa", controller = "Management", action = "RequestDetails" });
            //return RedirectToAction("RequestDetails", "Management", new { @id = decimal.Parse(requestId) });
        }

        [HttpPost]
        public ActionResult ConfirmField(string studentId = "0", string fieldId = "0", string requestId = "0")
        {
            JsonResult res;
            var msg = "";
            var flag = false;
            var userId = (Session["UserCmsInfo"] as UserLoginCmsViewModel)?.UserId;
            var deviceIP = Request.UserHostAddress;
            var reqId = decimal.Parse(requestId);

            if (studentId != "0" && fieldId != "0")
            {
                var stdId = decimal.Parse(studentId);
                var fId = decimal.Parse(fieldId);
                var student = _studentService.FindOne(s => s.Id == stdId);
                if (student != null && student.CandidateFields.Any(a => a.StudentId == stdId && a.FieldId == fId))
                {
                    var candidateField = _condidateService.FindOne(s => s.StudentId == stdId && s.FieldId == fId);
                    candidateField.Selected = true;
                    var xx = _condidateService.UpdatetItem(candidateField);
                    msg = Resources.Resources.SuccessOperation;
                    flag = true;

                    var userLog = new ISR.DAL.Amozesh_Initial.UserLog()
                    {
                        UserLogTypeId = decimal.Parse((((byte)LogsType.SelectMainFieldInCondidateFieldsByInternationalExpert).ToString()).ToString()),
                        LogDate = DateTime.Now,
                        ModifyId = int.Parse(reqId.ToString()),
                        Description = $"fieldId={fId.ToString()}",
                        UserId = userId,
                        IP_dev = deviceIP
                    };
                    _userLogService.AddNewItem(userLog);
                }
            }
            else
            {
                msg = Resources.Resources.InvalidRequestType;
            }
            res = new JsonResult { Data = new { IsTrue = flag, Message = msg } };
            return res;

            //return RedirectToRoute("Default", new { lang ="fa", controller = "Management", action = "RequestDetails" });
            //return RedirectToAction("RequestDetails", "Management", new { @id = decimal.Parse(requestId) });
        }


        [HttpPost]
        public JsonResult RejectRequest(int requestId = 0, string description = null)
        {
            if (requestId > 0)
            {
                var req = _requestService.FindById(requestId);
                if (req != null)
                {
                    req.Status = (byte)RequestStatus.Ex_Rejected;
                    req.Description = description;
                    _requestService.UpdatetItem(req);

                    var userId = (Session["UserCmsInfo"] as UserLoginCmsViewModel)?.UserId;
                    var deviceIP = Request.UserHostAddress;
                    var userLog = new ISR.DAL.Amozesh_Initial.UserLog()
                    {
                        UserLogTypeId = decimal.Parse((((byte)LogsType.RejectRequestByInternationalExpert).ToString()).ToString()),
                        LogDate = DateTime.Now,
                        ModifyId = int.Parse(requestId.ToString()),
                        Description = $"reqId={req.Id} ===> {description}",
                        UserId = userId,
                        IP_dev = deviceIP
                    };
                    _userLogService.AddNewItem(userLog);
                }
            }

            return null;
        }


        [HttpPost]
        public JsonResult AcceptRequest(string requestId)
        {
            if (!string.IsNullOrEmpty(requestId))
            {
                var reqId = int.Parse(requestId);
                var req = _requestService.FindById(reqId);
                if (req != null)
                {
                    var studentId = req.Student?.Id;
                    if (!string.IsNullOrEmpty(studentId?.ToString()))
                    {
                        var candidateFields = _condidateService.FetchMany(x => x.StudentId == studentId).ToList();
                        if (candidateFields != null && candidateFields.Count() > 0)
                        {
                            if (!candidateFields.Any(a => a.Selected))
                            {
                                var firstField = candidateFields.FirstOrDefault();
                                firstField.Selected = true;
                                _condidateService.UpdatetItem(firstField);
                            }
                        }
                    }

                    var userId = (Session["UserCmsInfo"] as UserLoginCmsViewModel)?.UserId;
                    var deviceIP = Request.UserHostAddress;
                    foreach (var item in req.Student.StudentDocs)
                    {
                        if (item.DocStatus != (byte)DocStatus.Accepted)
                        {
                            item.DocStatus = (byte)DocStatus.Accepted;
                            var userDocLog = new ISR.DAL.Amozesh_Initial.UserLog()
                            {
                                UserLogTypeId = decimal.Parse((((byte)LogsType.AcceptDocByInternationalExpert).ToString()).ToString()),
                                LogDate = DateTime.Now,
                                ModifyId = int.Parse(reqId.ToString()),
                                Description = $"docId={item.Id}",
                                UserId = userId,
                                IP_dev = deviceIP
                            };
                            _userLogService.AddNewItem(userDocLog);
                        }

                    }
                    req.Status = (byte)RequestStatus.Ex_Accepted;
                    req.Description = "";
                    _requestService.UpdatetItem(req);

                    var userLog = new ISR.DAL.Amozesh_Initial.UserLog()
                    {
                        UserLogTypeId = decimal.Parse((((byte)LogsType.AcceptRequestByInternationalExpert).ToString()).ToString()),
                        LogDate = DateTime.Now,
                        ModifyId = int.Parse(reqId.ToString()),
                        Description = $"reqId={req.Id}",
                        UserId = userId,
                        IP_dev = deviceIP
                    };
                    _userLogService.AddNewItem(userLog);


                    var newStudent = _newStudentService.FindOne(x => x.RequestId == req.Id);
                    if (newStudent != null)
                    {
                        newStudent.status = 0;
                        _newStudentService.UpdatetItem(newStudent);
                    }
                }
            }

            return null;
        }


        [HttpPost]
        public JsonResult CheckAllDocsAccepted(int requestId)
        {
            var req = _requestService.FindById(requestId);
            var res = false;
            if (req != null)
            {
                foreach (var item in req.Student.StudentDocs)
                {
                    if (item.DocStatus != (byte)DocStatus.Accepted)
                    {
                        res = true;
                        break;
                    }
                }
            }
            return new JsonResult { Data = new { HasUnacceptedDocumnets = res } };
        }


        [HttpPost]
        public JsonResult DoUpdateRequest(string data)
        {
            var res = new JsonResult();
            var dataObject = JObject.Parse(data);
            if (dataObject == null)
            {
                res = new JsonResult { Data = new { Result = false, Message = Resources.Resources.InvalidRequestType } };
                return res;
            }

            var reqId = decimal.Parse(dataObject["requestId"].ToString());
            var userId = (Session["UserCmsInfo"] as UserLoginCmsViewModel)?.UserId;
            var deviceIP = Request.UserHostAddress;

            var req = _requestService.FindById(reqId);
            if (req == null)
            {
                res = new JsonResult { Data = new { Result = false, Message = Resources.Resources.InvalidRequestType } };
                return res;
            }

            byte genderByte, marritalTypeByte, childrenCountByte, healthStatusByte, religionByte, recommenderDocTypeByte, recommenederRelationType, mothersMarritalTypeByte;
            DateTime parsedDate;


            //req.Student.Person.FirstName = dataObject["FirstName"].ToString();
            //req.Student.Person.MiddleName = dataObject["MiddleName"].ToString();
            //req.Student.Person.LastName = dataObject["LastName"].ToString();
            //req.Student.Person.FatherName = dataObject["FatherName"].ToString();
            //req.Student.Person.MotherName = dataObject["MotherName"].ToString();
            //req.Student.Person.GrandFatherName = dataObject["GrandFatherName"].ToString();
            //DateTime.TryParseExact(dataObject["BirthDate"].ToString(), "yyyy/MM/dd", new CultureInfo("en-GB"), DateTimeStyles.None, out parsedDate);
            //req.Student.Person.BirthDate = parsedDate;
            //req.Student.Person.BirthPlace = dataObject["BirthPlace"].ToString();
            //req.Student.Person.Gender = !string.IsNullOrEmpty(dataObject["Gender"].ToString()) && byte.TryParse(dataObject["Gender"].ToString(), out genderByte) ? Convert.ToByte(dataObject["Gender"].ToString()) : Convert.ToByte(0);
            //req.Student.Person.MarritalType = !string.IsNullOrEmpty(dataObject["MarritalType"].ToString()) && byte.TryParse(dataObject["MarritalType"].ToString(), out marritalTypeByte) ? Convert.ToByte(dataObject["MarritalType"].ToString()) : Convert.ToByte(0);

            //req.Student.Person.CitizenShips.FirstOrDefault().CountryId = Convert.ToDecimal(dataObject["FirstCountryId"].ToString());
            //req.Student.Person.CitizenShips.FirstOrDefault().DocNo = dataObject["DocNo"].ToString();

            //req.Student.Person.CitizenShips.LastOrDefault().CountryId = Convert.ToDecimal(dataObject["SecondCountryId"].ToString());

            //req.Student.ChildrenCount = !string.IsNullOrEmpty(dataObject["ChildrenCount"].ToString()) && byte.TryParse(dataObject["ChildrenCount"].ToString(), out childrenCountByte) ? Convert.ToByte(dataObject["ChildrenCount"].ToString()) : Convert.ToByte(0);
            //req.Student.HealthStatus = !string.IsNullOrEmpty(dataObject["HealthStatus"].ToString()) && byte.TryParse(dataObject["HealthStatus"].ToString(), out healthStatusByte) ? Convert.ToByte(dataObject["HealthStatus"].ToString()) : Convert.ToByte(0);
            //req.Student.Religien = !string.IsNullOrEmpty(dataObject["Religion"].ToString()) && byte.TryParse(dataObject["Religion"].ToString(), out religionByte) ? Convert.ToByte(dataObject["Religion"].ToString()) : Convert.ToByte(0);

            var student = _studentService.FindById(req.StudentId);
            if (student != null)
            {
                student.ChildrenCount = !string.IsNullOrEmpty(dataObject["ChildrenCount"].ToString()) && byte.TryParse(dataObject["ChildrenCount"].ToString(), out childrenCountByte) ? Convert.ToByte(dataObject["ChildrenCount"].ToString()) : Convert.ToByte(0);
                student.HealthStatus = !string.IsNullOrEmpty(dataObject["HealthStatus"].ToString()) && byte.TryParse(dataObject["HealthStatus"].ToString(), out healthStatusByte) ? Convert.ToByte(dataObject["HealthStatus"].ToString()) : Convert.ToByte(0);
                student.Religien = !string.IsNullOrEmpty(dataObject["Religion"].ToString()) && byte.TryParse(dataObject["Religion"].ToString(), out religionByte) ? Convert.ToByte(dataObject["Religion"].ToString()) : Convert.ToByte(0);

                var x1 = _studentService.UpdatetItem(student);
            }

            var person = _personService.FindById(req.Student.PersonId);

            if (person != null)
            {
                person.FirstName = dataObject["FirstName"].ToString();
                person.MiddleName = dataObject["MiddleName"].ToString();
                person.LastName = dataObject["LastName"].ToString();
                person.FatherName = dataObject["FatherName"].ToString();
                person.MotherName = dataObject["MotherName"].ToString();
                person.GrandFatherName = dataObject["GrandFatherName"].ToString();

                DateTime.TryParseExact(dataObject["BirthDate"].ToString(), "yyyy/MM/dd", new CultureInfo("en-GB"), DateTimeStyles.None, out parsedDate);
                person.BirthDate = DateTime.Parse(dataObject["BirthDate"].ToString(), new CultureInfo("en-GB"));//parsedDate;
                person.BirthPlace = dataObject["BirthPlace"].ToString();
                person.Gender = !string.IsNullOrEmpty(dataObject["Gender"].ToString()) && byte.TryParse(dataObject["Gender"].ToString(), out genderByte) ? Convert.ToByte(dataObject["Gender"].ToString()) : Convert.ToByte(0);
                person.MarritalType = !string.IsNullOrEmpty(dataObject["MarritalType"].ToString()) && byte.TryParse(dataObject["MarritalType"].ToString(), out marritalTypeByte) ? Convert.ToByte(dataObject["MarritalType"].ToString()) : Convert.ToByte(0);

                var x1 = _personService.UpdatetItem(person);
            }

            var personCitizenShips = _citizenShipService.FetchMany(x => x.PersonId == req.Student.PersonId);
            var firstCitizenShip = personCitizenShips.FirstOrDefault();
            var secondaryCitizenShip = personCitizenShips.FirstOrDefault(ss => ss.CountryId != firstCitizenShip.CountryId);
            if (firstCitizenShip != null)
            {
                firstCitizenShip.CountryId = Convert.ToDecimal(dataObject["FirstCountryId"].ToString());
                firstCitizenShip.DocNo = dataObject["DocNo"].ToString();
                var x1 = _citizenShipService.UpdatetItem(firstCitizenShip);
            }


            if (dataObject["SecondCountryId"] != null && !string.IsNullOrEmpty(dataObject["SecondCountryId"].ToString()) && dataObject["SecondCountryId"].ToString().Trim() != "0")
            {
                if (secondaryCitizenShip != null)
                {
                    secondaryCitizenShip.CountryId = Convert.ToDecimal(dataObject["SecondCountryId"].ToString());
                    var x1 = _citizenShipService.UpdatetItem(secondaryCitizenShip);
                }
                else if (Convert.ToDecimal(dataObject["SecondCountryId"].ToString()) != firstCitizenShip.CountryId)
                {
                    secondaryCitizenShip = new CitizenShip();
                    secondaryCitizenShip.PersonId = req.Student.PersonId;
                    secondaryCitizenShip.CountryId = Convert.ToDecimal(dataObject["SecondCountryId"].ToString());
                    secondaryCitizenShip.DocType = firstCitizenShip?.DocType == null ? 0 : firstCitizenShip?.DocType;
                    secondaryCitizenShip.DocNo = dataObject["DocNo"].ToString();
                    secondaryCitizenShip.IssueDate = DateTime.Now;
                    secondaryCitizenShip.Active = true;
                    var x2 = _citizenShipService.AddNewItem(secondaryCitizenShip);
                }

            }

            var personAddresses = _addressService.FetchMany(a => a.PersonId == req.Student.PersonId);
            if (!string.IsNullOrEmpty(dataObject["IranHomeCity"].ToString()) || !string.IsNullOrEmpty(dataObject["IranHomeState"].ToString()))
            {
                //var iranHome = req.Student.Person.Addresses.Where(w => w.AddressType == (byte)AddressType.IranResidenceAddress).FirstOrDefault();
                var iranHome = personAddresses?.Where(w => w.AddressType == (byte)AddressType.IranResidenceAddress).FirstOrDefault();
                if (iranHome != null)
                {
                    iranHome.City = dataObject["IranHomeCity"].ToString();
                    iranHome.PhoneNo = dataObject["IranHomePhone"].ToString();
                    iranHome.Plaque = dataObject["IranHomeNumber"].ToString();
                    iranHome.PostalCode = dataObject["IranHomePostalCode"].ToString();
                    iranHome.Province = dataObject["IranHomeState"].ToString();
                    iranHome.Street = dataObject["IranHomeStreet"].ToString();
                    iranHome.Email = dataObject["IranHomeEmail"].ToString();
                    iranHome.Mobile = dataObject["IranHomeMobile"].ToString();
                    iranHome.PreCodeForMobile = dataObject["IranHomeMobileCode"].ToString();
                    iranHome.PreCodeForPhoneNo = dataObject["IranHomePhoneCode"].ToString();

                    var x1 = _addressService.UpdatetItem(iranHome);
                }

            }
            if (!string.IsNullOrEmpty(dataObject["IranWorkCity"].ToString()) || !string.IsNullOrEmpty(dataObject["IranWorkState"].ToString()))
            {
                //var iranWork = req.Student.Person.Addresses.Where(w => w.AddressType == (byte)AddressType.IranWorkPlaceAddress).FirstOrDefault();
                var iranWork = personAddresses?.Where(w => w.AddressType == (byte)AddressType.IranWorkPlaceAddress).FirstOrDefault();
                if (iranWork != null)
                {
                    iranWork.City = dataObject["IranWorkCity"].ToString();//!string.IsNullOrEmpty(dataObject["IranWorkCity"].ToString()) ? Convert.ToDecimal(dataObject["IranWorkCity"].ToString()) : 0,
                    iranWork.PhoneNo = dataObject["IranWorkPhone"].ToString();
                    iranWork.Plaque = dataObject["IranWorkNumber"].ToString();
                    iranWork.PostalCode = dataObject["IranWorkPostalCode"].ToString();
                    iranWork.Province = dataObject["IranWorkState"].ToString();//!string.IsNullOrEmpty(dataObject["IranWorkState"].ToString()) ? Convert.ToDecimal(dataObject["IranWorkState"].ToString()) : 0,
                    iranWork.Street = dataObject["IranWorkStreet"].ToString();

                    var x1 = _addressService.UpdatetItem(iranWork);
                }
            }
            if (!string.IsNullOrEmpty(dataObject["CitizenshipHomeCity"].ToString()) || !string.IsNullOrEmpty(dataObject["CitizenshipHomeState"].ToString()))
            {
                //var ctznshipResidenceAddress = req.Student.Person.Addresses.Where(w => w.AddressType == (byte)AddressType.CitizenshipResidenceAddress).FirstOrDefault();
                var ctznshipResidenceAddress = personAddresses?.Where(w => w.AddressType == (byte)AddressType.CitizenshipResidenceAddress).FirstOrDefault();
                if (ctznshipResidenceAddress != null)
                {
                    ctznshipResidenceAddress.City = dataObject["CitizenshipHomeCity"].ToString();//!string.IsNullOrEmpty(dataObject["CitizenshipHomeCity"].ToString()) ? Convert.ToDecimal(dataObject["CitizenshipHomeCity"].ToString()) : 0,
                    ctznshipResidenceAddress.PhoneNo = dataObject["CitizenshipHomePhone"].ToString();
                    ctznshipResidenceAddress.Plaque = dataObject["CitizenshipHomeNumber"].ToString();
                    ctznshipResidenceAddress.PostalCode = dataObject["CitizenshipHomePostalCode"].ToString();
                    ctznshipResidenceAddress.Province = dataObject["CitizenshipHomeState"].ToString();//!string.IsNullOrEmpty(dataObject["CitizenshipHomeState"].ToString()) ? Convert.ToDecimal(dataObject["CitizenshipHomeState"].ToString()) : 0,
                    ctznshipResidenceAddress.Street = dataObject["CitizenshipHomeStreet"].ToString();
                    ctznshipResidenceAddress.Email = dataObject["CitizenshipHomeEmail"].ToString();
                    ctznshipResidenceAddress.Mobile = dataObject["CitizenshipHomeMobile"].ToString();
                    ctznshipResidenceAddress.PreCodeForMobile = dataObject["CitizenshipHomeMobileCode"].ToString();
                    ctznshipResidenceAddress.PreCodeForPhoneNo = dataObject["CitizenshipHomePhoneCode"].ToString();
                    var x1 = _addressService.UpdatetItem(ctznshipResidenceAddress);
                }

            }
            if (!string.IsNullOrEmpty(dataObject["CitizenshipWorkCity"].ToString()) || !string.IsNullOrEmpty(dataObject["CitizenshipWorkState"].ToString()))
            {
                //var ctznshipWorkPlaceAddress = req.Student.Person.Addresses.Where(w => w.AddressType == (byte)AddressType.CitizenshipWorkPlaceAddress).FirstOrDefault();
                var ctznshipWorkPlaceAddress = personAddresses?.Where(w => w.AddressType == (byte)AddressType.CitizenshipWorkPlaceAddress).FirstOrDefault();
                if (ctznshipWorkPlaceAddress != null)
                {
                    ctznshipWorkPlaceAddress.City = dataObject["CitizenshipWorkCity"].ToString();//!string.IsNullOrEmpty(dataObject["CitizenshipWorkCity"].ToString()) ? Convert.ToDecimal(dataObject["CitizenshipWorkCity"].ToString()) : 0,
                    ctznshipWorkPlaceAddress.PhoneNo = dataObject["CitizenshipWorkPhone"].ToString();
                    ctznshipWorkPlaceAddress.Plaque = dataObject["CitizenshipWorkNumber"].ToString();
                    ctznshipWorkPlaceAddress.PostalCode = dataObject["CitizenshipWorkPostalCode"].ToString();
                    ctznshipWorkPlaceAddress.Province = dataObject["CitizenshipWorkState"].ToString();//!string.IsNullOrEmpty(dataObject["CitizenshipWorkState"].ToString()) ? Convert.ToDecimal(dataObject["CitizenshipWorkState"].ToString()) : 0,
                    ctznshipWorkPlaceAddress.Street = dataObject["CitizenshipWorkStreet"].ToString();
                    var x1 = _addressService.UpdatetItem(ctznshipWorkPlaceAddress);
                }

            }

            var studentDegrees = _educationDegreeService.FetchMany(e => e.SudentId == req.StudentId);

            if (!string.IsNullOrEmpty(dataObject["DiplomaFieldTitle"].ToString()))
            {
                //var diplomaLevel = req.Student.EducationDegrees.Where(w => w.Level == (byte)Levels.Diploma).FirstOrDefault();
                var diplomaLevel = studentDegrees?.Where(w => w.Level == (byte)Levels.Diploma).FirstOrDefault();
                if (diplomaLevel != null)
                {
                    diplomaLevel.UniversityName = dataObject["DiplomaEducationDegreePlace"].ToString();
                    //FieldId = Convert.ToDecimal(dataObject["DiplomaFieldId"].ToString()),
                    diplomaLevel.FieldTitle = dataObject["DiplomaFieldTitle"].ToString();
                    //diplomaLevel.SudentId = req.Student.Id;
                    diplomaLevel.TotalAverage = decimal.Parse(dataObject["DiplomaTotalAverage"].ToString(), CultureInfo.InvariantCulture);
                    diplomaLevel.WrittenAverage = decimal.Parse(dataObject["DiplomaWrittenAverage"].ToString(), CultureInfo.InvariantCulture);
                    var x1 = _educationDegreeService.UpdatetItem(diplomaLevel);
                }
            }


            if (!string.IsNullOrEmpty(dataObject["PreuniversityTotalAverage"].ToString()))
            {
                //var preUniversityLevel = req.Student.EducationDegrees.Where(w => w.Level == (byte)Levels.PreUniversity).FirstOrDefault();
                var preUniversityLevel = studentDegrees?.Where(w => w.Level == (byte)Levels.PreUniversity).FirstOrDefault();
                if (preUniversityLevel != null)
                {
                    preUniversityLevel.TotalAverage = Convert.ToDecimal(dataObject["PreuniversityTotalAverage"].ToString(), CultureInfo.InvariantCulture);
                    //preUniversityLevel.FieldTitle = dataObject["PreuniversityFieldTitle"].ToString();
                    //FieldId = Convert.ToDecimal(dataObject["PreuniversityFieldId"].ToString()),
                    var x1 = _educationDegreeService.UpdatetItem(preUniversityLevel);
                }
            }


            if (!string.IsNullOrEmpty(dataObject["BachelorFieldTitle"].ToString()))
            {
                //var bachelorLevel = req.Student.EducationDegrees.Where(w => w.Level == (byte)Levels.Bachelor).FirstOrDefault();
                var bachelorLevel = studentDegrees?.Where(w => w.Level == (byte)Levels.Bachelor).FirstOrDefault();
                if (bachelorLevel != null)
                {
                    bachelorLevel.FieldTitle = dataObject["BachelorFieldTitle"].ToString();
                    bachelorLevel.CountryName = dataObject["BachelorCountryName"].ToString();
                    bachelorLevel.UniversityName = dataObject["BachelorUniversityName"].ToString();
                    bachelorLevel.TotalAverage = decimal.Parse(dataObject["BachelorTotalAverage"].ToString(), CultureInfo.InvariantCulture);
                    var x1 = _educationDegreeService.UpdatetItem(bachelorLevel);
                }
            }

            if (!string.IsNullOrEmpty(dataObject["MAFieldTitle"].ToString()))
            {
                //var masterLevel = req.Student.EducationDegrees.Where(w => w.Level == (byte)Levels.Master).FirstOrDefault();
                var masterLevel = studentDegrees?.Where(w => w.Level == (byte)Levels.Master).FirstOrDefault();
                if (masterLevel != null)
                {
                    masterLevel.FieldTitle = dataObject["MAFieldTitle"].ToString();
                    masterLevel.CountryName = dataObject["MACountryName"].ToString();
                    masterLevel.UniversityName = dataObject["MAUniversityName"].ToString();
                    masterLevel.TotalAverage = decimal.Parse(dataObject["MATotalAverage"].ToString(), CultureInfo.InvariantCulture);
                    var x1 = _educationDegreeService.UpdatetItem(masterLevel);
                }
            }

            if (!string.IsNullOrEmpty(dataObject["DoctorateFieldTitle"].ToString()))
            {
                //var phdLevel = req.Student.EducationDegrees.Where(w => w.Level == (byte)Levels.Phd).FirstOrDefault();
                var phdLevel = studentDegrees?.Where(w => w.Level == (byte)Levels.Phd).FirstOrDefault();
                if (phdLevel != null)
                {
                    //FieldId = Convert.ToDecimal(dataObject["DoctorateFieldId"].ToString()),
                    phdLevel.FieldTitle = dataObject["DoctorateFieldTitle"].ToString();
                    phdLevel.CountryName = dataObject["DoctorateCountryName"].ToString();
                    phdLevel.UniversityName = dataObject["DoctorateUniversityName"].ToString();
                    phdLevel.TotalAverage = decimal.Parse(dataObject["DoctorateTotalAverage"].ToString(), CultureInfo.InvariantCulture);
                    var x1 = _educationDegreeService.UpdatetItem(phdLevel);
                }
            }



            //if (!string.IsNullOrEmpty(dataObject["RecommenderFirstName"].ToString()) && DateTime.TryParseExact(dataObject["RecommenderBirthDate"].ToString(), "yyyy/MM/dd", new CultureInfo("en-GB"), DateTimeStyles.None, out parsedDate))
            if (dataObject["RecommenderCode"] != null && !string.IsNullOrEmpty(dataObject["RecommenderCode"].ToString()))
            {
                var relatedPersonId = _relatedPersonService.FindOne(p => p.MainPersonId == req.Student.PersonId && p.MainPersonRelationType == (byte)RelationType.Recommender)?.RelatedPersonId;
                if (relatedPersonId != null)
                {
                    var personRecomender = _personService.FindById(relatedPersonId);
                    //var person_recomend = req.Student.Person?.RelatedPerson?.Where(x => x.MainPersonRelationType == (byte)RelationType.Recommender)?.FirstOrDefault()?.Person;                
                    if (personRecomender != null)
                    {
                        //personRecomender.BirthDate = parsedDate;
                        //personRecomender.FatherName = dataObject["RecommenderFatherName"].ToString();
                        //personRecomender.FirstName = dataObject["RecommenderFirstName"].ToString();
                        //personRecomender.GrandFatherName = dataObject["RecommenderGrandFatherName"].ToString();
                        //personRecomender.LastName = dataObject["RecommenderLastName"].ToString();
                        //personRecomender.Job = dataObject["RecommenderJob"].ToString();
                        personRecomender.Active = true;
                        personRecomender.RecommenderCode = dataObject["RecommenderCode"].ToString();

                        var x1 = _personService.UpdatetItem(personRecomender);
                    }

                    //var ctyznShip = personRecomender.CitizenShips.FirstOrDefault();
                    //var ctyznShip = _citizenShipService.FetchMany(c => c.PersonId == relatedPersonId).FirstOrDefault();
                    //if (ctyznShip != null)
                    //{
                    //    ctyznShip.DocType = byte.TryParse(dataObject["RecommenderDocType"].ToString(), out recommenderDocTypeByte) ? Convert.ToByte(dataObject["RecommenderDocType"].ToString()) : Convert.ToByte(0);
                    //    ctyznShip.CountryId = Convert.ToDecimal(dataObject["RecommenderCountryId"].ToString());
                    //    ctyznShip.DocNo = dataObject["RecommenderDocNo"].ToString();

                    //    var x1 = _citizenShipService.UpdatetItem(ctyznShip);
                    //}
                    //var personRecomenderAddress = _addressService.FetchMany(a => a.PersonId == relatedPersonId).FirstOrDefault();
                    ////var personRecomenderAddress = personRecomender?.Addresses?.FirstOrDefault();
                    //if (personRecomenderAddress != null)
                    //{
                    //    personRecomenderAddress.Mobile2 = dataObject["RecommenderMobile"].ToString();
                    //    personRecomenderAddress.PreCodeForMobile = dataObject["RecommenderMobileCode"].ToString();
                    //    var x1 = _addressService.UpdatetItem(personRecomenderAddress);
                    //}
                }






                //_personService.AddNewItem(recom);
                //relatedPeople.Add(new RelatedPerson
                //{
                //    MainPersonId = account.Student.Person.Id,
                //    MainPersonRelationType = (byte)RelationType.Recommender,
                //    RelatedPersonId = recom.Id,
                //    RelatedPersonRelationType = byte.TryParse(dataObject["RecommenderRelationship"].ToString(), out recommenederRelationType) ? recommenederRelationType : Convert.ToByte(0)
                //});
            }


            if (!string.IsNullOrEmpty(dataObject["MothersFirstName"].ToString()) && DateTime.TryParseExact(dataObject["MothersBirthDate"].ToString(), "yyyy/MM/dd", new CultureInfo("en-GB"), DateTimeStyles.None, out parsedDate))
            {
                var irannianModer_PersonalId = _relatedPersonService.FindOne(p => p.MainPersonId == req.Student.PersonId && p.MainPersonRelationType == (byte)RelationType.Mother)?.RelatedPersonId;
                if (irannianModer_PersonalId != null)
                {
                    var personIrMother = _personService.FindById(irannianModer_PersonalId);
                    DateTime.TryParseExact(dataObject["MothersBirthDate"].ToString(), "yyyy/MM/dd", new CultureInfo("en-GB"), DateTimeStyles.None, out parsedDate);
                    personIrMother.BirthDate = parsedDate;
                    if (personIrMother != null)
                    {
                        personIrMother.FirstName = dataObject["MothersFirstName"].ToString();
                        personIrMother.LastName = dataObject["MothersLastName"].ToString();
                        personIrMother.FatherName = dataObject["MothersFatherName"].ToString();
                        personIrMother.GrandFatherName = dataObject["MothersGrandFatherName"].ToString();

                        personIrMother.IdNo = dataObject["MothersGrandFatherName"].ToString();
                        personIrMother.IssuePlace = dataObject["MothersGrandFatherName"].ToString();
                        personIrMother.BirthPlace = dataObject["MothersGrandFatherName"].ToString();
                        personIrMother.NationalCode = dataObject["MothersGrandFatherName"].ToString();
                        personIrMother.MarritalType = byte.Parse(dataObject["MothersMarritalType"].ToString());
                        personIrMother.BirthDate = parsedDate;

                        var x1 = _personService.UpdatetItem(personIrMother);
                    }
                }
            }


            var userLog = new ISR.DAL.Amozesh_Initial.UserLog()
            {
                UserLogTypeId = decimal.Parse((((byte)LogsType.EditRequestByInternationalExpert).ToString()).ToString()),
                LogDate = DateTime.Now,
                ModifyId = int.Parse(reqId.ToString()),
                Description = $"reqId={int.Parse(reqId.ToString())}",
                UserId = userId,
                IP_dev = deviceIP
            };
            _userLogService.AddNewItem(userLog);






            //var x2 = _requestService.UpdatetItem(req);
            res = new JsonResult { Data = new { Result = true, Message = Resources.Resources.RequestUpdated } };
            return res;

            //foreach (var f in dataObject["CondidateFields"].Children())
            //{
            //    account.Student.CandidateFields.Add(new CandidateField
            //    {
            //        Active = true,
            //        FieldId = Convert.ToDecimal(f.ToString()),
            //        StudentId = account.Student.Id
            //    });
            //}

























            //if (_accountService.UpdatetItem((account)))
            //{
            //    /*-----------------------------------------------*/
            //    var relatedPeople = new List<RelatedPerson>();//new List<KeyValuePair<decimal, byte>>();
            //    var person = _personService.FindById(account.Student.Person.Id);
            //    if (!string.IsNullOrEmpty(dataObject["MothersFirstName"].ToString()) && DateTime.TryParseExact(dataObject["MothersBirthDate"].ToString(), "yyyy/MM/dd", new CultureInfo("en-GB"), DateTimeStyles.None, out parsedDate))
            //    {
            //        var mother = new Person
            //        {
            //            Active = true,
            //            BirthDate = parsedDate,
            //            BirthPlace = dataObject["MothersBirthPlace"].ToString(),
            //            FatherName = dataObject["MothersFatherName"].ToString(),
            //            FirstName = dataObject["MothersFirstName"].ToString(),
            //            Gender = (byte)Gender.Female,
            //            GrandFatherName = dataObject["MothersGrandFatherName"].ToString(),
            //            IdNo = dataObject["MothersIdNo"].ToString(),
            //            IssuePlace = dataObject["MothersIssuePlace"].ToString(),
            //            LastName = dataObject["MothersLastName"].ToString(),
            //            NationalCode = dataObject["MothersNationalCode"].ToString(),
            //            MarritalType = byte.TryParse(dataObject["MothersMarritalType"].ToString(), out mothersMarritalTypeByte) ? Convert.ToByte(dataObject["MothersMarritalType"].ToString()) : Convert.ToByte(0),
            //            //RelatedPerson = new List<RelatedPerson> {
            //            //    new RelatedPerson {
            //            //        MainPersonId = account.Student.Person.Id,
            //            //        RelationType = (byte)RelationType.مادر
            //            //    }
            //            //}
            //        };
            //        _personService.AddNewItem(mother);
            //        relatedPeople.Add(new RelatedPerson
            //        {
            //            MainPersonId = account.Student.Person.Id,
            //            MainPersonRelationType = (byte)RelationType.Mother,
            //            RelatedPersonId = mother.Id,
            //        });
            //    }



            //    foreach (var p in dataObject["RelatedPersons"].Children())
            //    {
            //        if (DateTime.TryParseExact(p["BirthDate"].ToString(), "yyyy/MM/dd", new CultureInfo("en-GB"), DateTimeStyles.None, out parsedDate))
            //        {
            //            var rel = new Person
            //            {
            //                Active = true,
            //                BirthDate = parsedDate,
            //                FatherName = p["FathersName"].ToString(),
            //                FirstName = p["FirstName"].ToString(),
            //                GrandFatherName = p["GrandFathersName"].ToString(),
            //                LastName = p["LastName"].ToString(),
            //                Job = p["Job"].ToString(),
            //                CitizenShips = new List<CitizenShip> {
            //                    new CitizenShip {
            //                        Active = true
            //                        , CountryId = Convert.ToDecimal(p["Citizenship"].ToString())
            //                        , DocNo = p["DocNo"].ToString()
            //                        , DocType = Convert.ToByte(p["DocType"].ToString())
            //                    }
            //                },
            //                //RelatedPerson = new List<RelatedPerson> {
            //                //    new RelatedPerson{
            //                //        MainPersonId = account.Student.Person.Id,
            //                //RelationType = (byte)RelationType.اعضای_خانواده,
            //                //    }
            //                //}
            //            };
            //            _personService.AddNewItem(rel);
            //            relatedPeople.Add(new RelatedPerson
            //            {
            //                MainPersonId = account.Student.Person.Id,
            //                MainPersonRelationType = (byte)RelationType.FamilyMember,
            //                RelatedPersonId = rel.Id,
            //                RelatedPersonRelationType = byte.TryParse(p["Relationship"].ToString(), out recommenederRelationType) ? recommenederRelationType : Convert.ToByte(0)
            //            });
            //        }
            //    }

            //    foreach (var item in relatedPeople)
            //        _relatedPerson.AddNewItem(item);

            //    //_personService.UpdatetItem(person);
            //    /*-----------------------------------------------*/

            //    Session["RequestId"] = account.Student.Requests.LastOrDefault().Id;
            //    res = new JsonResult
            //    {
            //        Data = new
            //        {
            //            Result = true
            //                            ,
            //            ReqId = account.Student.Requests.LastOrDefault().Id,
            //            Message = string.Empty
            //        }
            //    };
            //}
            //else
            //{
            //    res = new JsonResult
            //    {
            //        Data = new
            //        {
            //            Result = false
            //                        ,
            //            Message = Resources.Resources.Critical_Error
            //        }
            //    };
            //}

        }

        //public void ChangeDocStatus(int docId, int status)
        //{
        //    var doc = _studentDocService.FindById(docId);
        //    if (doc != null)
        //    {
        //        doc.DocStatus = Convert.ToByte(status);
        //        _studentDocService.UpdatetItem(doc);

        //        var userId = (Session["UserCmsInfo"] as UserLoginCmsViewModel)?.UserId;
        //        var deviceIP = Request.UserHostAddress;
        //        var userLog = new UserLog()
        //        {
        //            LogTypeId = decimal.Parse((((byte)LogsType.RejectRequestByInternationalExpert).ToString()).ToString()),
        //            LogDate = DateTime.Now,
        //            ModifyId = docId,
        //            Description = $"docId={doc.Id}",
        //            UserId = userId,
        //            IP_dev = deviceIP
        //        };
        //        _userLogService.AddNewItem(userLog);
        //    }

        //}


        [HttpPost]
        public JsonResult ChangeStudentDocStatus(decimal docId, string statusName, string requestId = "0", string description = null)
        {
            if (docId > 0)
            {
                var doc = _studentDocService.FindById(docId);
                switch (statusName)
                {
                    case "Accepted":
                        doc.DocStatus = (byte)DocStatus.Accepted;
                        doc.Description = description;
                        break;
                    case "Rejected":
                        doc.DocStatus = (byte)DocStatus.Rejected;
                        doc.Description = description;
                        break;
                }

                _studentDocService.UpdatetItem(doc);

                var userId = (Session["UserCmsInfo"] as UserLoginCmsViewModel)?.UserId;
                var deviceIP = Request.UserHostAddress;
                var logTypeId = "";

                switch (statusName)
                {
                    case "Accepted":
                        logTypeId = (((byte)LogsType.AcceptDocByInternationalExpert).ToString()).ToString();
                        break;
                    case "Rejected":
                        logTypeId = (((byte)LogsType.RejecDocByInternationalExpert).ToString()).ToString();
                        break;
                }

                var userLog = new ISR.DAL.Amozesh_Initial.UserLog()
                {
                    UserLogTypeId = decimal.Parse(logTypeId),
                    LogDate = DateTime.Now,
                    ModifyId = decimal.Parse(requestId),
                    Description = $"docId={doc.Id} =====> {description}",
                    UserId = userId,
                    IP_dev = deviceIP
                };
                _userLogService.AddNewItem(userLog);
            }
            return null;
        }



    }
}