using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;
using System.Web.Configuration;
using Newtonsoft.Json.Linq;
using Newtonsoft.Json;
using System.Globalization;
using ISR.DAL.Amozesh_Initial;
using ISR.Services;
using ISR.Commons.enums;
using ISR.Commons;
using ISR.web.Models;

namespace ISR.web.Controllers
{
    public class RequestController : Controller
    {
        #region Fields
        private readonly IAccountService _accountService;
        private readonly IRequestService _requestService;
        private readonly IFieldForForeignService _fieldForForeignService;
        private readonly ICollegeService _collegeService;
        private readonly ICountryService _countryService;
        private readonly IPersonService _personService;
        private readonly IRelatedPersonService _relatedPerson;
        private readonly IFieldForForeignService _fieldService;
        private string _langCode;
        #endregion

        #region Ctor
        public RequestController(IAccountService accountService
            , IRequestService requestService
            , IFieldForForeignService fieldForForeignService
            , ICollegeService collegeService
            , ICountryService countryService
            , IPersonService personService
            , IRelatedPersonService relatedPerson

            )
        {
            System.IO.File.WriteAllText(Server.MapPath("~/debug.txt"),"ششششش");

            _accountService = accountService;
            _requestService = requestService;
            _fieldForForeignService = fieldForForeignService;
            _collegeService = collegeService;
            _countryService = countryService;
            _personService = personService;
            _relatedPerson = relatedPerson;

        }
        #endregion

        // GET: Request
        public ActionResult Index()
        {
            if (Session["UserInfo"] == null)
                return RedirectToAction("Index", "Account");
            var userInfo = (UserViewModel)Session["UserInfo"];
            var user = _accountService.FindById(userInfo.Id);
            if (user == null)
                return RedirectToAction("Index", "Account");

            if (user.Student.Requests.Count() == 0)
                return RedirectToAction("AddStudentRequestInfo");
            if (user.Student.Requests.LastOrDefault().Status == (int)RequestStatus.InfoAdded)
            {
                Session["RequestId"] = user.Student.Requests.LastOrDefault().Id;
                return RedirectToAction("UploadDocuments", "Documents");
            }


            var model = user.Student.Requests.Select(s => new RequestViewModel
            {
                CreateDate = ((DateTime)s.CreateDate)
                ,
                Status = Convert.ToInt32(s.Status)
                ,
                StatusName = Resources.Resources.ResourceManager.GetString(((RequestStatus)s.Status).ToString())
                ,
                Id = s.Id
            }).ToList();

            return View(model);
        }

        public ActionResult ShowDetails(int id = 0)
        {
            if (id == 0 || Session["UserInfo"] == null)
                return RedirectToAction("Index");
            var userInfo = (UserViewModel)Session["UserInfo"];
            var req = _requestService.FindById(id);
            if (req == null || req.Student.Accounts.FirstOrDefault().Id != userInfo.Id)
                RedirectToAction("Index");

            var model = new RequestViewModel
            {
                CreateDate = (DateTime)req.CreateDate,
                Id = req.Id,
                Status = (int)req.Status,
                StatusName = Resources.Resources.ResourceManager.GetString(((RequestStatus)req.Status).ToString()),
                Discription = req.Description,
                Documents = req.Student.StudentDocs.Where(w => w.Term == req.Term).Select(s => new RequestDocViewModel
                {
                    Category = s.Category,
                    CategoryTitle = Resources.Resources.ResourceManager.GetString(((DocType)s.Category).ToString()),
                    DocStatus = s.DocStatus,
                    DocStatusTitle = Resources.Resources.ResourceManager.GetString(((DocStatus)s.DocStatus).ToString()),
                    FileName = s.FileName,
                    Id = s.Id,
                    Path = s.Path,
                    StudentId = s.SudentId,
                    Term = s.Term,
                    Description = s.Description
                }).ToList()
            };
            return View(model);
        }


        public ActionResult PrintInfo(int id = 0)
        {
            if (id == 0 || Session["UserInfo"] == null)
                return RedirectToAction("Index");
            var userInfo = (UserViewModel)Session["UserInfo"];
            var req = _requestService.FindById(id);
            if (req == null || req.Student.Accounts.FirstOrDefault().Id != userInfo.Id)
                RedirectToAction("Index");

            var logo = "data:image/jpg;base64,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";
            ViewBag.Logo = logo;

            var lng = Session["lang"].ToString();
            var condidateField_FieldIds = req.Student.CandidateFields.Where(w2 => w2.StudentId == req.StudentId).Select(s => s.FieldId).ToArray();
            var Sida_IDs = _fieldForForeignService.FetchMany(ss => condidateField_FieldIds.Contains(ss.Id)).ToList().Select(s => s.Sida_ID).ToArray();
            var filteredFields = _fieldForForeignService.FetchMany(f => Sida_IDs.Contains(f.Sida_ID)).ToList();
            var collages = _collegeService.FetchAll().ToList();

            var candidateFields = (from f in filteredFields
                                   join col in collages on f.CollegeId equals col.Id
                                   where f.LanguageCode == lng
                                   select new SelectedFieldsViewModel
                                   {
                                       FiledId = f.Id,
                                       FiledTitle = f.Field_Name,
                                       CollageTitle = col.CollegeName,
                                       LangCode = f.LanguageCode
                                   }).OrderBy(o => o.LangCode).ToList();

            var lastLevel = req.Student.EducationDegrees.Where(w => w.SudentId == req.StudentId).OrderByDescending(ord => ord.Level).FirstOrDefault().Level;
            var personalImage = req.Student.StudentDocs.FirstOrDefault(cat => cat.Category == (byte)DocType.PersonalPicture);

            var model = new PrintViewModel
            {
                CreateDate = (DateTime)req.CreateDate,
                RequestId = req.Id,
                PeronalImagePath = personalImage.Path + "/" + personalImage.FileName + "?ts=" + DateTimeOffset.Now.ToUnixTimeMilliseconds(),
                RequestStutus = Resources.Resources.ResourceManager.GetString(((DocStatus)req.Status).ToString()),

                FirstName = req.Student.Person.FirstName,
                LastName = req.Student.Person.LastName,
                FathersName = req.Student.Person.FatherName,
                FirstCitizenShip = req.Student.Person.CitizenShips.FirstOrDefault(x => x.PersonId == req.Student.PersonId).Country.DisplayName,
                IdNo = req.Student.Person.CitizenShips.FirstOrDefault(x => x.PersonId == req.Student.PersonId).DocNo,
                CurrentLavel = Resources.Resources.ResourceManager.GetString(((Levels)(req.CurrentLevel == null ? (byte)Levels.UnKnown : req.CurrentLevel)).ToString()),
                LastLavel = Resources.Resources.ResourceManager.GetString(((Levels)lastLevel).ToString()),
                CandidateFields = candidateFields

            };
            return View(model);
        }

        public ActionResult AddStudentRequestInfo()
        {
            if (Session["lang"] == null || Session["UserInfo"] == null)
                return RedirectToAction("Index", "Account");
            _langCode = (string)Session["lang"];

            var langFields = _fieldForForeignService.FetchMany(w => w.LanguageCode == _langCode).OrderBy(o => o.Field_Name);
            ViewBag.FieldsForPHD = new SelectList(langFields.Where(w => w.FieldLevel == (byte)Levels.Phd), "Id", "Field_Name");
            ViewBag.FieldsForMaster = new SelectList(langFields.Where(w => w.FieldLevel == (byte)Levels.Master), "Id", "Field_Name");
            ViewBag.FieldsForBachelor = new SelectList(langFields.Where(w => w.FieldLevel == (byte)Levels.Bachelor), "Id", "Field_Name");
            ViewBag.FieldsForPreUniversity = new SelectList(langFields.Where(w => w.FieldLevel == (byte)Levels.PreUniversity), "Id", "Field_Name");
            ViewBag.FieldsForHighSchool = new SelectList(langFields.Where(w => w.FieldLevel == (byte)Levels.Diploma), "Id", "Field_Name");
            ViewBag.Colleges = new SelectList(new List<CollegeViewModel>(), "Id", "CollegeName");
            ViewBag.PhoneCodes = new SelectList(_countryService.FetchAll().Select(s => new SelectListItem { Value = s.PhoneCode.ToString(), Text = "(+" + s.PhoneCode + ") " + s.DisplayName }), "Value", "Text");
            ViewBag.CountryList = new SelectList(_countryService.FetchAll().OrderBy(o => o.Name), "Id", "DisplayName").ToList();


            var lstLevels = new SelectList(Helpers.GetEnumList<Levels>()
                .Where(w => w.Value != (int)Levels.Diploma && w.Value != (int)Levels.PreUniversity && w.Value != (int)Levels.Phd && w.Value != (int)Levels.UnKnown), "Value", "Key").ToList();
            ViewBag.Levels = lstLevels.Select(s => new SelectListItem
            {
                Value = s.Value,
                Text = Resources.Resources.ResourceManager.GetString(s.Text)
            }).ToList();


            return View();
        }

        [HttpPost]
        public string AddFamilyPerson()
        {
            var cList = _countryService.FetchAll().OrderBy(o => o.Name);
            var rList = Helpers.GetEnumList<RelationType>().Where(w => w.Value != 1 && w.Value != 9 && w.Value != 10 && w.Value != 11).ToList();

            var tr = "<tr><td><select class=\"form-control\"><option value=\"\">" + Resources.Resources.Dropdown_Choose + "</option>";
            for (int i = 0; i < rList.Count(); i++)
                tr += "<option value=\"" + rList[i].Value + "\">" + Resources.Resources.ResourceManager.GetString(rList[i].Key) + "</option>";
            tr += "</select></td><td><input type=\"text\" class=\"form-control txtFName\" /></td>";
            tr += "<td><input type=\"text\" class=\"form-control txtLName\" /></td><td><input type=\"text\" class=\"form-control txtFaName\" /></td><td><input type=\"text\" class=\"form-control txtGFaName\" /></td>";
            tr += "<td><input type=\"text\" class=\"form-control txtBDate dPicker\" /></td><td><select class=\"form-control ddlDocType\"><option value=\"-1\">" + Resources.Resources.Dropdown_Choose + "</option><option value=\"2\">" + Resources.Resources.Passport + "</option>";
            tr += "<option value=\"3\">" + Resources.Resources.RefugeeBooklet + "</option><option value=\"4\">" + Resources.Resources.IdentityCardOfForeignCitizens + "</option><option value=\"5\">" + Resources.Resources.LimitedTransitCard + "</option></select></td>";
            tr += "<td><input type=\"text\" class=\"form-control txtDocNo\" /></td><td><input type=\"text\" class=\"form-control txtJob\" /></td><td><select class=\"form-control\"><option value>" + Resources.Resources.Dropdown_Choose + "</option>";
            foreach (var item in cList)
                tr += "<option value=\"" + item.Id + "\">" + item.DisplayName + "</option>";
            tr += "</select></td></tr>";
            return tr;
        }

        [HttpPost]
        public JsonResult SearchField(string levelId, string collegeId, string searchText)
        {
            var res = new JsonResult();
            _langCode = (string)Session["lang"];
            if (string.IsNullOrEmpty(_langCode))
                _langCode = WebConfigurationManager.AppSettings["DefaultLang"];
            var cId = 0;
            var lId = 0;
            //var cList = !string.IsNullOrEmpty(collegeId) 
            //    && int.TryParse(collegeId, out cId) 
            //    && cId > 0
            //    && !string.IsNullOrEmpty(levelId)
            //    && int.TryParse(levelId, out lId)
            //    && lId > 0 ? _collegeService.FetchMany(w => w.Id == cId && w.FieldForForeigns.Where(ww=> ww.FieldLevel == lId).Count() > 0) : _collegeService.FetchAll();

            var cList = new List<College>();
            if (!string.IsNullOrEmpty(collegeId) && int.TryParse(collegeId, out cId) && cId > 0 && !string.IsNullOrEmpty(levelId) && int.TryParse(levelId, out lId) && lId > 0)
                cList = _collegeService.FetchMany(w => w.Id == cId && w.FieldForForeigns.Where(ww => ww.FieldLevel == lId).Count() > 0).ToList();
            else if (!string.IsNullOrEmpty(levelId) && int.TryParse(levelId, out lId) && lId > 0)
                cList = _collegeService.FetchMany(w => w.FieldForForeigns.Where(ww => ww.FieldLevel == lId).Count() > 0).ToList();
            else
                cList = _collegeService.FetchAll().ToList();


            var fList = cList.SelectMany(s => s.FieldForForeigns)
                .Where(w => w.LanguageCode == _langCode && (w.FieldLevel == lId || lId == 0) && (w.Field_Name.Contains(searchText) || string.IsNullOrEmpty(searchText)))
                .Select(s => new
                {
                    Id = s.Id,
                    Field_Name = s.Field_Name,
                    FieldLevel = Resources.Resources.ResourceManager.GetString(((Levels)s.FieldLevel).ToString()),
                    CollegeName = cList.FirstOrDefault(f => f.Id == s.CollegeId).CollegeName
                });
            if (fList != null && fList.Count() > 0)
            {
                string output = JsonConvert.SerializeObject(fList);
                res = new JsonResult { Data = new { Result = output, Message = string.Empty } };
            }
            else
            {
                res = new JsonResult { Data = new { Result = "", Message = Resources.Resources.No_Fields_Found } };
            }
            return res;
        }

        [HttpPost]
        public JsonResult AddNewStudentRequest(string data)
        {
            var res = new JsonResult();
            try
            {


                var dataObject = JObject.Parse(data);
                if (dataObject == null)
                {
                    res = new JsonResult { Data = new { Result = false, Message = Resources.Resources.Critical_Error } };
                    return res;
                }
                var account = _accountService.FindById(Convert.ToInt32(dataObject["userId"]));
                byte selectedLevel = 0;
                account.Student.Requests.Add(new Request
                {
                    Active = true,
                    CreateDate = DateTime.Now,
                    Status = (byte)RequestStatus.InfoAdded,
                    StudentId = account.StudentId,
                    CurrentLevel = !string.IsNullOrEmpty(dataObject["RequestedLevel"].ToString()) && byte.TryParse(dataObject["RequestedLevel"].ToString(), out selectedLevel) && selectedLevel > 0 ?
                                Convert.ToByte(dataObject["RequestedLevel"].ToString())
                                : (byte)Levels.Bachelor,

                    Term = WebConfigurationManager.AppSettings["Term"],
                });
                byte genderByte, marritalTypeByte, childrenCountByte, healthStatusByte, religionByte, mothersMarritalTypeByte, recommenderDocTypeByte, recommenederRelationType;
                DateTime parsedDate;

                Address existAddress = null;
                EducationDegree existEducationDegree = null;

                account.Student.Person.FirstName = dataObject["FirstName"].ToString();
                account.Student.Person.MiddleName = dataObject["MiddleName"].ToString();
                account.Student.Person.LastName = dataObject["LastName"].ToString();
                account.Student.Person.FatherName = dataObject["FatherName"].ToString();
                account.Student.Person.MotherName = dataObject["MotherName"].ToString();
                account.Student.Person.GrandFatherName = dataObject["GrandFatherName"].ToString();
                DateTime.TryParseExact(dataObject["BirthDate"].ToString(), "yyyy/MM/dd", new CultureInfo("en-GB"), DateTimeStyles.None, out parsedDate);
                account.Student.Person.BirthDate = parsedDate;
                account.Student.Person.BirthPlace = dataObject["BirthPlace"].ToString();
                account.Student.Person.Gender = !string.IsNullOrEmpty(dataObject["Gender"].ToString()) && byte.TryParse(dataObject["Gender"].ToString(), out genderByte) ? Convert.ToByte(dataObject["Gender"].ToString()) : Convert.ToByte(0);
                account.Student.Person.MarritalType = !string.IsNullOrEmpty(dataObject["MarritalType"].ToString()) && byte.TryParse(dataObject["MarritalType"].ToString(), out marritalTypeByte) ? Convert.ToByte(dataObject["MarritalType"].ToString()) : Convert.ToByte(0);

                account.Student.ChildrenCount = !string.IsNullOrEmpty(dataObject["ChildrenCount"].ToString()) && byte.TryParse(dataObject["ChildrenCount"].ToString(), out childrenCountByte) ? Convert.ToByte(dataObject["ChildrenCount"].ToString()) : Convert.ToByte(0);
                account.Student.HealthStatus = !string.IsNullOrEmpty(dataObject["HealthStatus"].ToString()) && byte.TryParse(dataObject["HealthStatus"].ToString(), out healthStatusByte) ? Convert.ToByte(dataObject["HealthStatus"].ToString()) : Convert.ToByte(0);
                account.Student.Religien = !string.IsNullOrEmpty(dataObject["Religion"].ToString()) && byte.TryParse(dataObject["Religion"].ToString(), out religionByte) ? Convert.ToByte(dataObject["Religion"].ToString()) : Convert.ToByte(0);

                account.Student.Person.CitizenShips.FirstOrDefault().CountryId = Convert.ToDecimal(dataObject["FirstCountryId"].ToString());
                account.Student.Person.CitizenShips.FirstOrDefault().DocNo = dataObject["DocNo"].ToString();

                if (dataObject["SecondCountryId"] != null && !string.IsNullOrEmpty(dataObject["SecondCountryId"].ToString()))
                {
                    account.Student.Person.CitizenShips.Add(new CitizenShip
                    {
                        CountryId = Convert.ToDecimal(dataObject["SecondCountryId"].ToString()),
                        Active = true
                    });
                }

                if (!string.IsNullOrEmpty(dataObject["IranHomeCity"].ToString()))
                {
                    existAddress = new Address();
                    existAddress.Active = true;
                    existAddress.AddressType = (byte)AddressType.IranResidenceAddress;
                    existAddress.City = dataObject["IranHomeCity"].ToString();//!string.IsNullOrEmpty(dataObject["IranHomeCity"].ToString()) ? Convert.ToDecimal(dataObject["IranHomeCity"].ToString()) : 0,
                    existAddress.PhoneNo = dataObject["IranHomePhone"].ToString();
                    existAddress.Plaque = dataObject["IranHomeNumber"].ToString();
                    existAddress.PostalCode = dataObject["IranHomePostalCode"].ToString();
                    existAddress.Province = dataObject["IranHomeState"].ToString();//!string.IsNullOrEmpty(dataObject["IranHomeState"].ToString()) ? Convert.ToDecimal(dataObject["IranHomeState"].ToString()) : 0,
                    existAddress.Street = dataObject["IranHomeStreet"].ToString();
                    existAddress.Email = dataObject["IranHomeEmail"].ToString();
                    existAddress.Mobile = dataObject["IranHomeMobile"].ToString();
                    existAddress.PreCodeForMobile = dataObject["IranHomeMobileCode"].ToString();
                    existAddress.PreCodeForPhoneNo = dataObject["IranHomePhoneCode"].ToString();
                    existAddress.PersonId = account.Student.PersonId;

                    account.Student.Person.Addresses.Add(existAddress);

                }
                if (!string.IsNullOrEmpty(dataObject["IranWorkCity"].ToString()))
                {
                    existAddress = new Address();
                    existAddress.Active = true;
                    existAddress.AddressType = (byte)AddressType.IranWorkPlaceAddress;
                    existAddress.City = dataObject["IranWorkCity"].ToString();//!string.IsNullOrEmpty(dataObject["IranWorkCity"].ToString()) ? Convert.ToDecimal(dataObject["IranWorkCity"].ToString()) : 0,
                    existAddress.PhoneNo = dataObject["IranWorkPhone"].ToString();
                    existAddress.Plaque = dataObject["IranWorkNumber"].ToString();
                    existAddress.PostalCode = dataObject["IranWorkPostalCode"].ToString();
                    existAddress.Province = dataObject["IranWorkState"].ToString();//!string.IsNullOrEmpty(dataObject["IranWorkState"].ToString()) ? Convert.ToDecimal(dataObject["IranWorkState"].ToString()) : 0,
                    existAddress.Street = dataObject["IranWorkStreet"].ToString();
                    existAddress.PersonId = account.Student.PersonId;

                    account.Student.Person.Addresses.Add(existAddress);
                }
                if (!string.IsNullOrEmpty(dataObject["CitizenshipHomeCity"].ToString()))
                {
                    existAddress = new Address();
                    existAddress.Active = true;
                    existAddress.AddressType = (byte)AddressType.CitizenshipResidenceAddress;
                    existAddress.City = dataObject["CitizenshipHomeCity"].ToString();//!string.IsNullOrEmpty(dataObject["CitizenshipHomeCity"].ToString()) ? Convert.ToDecimal(dataObject["CitizenshipHomeCity"].ToString()) : 0,
                    existAddress.PhoneNo = dataObject["CitizenshipHomePhone"].ToString();
                    existAddress.Plaque = dataObject["CitizenshipHomeNumber"].ToString();
                    existAddress.PostalCode = dataObject["CitizenshipHomePostalCode"].ToString();
                    existAddress.Province = dataObject["CitizenshipHomeState"].ToString();//!string.IsNullOrEmpty(dataObject["CitizenshipHomeState"].ToString()) ? Convert.ToDecimal(dataObject["CitizenshipHomeState"].ToString()) : 0,
                    existAddress.Street = dataObject["CitizenshipHomeStreet"].ToString();
                    existAddress.PersonId = account.Student.PersonId;
                    existAddress.Email = dataObject["CitizenshipHomeEmail"].ToString();
                    existAddress.Mobile = dataObject["CitizenshipHomeMobile"].ToString();
                    existAddress.PreCodeForMobile = dataObject["CitizenshipHomeMobileCode"].ToString();
                    existAddress.PreCodeForPhoneNo = dataObject["CitizenshipHomePhoneCode"].ToString();

                    account.Student.Person.Addresses.Add(existAddress);

                }
                if (!string.IsNullOrEmpty(dataObject["CitizenshipWorkCity"].ToString()))
                {
                    existAddress = new Address();
                    existAddress.Active = true;
                    existAddress.AddressType = (byte)AddressType.CitizenshipWorkPlaceAddress;
                    existAddress.City = dataObject["CitizenshipWorkCity"].ToString();//!string.IsNullOrEmpty(dataObject["CitizenshipWorkCity"].ToString()) ? Convert.ToDecimal(dataObject["CitizenshipWorkCity"].ToString()) : 0,
                    existAddress.PhoneNo = dataObject["CitizenshipWorkPhone"].ToString();
                    existAddress.Plaque = dataObject["CitizenshipWorkNumber"].ToString();
                    existAddress.PostalCode = dataObject["CitizenshipWorkPostalCode"].ToString();
                    existAddress.Province = dataObject["CitizenshipWorkState"].ToString();//!string.IsNullOrEmpty(dataObject["CitizenshipWorkState"].ToString()) ? Convert.ToDecimal(dataObject["CitizenshipWorkState"].ToString()) : 0,
                    existAddress.Street = dataObject["CitizenshipWorkStreet"].ToString();
                    existAddress.PersonId = account.Student.PersonId;

                    account.Student.Person.Addresses.Add(existAddress);

                }




                if (!string.IsNullOrEmpty(dataObject["DiplomaFieldTitle"].ToString()))
                {
                    existEducationDegree = new EducationDegree();
                    existEducationDegree.Active = true;
                    existEducationDegree.UniversityName = dataObject["DiplomaEducationDegreePlace"].ToString();
                    //existEducationDegree.FieldId = Convert.ToDecimal(dataObject["DiplomaFieldId"].ToString());
                    existEducationDegree.FieldTitle = dataObject["DiplomaFieldTitle"].ToString();
                    existEducationDegree.SudentId = account.Student.Id;
                    existEducationDegree.TotalAverage = decimal.Parse(dataObject["DiplomaTotalAverage"].ToString(), CultureInfo.InvariantCulture);
                    existEducationDegree.WrittenAverage = decimal.Parse(dataObject["DiplomaWrittenAverage"].ToString(), CultureInfo.InvariantCulture);
                    existEducationDegree.Level = (byte)Levels.Diploma;

                    account.Student.EducationDegrees.Add(existEducationDegree);
                }

                if (!string.IsNullOrEmpty(dataObject["PreuniversityTotalAverage"].ToString()))
                {
                    existEducationDegree = new EducationDegree();
                    existEducationDegree.Active = true;
                    existEducationDegree.SudentId = account.Student.Id;
                    existEducationDegree.TotalAverage = decimal.Parse(dataObject["PreuniversityTotalAverage"].ToString(), CultureInfo.InvariantCulture);// Convert.ToDecimal(dataObject["PreuniversityTotalAverage"].ToString());
                                                                                                                                                        //existEducationDegree.FieldId = Convert.ToDecimal(dataObject["PreuniversityFieldId"].ToString()),
                    existEducationDegree.FieldTitle = dataObject["PreuniversityFieldTitle"].ToString();
                    existEducationDegree.Level = (byte)Levels.PreUniversity;

                    account.Student.EducationDegrees.Add(existEducationDegree);
                }

                if (!string.IsNullOrEmpty(dataObject["BachelorFieldTitle"].ToString()))
                {
                    existEducationDegree = new EducationDegree();
                    existEducationDegree.Active = true;
                    //existEducationDegree.FieldId = Convert.ToDecimal(dataObject["BachelorFieldId"].ToString()),
                    existEducationDegree.FieldTitle = dataObject["BachelorFieldTitle"].ToString();
                    existEducationDegree.CountryName = dataObject["BachelorCountryName"].ToString();
                    existEducationDegree.UniversityName = dataObject["BachelorUniversityName"].ToString();
                    existEducationDegree.TotalAverage = decimal.Parse(dataObject["BachelorTotalAverage"].ToString(), CultureInfo.InvariantCulture);//Convert.ToDecimal(dataObject["BachelorTotalAverage"].ToString());
                    existEducationDegree.SudentId = account.Student.Id;
                    existEducationDegree.Level = (byte)Levels.Bachelor;

                    account.Student.EducationDegrees.Add(existEducationDegree);
                }

                if (!string.IsNullOrEmpty(dataObject["MAFieldTitle"].ToString()))
                {
                    existEducationDegree = new EducationDegree();
                    existEducationDegree.Active = true;
                    //existEducationDegree.FieldId = Convert.ToDecimal(dataObject["MAFieldId"].ToString());
                    existEducationDegree.FieldTitle = dataObject["MAFieldTitle"].ToString();
                    existEducationDegree.CountryName = dataObject["MACountryName"].ToString();
                    existEducationDegree.UniversityName = dataObject["MAUniversityName"].ToString();
                    existEducationDegree.TotalAverage = decimal.Parse(dataObject["MATotalAverage"].ToString(), CultureInfo.InvariantCulture);//Convert.ToDecimal(dataObject["MATotalAverage"].ToString());
                    existEducationDegree.SudentId = account.Student.Id;
                    existEducationDegree.Level = (byte)Levels.Master;

                    account.Student.EducationDegrees.Add(existEducationDegree);
                }

                if (!string.IsNullOrEmpty(dataObject["DoctorateFieldTitle"].ToString()))
                {
                    existEducationDegree = new EducationDegree();
                    existEducationDegree.Active = true;
                    //existEducationDegree.FieldId = Convert.ToDecimal(dataObject["DoctorateFieldId"].ToString());
                    existEducationDegree.FieldTitle = dataObject["DoctorateFieldTitle"].ToString();
                    existEducationDegree.CountryName = dataObject["DoctorateCountryName"].ToString();
                    existEducationDegree.UniversityName = dataObject["DoctorateUniversityName"].ToString();
                    existEducationDegree.TotalAverage = decimal.Parse(dataObject["DoctorateTotalAverage"].ToString(), CultureInfo.InvariantCulture); //Convert.ToDecimal(dataObject["DoctorateTotalAverage"].ToString());
                    existEducationDegree.SudentId = account.Student.Id;
                    existEducationDegree.Level = (byte)Levels.Phd;

                    account.Student.EducationDegrees.Add(existEducationDegree);

                }

                foreach (var f in dataObject["CondidateFields"].Children())
                {
                    account.Student.CandidateFields.Add(new CandidateField
                    {
                        Active = true,
                        FieldId = Convert.ToDecimal(f.ToString()),
                        StudentId = account.Student.Id
                    });
                }


                if (_accountService.UpdatetItem(account))
                {
                    /*-----------------------------------------------*/
                    var relatedPeople = new List<RelatedPerson>();//new List<KeyValuePair<decimal, byte>>();
                    var person = _personService.FindById(account.Student.Person.Id);
                    if (!string.IsNullOrEmpty(dataObject["MothersFirstName"].ToString()) && DateTime.TryParseExact(dataObject["MothersBirthDate"].ToString(), "yyyy/MM/dd", new CultureInfo("en-GB"), DateTimeStyles.None, out parsedDate))
                    {
                        var mother = new Person
                        {
                            Active = true,
                            BirthDate = parsedDate,
                            BirthPlace = dataObject["MothersBirthPlace"].ToString(),
                            FatherName = dataObject["MothersFatherName"].ToString(),
                            FirstName = dataObject["MothersFirstName"].ToString(),
                            Gender = (byte)Gender.Female,
                            GrandFatherName = dataObject["MothersGrandFatherName"].ToString(),
                            IdNo = dataObject["MothersIdNo"].ToString(),
                            IssuePlace = dataObject["MothersIssuePlace"].ToString(),
                            LastName = dataObject["MothersLastName"].ToString(),
                            NationalCode = dataObject["MothersNationalCode"].ToString(),
                            MarritalType = byte.TryParse(dataObject["MothersMarritalType"].ToString(), out mothersMarritalTypeByte) ? Convert.ToByte(dataObject["MothersMarritalType"].ToString()) : Convert.ToByte(0),
                            //RelatedPerson = new List<RelatedPerson> {
                            //    new RelatedPerson {
                            //        MainPersonId = account.Student.Person.Id,
                            //        RelationType = (byte)RelationType.مادر
                            //    }
                            //}
                        };
                        _personService.AddNewItem(mother);
                        relatedPeople.Add(new RelatedPerson
                        {
                            MainPersonId = account.Student.Person.Id,
                            MainPersonRelationType = (byte)RelationType.Mother,
                            RelatedPersonId = mother.Id,
                        });

                    }
                    //if (!string.IsNullOrEmpty(dataObject["RecommenderFirstName"].ToString()) && DateTime.TryParseExact(dataObject["RecommenderBirthDate"].ToString(), "yyyy/MM/dd", new CultureInfo("en-GB"), DateTimeStyles.None, out parsedDate))
                    if (!string.IsNullOrEmpty(dataObject["RecommenderCode"].ToString()))
                    {
                        //var rec = new List<CitizenShip>();
                        //rec.Add(new CitizenShip
                        //{
                        //    DocType = byte.TryParse(dataObject["RecommenderDocType"].ToString(), out recommenderDocTypeByte) ? Convert.ToByte(dataObject["RecommenderDocType"].ToString()) : Convert.ToByte(0),
                        //    CountryId = Convert.ToDecimal(dataObject["RecommenderCountryId"].ToString()),
                        //    DocNo = dataObject["RecommenderDocNo"].ToString(),
                        //    Active = true
                        //});
                        var recom = new Person
                        {
                            Active = true,
                            //BirthDate = parsedDate,
                            //FatherName = dataObject["RecommenderFatherName"].ToString(),
                            //FirstName = dataObject["RecommenderFirstName"].ToString(),
                            //GrandFatherName = dataObject["RecommenderGrandFatherName"].ToString(),
                            //LastName = dataObject["RecommenderLastName"].ToString(),
                            RecommenderCode = dataObject["RecommenderCode"].ToString(),
                            //CitizenShips = rec,
                            //Job = dataObject["RecommenderJob"].ToString(),
                            //Addresses = new List<Address> { new Address {
                            //    Mobile2 = dataObject["RecommenderMobile"].ToString()
                            //    , PreCodeForMobile = dataObject["RecommenderMobileCode"].ToString()
                            //    , Active = true
                            //} },

                        };
                        _personService.AddNewItem(recom);
                        relatedPeople.Add(new RelatedPerson
                        {
                            MainPersonId = account.Student.Person.Id,
                            MainPersonRelationType = (byte)RelationType.Recommender,
                            RelatedPersonId = recom.Id,
                            //RelatedPersonRelationType = byte.TryParse(dataObject["RecommenderRelationship"].ToString(), out recommenederRelationType) ? recommenederRelationType : Convert.ToByte(0)
                        });
                    }
                    foreach (var p in dataObject["RelatedPersons"].Children())
                    {
                        if (p["BirthDate"] != null && DateTime.TryParseExact(p["BirthDate"].ToString(), "yyyy/MM/dd", new CultureInfo("en-GB"), DateTimeStyles.None, out parsedDate))
                        {
                            var rel = new Person
                            {
                                Active = true,
                                BirthDate = parsedDate,
                                FatherName = p["FathersName"].ToString(),
                                FirstName = p["FirstName"].ToString(),
                                GrandFatherName = p["GrandFathersName"].ToString(),
                                LastName = p["LastName"].ToString(),
                                Job = p["Job"].ToString(),
                                CitizenShips = new List<CitizenShip> {
                                new CitizenShip {
                                    Active = true
                                    , CountryId = Convert.ToDecimal(p["Citizenship"].ToString())
                                    , DocNo = p["DocNo"].ToString()
                                    , DocType = Convert.ToByte(p["DocType"].ToString())
                                }
                            },
                                //RelatedPerson = new List<RelatedPerson> {
                                //    new RelatedPerson{
                                //        MainPersonId = account.Student.Person.Id,
                                //RelationType = (byte)RelationType.اعضای_خانواده,
                                //    }
                                //}
                            };
                            _personService.AddNewItem(rel);
                            relatedPeople.Add(new RelatedPerson
                            {
                                MainPersonId = account.Student.Person.Id,
                                MainPersonRelationType = (byte)RelationType.FamilyMember,
                                RelatedPersonId = rel.Id,
                                RelatedPersonRelationType = byte.TryParse(p["Relationship"].ToString(), out recommenederRelationType) ? recommenederRelationType : Convert.ToByte(0)
                            });
                        }
                    }

                    foreach (var item in relatedPeople)
                        _relatedPerson.AddNewItem(item);

                    //_personService.UpdatetItem(person);
                    /*-----------------------------------------------*/

                    Session["RequestId"] = account.Student.Requests.LastOrDefault().Id;
                    res = new JsonResult
                    {
                        Data = new
                        {
                            Result = true,
                            ReqId = account.Student.Requests.LastOrDefault().Id,
                            Message = string.Empty
                        }
                    };
                }
                else
                {
                    res = new JsonResult { Data = new { Result = false, Message = Resources.Resources.Critical_Error } };
                }

            }
            catch (Exception x)
            {
                System.IO.File.WriteAllText(Server.MapPath("~/debug.txt"), x.Message + Environment.NewLine + x.InnerException.Message + Environment.NewLine);
            }
            return res;
        }

        [HttpPost]
        public JsonResult GetCollegesByLevel(string data)
        {
            _langCode = (string)Session["lang"];
            System.Threading.Thread.CurrentThread.CurrentCulture = new CultureInfo(Session["Culture"].ToString());
            System.Threading.Thread.CurrentThread.CurrentUICulture = new CultureInfo(Session["Culture"].ToString());
            var options = string.Empty;
            if (!string.IsNullOrEmpty(data))
            {
                var requestLevel = Convert.ToByte(data);
                var res = _collegeService.FetchMany(w => w.LanguageCode == _langCode && w.FieldForForeigns.Where(ww => ww.FieldLevel == requestLevel).Count() > 0)
                    .OrderBy(o => o.CollegeName);
                ViewBag.Colleges = new SelectList(res, "Id", "CollegeName");

                options = "<option>" + Resources.Resources.Dropdown_Choose + "</option>";
                foreach (var item in res)
                    options += "<option value=\"" + item.Id + "\">" + item.CollegeName + "</option>";
            }
            else
                options = "<option>" + Resources.Resources.Dropdown_Choose + "</option>";
            return new JsonResult
            {
                Data = new
                {
                    HTML = options
                }
            };
        }
    }
}