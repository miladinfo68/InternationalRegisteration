using System.Web;
using System.Web.Mvc;
using System.Linq;
using System.Collections.Generic;
using System;
using System.Web.Configuration;
using ISR.Services;
using ISR.Commons;
using ISR.DAL.Amozesh_Initial;
using ISR.Commons.enums;
using ISR.web.Models;

namespace ISR.web.Controllers
{
    public class DocumentsController : Controller
    {
        private readonly IStudentDocService studentDocSVC;
        private readonly IEducationDegreeService educationDegreeSVC;
        private readonly IRequestService requestSVC;
        private readonly ICountryService countrySVC;
        private readonly ICitizenShipService citizenShipSVC;
        private readonly IFieldForForeignService fieldsSVC;
        private readonly IAccountService accountSVC;

        //base model for docs
        string basePath = "st_documents";
        string term = WebConfigurationManager.AppSettings["Term"];
        byte docStatus = (byte)DocStatus.InProgress;
        byte Karshenas_UpdateDocStatus = (byte)DocStatus.Accepted;


        bool active = true;

        public DocumentsController(IStudentDocService studentDocsService
            , IEducationDegreeService educationDegreeService
            , IRequestService requestService
            , ICitizenShipService citizenShipService
            , IFieldForForeignService fieldService
            , ICountryService countryService
            , IAccountService accountService
            , IStudentDocService studentDocService)
        {
            studentDocSVC = studentDocsService;
            educationDegreeSVC = educationDegreeService;
            requestSVC = requestService;
            citizenShipSVC = citizenShipService;
            fieldsSVC = fieldService;
            countrySVC = countryService;
            accountSVC = accountService;
            studentDocSVC = studentDocService;
        }

        public ActionResult Index()
        {
            return View();
        }

        [HttpGet]
        public ActionResult UploadDocuments()
        {

            Session["lang"] = WebConfigurationManager.AppSettings["DefaultLang"];
            if (Session["UserInfo"] == null || Session["RequestId"] == null)
                return RedirectToRoute("Default", new { lang = Session["lang"], controller = "Account", action = "Index" });

            var req = requestSVC.FindById(decimal.Parse(Session["RequestId"].ToString()));
            ViewBag.St_Request = req;
            ViewBag.St_LastLevel = req.Student?.EducationDegrees?.OrderByDescending(ord => ord.Level).FirstOrDefault();


            //var accountId = 5;//(Session["UserInfo"] as Models.UserViewModel).Id;
            TempData["studentID"] = req.StudentId; //accountSVC.FindById(accountId).StudentId;

            //var countries = new SelectList(countrySVC.FetchAll().OrderBy(o => o.Name), "Id", "DisplayName").ToList();
            //countries.Insert(0, new SelectListItem { Text = Resources.Dropdown_Choose, Value = "0" });
            //ViewBag.CountryList = countries;

            //var fields = new SelectList(fieldsSVC.FetchAll().OrderBy(o => o.Field_Name), "Id", "Field_Name").ToList();
            //fields.Insert(0, new SelectListItem { Text = Resources.Dropdown_Choose, Value = "0" });
            //ViewBag.AllFields = fields;

            var docs = studentDocSVC.FetchMany(doc => doc.SudentId == req.StudentId).ToList();

            var docPersonalPicture = docs.FirstOrDefault(doc => doc.FileName.Contains(DocumentsMangement.PersonalPicture));
            ViewBag.vbPersonalPicture = docPersonalPicture == null ? "#" : docPersonalPicture.Path + "/" + docPersonalPicture.FileName + "?ts=" + Helpers.TimeStamp();


            var docPassport = docs.FirstOrDefault(doc => doc.FileName.Contains(DocumentsMangement.Passport));
            ViewBag.vbPassport = docPassport == null ? "#" : docPassport.Path + "/" + docPassport.FileName + "?ts=" + Helpers.TimeStamp();

            var docDiploma = docs.FirstOrDefault(doc => doc.FileName.Contains(DocumentsMangement.Diploma));
            ViewBag.vbDiploma = docDiploma == null ? "#" : docDiploma.Path + "/" + docDiploma.FileName + "?ts=" + Helpers.TimeStamp();

            var docCollage = docs.FirstOrDefault(doc => doc.FileName.Contains(DocumentsMangement.Collage));
            ViewBag.vbCollage = docCollage == null ? "#" : docCollage.Path + "/" + docCollage.FileName + "?ts=" + Helpers.TimeStamp();

            var docBachelor = docs.FirstOrDefault(doc => doc.FileName.Contains(DocumentsMangement.Bachelor));
            ViewBag.vbBachelor = docBachelor == null ? "#" : docBachelor.Path + "/" + docBachelor.FileName + "?ts=" + Helpers.TimeStamp();

            var docMaster = docs.FirstOrDefault(doc => doc.FileName.Contains(DocumentsMangement.Master));
            ViewBag.vbMaster = docMaster == null ? "#" : docMaster.Path + "/" + docMaster.FileName + "?ts=" + Helpers.TimeStamp();

            var docPhd = docs.FirstOrDefault(doc => doc.FileName.Contains(DocumentsMangement.Phd));
            ViewBag.vbPhd = docPhd == null ? "#" : docPhd.Path + "/" + docPhd.FileName + "?ts=" + Helpers.TimeStamp();


            return View();
        }


        //private bool formDataIsValid()
        private bool formDataIsValid(HttpPostedFileBase personalPicture, HttpPostedFileBase passport, HttpPostedFileBase diploma, HttpPostedFileBase collage, HttpPostedFileBase bachelor, HttpPostedFileBase master, HttpPostedFileBase phd, string lastEducationDegree = "0", string curentLevel = "0")
        {
            bool res = true;
            string errMessages = "";
            var stID = (TempData["studentID"] as decimal?);
            var docs = studentDocSVC.FetchMany(doc => doc.SudentId == stID && doc.Term == this.term);

            if (docs.Count() == 0)
            {
                if (lastEducationDegree == "0")
                {
                    errMessages += Resources.Resources.ValidationMessage_LastEducationDegree;//"آخرین مدرک تحصیلی انتخاب نشده است";
                    errMessages += "#";
                    res = false;
                }

                if (curentLevel == "0")
                {
                    errMessages += Resources.Resources.ValidationMessage_CurrentLevel;//" مقطع جاری انتخاب نشده است";
                    errMessages += "#";
                    res = false;
                }

                if (personalPicture == null)
                {
                    errMessages += Resources.Resources.ValidationMessage_PersonalPictureDocIsRequired; //" بارگذاری مدرک عکس پرسنلی الزامی می باشد";
                    errMessages += "#";
                    res = false;
                }


                if (passport == null)
                {
                    errMessages += Resources.Resources.ValidationMessage_PassportDocIsRequired; //" بارگذاری گذرنامه الزامی می باشد";
                    errMessages += "#";
                    res = false;
                }

                switch (curentLevel)
                {
                    case "1"://Diploma
                    case "2"://collage --> pish daneshgahi
                    case "3"://bachelor --> lisence
                        if (diploma == null)
                        {
                            errMessages += Resources.Resources.ValidationMessage_DiplomaDocIsRequired; //" بارگذاری مدرک دیپلم برای مقطع انتخابی الزامی می باشد";
                            errMessages += "#";
                            res = false;
                        }
                        break;

                    case "4"://master
                        if (bachelor == null)
                        {
                            errMessages += Resources.Resources.ValidationMessage_BachelorDocIsRequired; //" بارگذاری مدرک کارشناسی برای مقطع انتخابی الزامی می باشد";
                            errMessages += "#";
                            res = false;
                        }
                        break;

                    case "5"://phd
                        if (master == null)
                        {
                            errMessages += Resources.Resources.ValidationMessage_MasterDocIsRequired; ; //" بارگذاری مدرک کارشناسی ارشد برای مقطع انتخابی الزامی می باشد";
                            res = false;
                        }
                        break;
                }

            }
            else
            {
                if (docs.Count() < 3)
                {
                    if (lastEducationDegree == "0")
                    {
                        errMessages += Resources.Resources.ValidationMessage_LastEducationDegree;//"آخرین مدرک تحصیلی انتخاب نشده است";
                        errMessages += "#";
                        res = false;
                    }

                    if (curentLevel == "0")
                    {
                        errMessages += Resources.Resources.ValidationMessage_CurrentLevel;//" مقطع جاری انتخاب نشده است";
                        errMessages += "#";
                        res = false;
                    }

                    if ((!docs.Any(doc => doc.FileName.Split('.')[0].ToLower() == DocumentsMangement.PersonalPicture.ToLower()) && personalPicture == null))
                    {
                        errMessages += Resources.Resources.ValidationMessage_PersonalPictureDocIsRequired; //" بارگذاری مدرک عکس پرسنلی الزامی می باشد";
                        errMessages += "#";
                        res = false;
                    }


                    if ((!docs.Any(doc => doc.FileName.Split('.')[0].ToLower() == DocumentsMangement.Passport.ToLower()) && passport == null))
                    {
                        errMessages += Resources.Resources.ValidationMessage_PassportDocIsRequired; //" بارگذاری گذرنامه الزامی می باشد";
                        errMessages += "#";
                        res = false;
                    }

                    //!(Array.IndexOf(new List<String>() { "1", "2", "3", "4", "5" }.ToArray(), lastEducationDegree) > -1)


                    switch (curentLevel)
                    {
                        case "1"://Diploma
                        case "2"://collage --> pish daneshgahi
                        case "3"://bachelor --> lisence
                            if (!docs.Any(doc => doc.FileName.Contains(DocumentsMangement.Diploma)) && diploma == null)
                            {
                                errMessages += Resources.Resources.ValidationMessage_DiplomaDocIsRequired; //" بارگذاری مدرک دیپلم برای مقطع انتخابی الزامی می باشد";
                                errMessages += "#";
                                res = false;
                            }
                            break;

                        case "4"://master
                            if (!docs.Any(doc => doc.FileName.Contains(DocumentsMangement.Bachelor)) && bachelor == null)
                            {
                                errMessages += Resources.Resources.ValidationMessage_BachelorDocIsRequired; //" بارگذاری مدرک کارشناسی برای مقطع انتخابی الزامی می باشد";
                                errMessages += "#";
                                res = false;
                            }
                            break;

                        case "5"://phd
                            if (!docs.Any(doc => doc.FileName.Contains(DocumentsMangement.Master)) && master == null)
                            {
                                errMessages += Resources.Resources.ValidationMessage_MasterDocIsRequired; ; //" بارگذاری مدرک کارشناسی ارشد برای مقطع انتخابی الزامی می باشد";
                                res = false;
                            }
                            break;
                    }
                }
            }



            TempData["ErrMessages"] = errMessages;
            //ViewBag.ErrMessages = errMessages;
            return res ? true : false;
        }


        [HttpPost]
        //public ActionResult UploadDocuments(HttpPostedFileBase Passport_f, HttpPostedFileBase Diploma_f, HttpPostedFileBase Collage_f, HttpPostedFileBase Bachelor_f, HttpPostedFileBase Master_f, HttpPostedFileBase Phd_f, string txt_LastEducationDegree = "0", string txt_AllFields = "0", string txt_LastEducationAverage = "0", string txt_LastEducationDate = "0", string txt_CountryList = "0", string txt_CurentLevel = "0", string txt_Candidate_Fields = "0")
        public ActionResult UploadDocuments(HttpPostedFileBase PersonalPicture_f, HttpPostedFileBase Passport_f, HttpPostedFileBase Diploma_f, HttpPostedFileBase Collage_f, HttpPostedFileBase Bachelor_f, HttpPostedFileBase Master_f, HttpPostedFileBase Phd_f, string txt_LastEducationDegree = "0", string txt_CurentLevel = "0")
        {
            var validation = formDataIsValid(PersonalPicture_f, Passport_f, Diploma_f, Collage_f, Bachelor_f, Master_f, Phd_f, txt_LastEducationDegree, txt_CurentLevel);
            if (!validation)
            {
                //return View("UploadDocuments");
                return RedirectToAction("UploadDocuments");
            }
            var studentID = (TempData["studentID"] as decimal?);
            if (studentID.HasValue)
            {

                StudentDoc doc = null;
                var path = $"~/{basePath}/{term}/{studentID.Value}";

                if (PersonalPicture_f != null)
                {
                    //save image on server
                    var res = DocumentsMangement.SaveInputStreamAsImage(PersonalPicture_f, path, DocumentsMangement.PersonalPicture);
                    if (res)
                    {
                        var fileName = $"PersonalPicture.{PersonalPicture_f.FileName.Split('.')[1].ToLower()}";
                        doc = this.SetDocumentModelByParams(studentID.Value, fileName, (byte)DocType.PersonalPicture, docStatus, term, active);
                        //save doc info in database
                        var x = studentDocSVC.AddNewItem(doc);
                    }
                }


                if (Passport_f != null)
                {
                    //save image on server
                    var res = DocumentsMangement.SaveInputStreamAsImage(Passport_f, path, DocumentsMangement.Passport);
                    if (res)
                    {
                        var fileName = $"Passport.{Passport_f.FileName.Split('.')[1].ToLower()}";
                        doc = this.SetDocumentModelByParams(studentID.Value, fileName, (byte)DocType.Passport, docStatus, term, active);
                        //save doc info in database
                        var x = studentDocSVC.AddNewItem(doc);
                    }
                }

                if (Diploma_f != null)
                {
                    var res = DocumentsMangement.SaveInputStreamAsImage(Diploma_f, path, DocumentsMangement.Diploma);
                    if (res)
                    {
                        var fileName = $"Diploma.{Diploma_f.FileName.Split('.')[1].ToLower()}";
                        doc = this.SetDocumentModelByParams(studentID.Value, fileName, (byte)DocType.Diploma, docStatus, term, active);
                        //save doc info in database
                        var x = studentDocSVC.AddNewItem(doc);
                    }
                }

                if (Collage_f != null)
                {
                    var res = DocumentsMangement.SaveInputStreamAsImage(Collage_f, path, DocumentsMangement.Collage);
                    if (res)
                    {
                        var fileName = $"Collage.{Collage_f.FileName.Split('.')[1].ToLower()}";
                        doc = this.SetDocumentModelByParams(studentID.Value, fileName, (byte)DocType.Collage, docStatus, term, active);
                        //save doc info in database
                        var x = studentDocSVC.AddNewItem(doc);
                    }
                }

                if (Bachelor_f != null)
                {
                    var res = DocumentsMangement.SaveInputStreamAsImage(Bachelor_f, path, DocumentsMangement.Bachelor);
                    if (res)
                    {
                        var fileName = $"Bachelor.{Bachelor_f.FileName.Split('.')[1].ToLower()}";
                        doc = this.SetDocumentModelByParams(studentID.Value, fileName, (byte)DocType.Bachelor, docStatus, term, active);
                        //save doc info in database
                        var x = studentDocSVC.AddNewItem(doc);
                    }
                }

                if (Master_f != null)
                {
                    var res = DocumentsMangement.SaveInputStreamAsImage(Master_f, path, DocumentsMangement.Master);
                    if (res)
                    {
                        var fileName = $"Master.{Master_f.FileName.Split('.')[1].ToLower()}";
                        doc = this.SetDocumentModelByParams(studentID.Value, fileName, (byte)DocType.Master, docStatus, term, active);
                        //save doc info in database
                        var x = studentDocSVC.AddNewItem(doc);
                    }
                }

                if (Phd_f != null)
                {
                    var res = DocumentsMangement.SaveInputStreamAsImage(Phd_f, path, DocumentsMangement.Phd);
                    if (res)
                    {
                        var fileName = $"Phd.{Phd_f.FileName.Split('.')[1].ToLower()}";
                        doc = this.SetDocumentModelByParams(studentID.Value, fileName, (byte)DocType.Phd, docStatus, term, active);
                        //save doc info in database
                        var x = studentDocSVC.AddNewItem(doc);
                    }
                }

            }
            UpdateDocStatus_InRequestTable(txt_CurentLevel, txt_LastEducationDegree);
            return RedirectToAction("Index", "Request");
            //return View("UploadDocuments");
        }


        //[HttpPost]
        //public ActionResult ReUploadDocument(HttpPostedFileBase fileUploader, string hdn_redid = "-1", string hdn_doc_id = "-1")
        //{
        //    var reqId = decimal.Parse(string.IsNullOrEmpty(hdn_redid) ? "-1" : hdn_redid);
        //    var docId = decimal.Parse(string.IsNullOrEmpty(hdn_doc_id) ? "-1" : hdn_doc_id);
        //    if (docId != -1 && reqId != -1)
        //    {
        //        var docItem = studentDocSVC.FindById(docId);
        //        if (docItem != null)
        //        {
        //            var path = $"~/{basePath}/{term}/{docItem.Student.Id}";
        //            if (fileUploader != null)
        //            {
        //                var docName = GetDocName((byte)docItem.Category);
        //                if (docName != "")
        //                {
        //                    var res = DocumentsMangement.SaveInputStreamAsImage(fileUploader, path, DocumentsMangement.PersonalPicture);
        //                    if (res)
        //                    {
        //                        var fileName = $"{docName}.{fileUploader.FileName.Split('.')[1].ToLower()}";

        //                        docItem.FileName = fileName;
        //                        docItem.DocStatus = updateDocStatus;
        //                        docItem.Description = "";

        //                        var x = studentDocSVC.UpdatetItem(docItem);
        //                    }
        //                }
        //            }
        //        }
        //        return RedirectToAction("ShowDetails", "Request", new { @lang = Session["lang"], @id = reqId });
        //    }
        //    return RedirectToAction("Index", "Request", new { @lang = Session["lang"] });
        //}



        [HttpPost]
        //public JsonResult ReUploadDocument(FormCollection formCollection)
        public JsonResult ReUploadDocument()
        {
            var form = HttpContext.Request.Form;
            var hdn_reqid = form["hdn_reqid"];
            var hdn_doc_id = form["hdn_doc_id"];
            var hdn_detector = form["hdn_detector"];
            //var reqId = decimal.Parse(string.IsNullOrEmpty(formCollection["hdn_reqid"]) ? "-1" : formCollection["hdn_reqid"]);
            //var docId = decimal.Parse(string.IsNullOrEmpty(formCollection["hdn_doc_id"]) ? "-1" : formCollection["hdn_doc_id"]);
            //var checker = string.IsNullOrEmpty(formCollection["hdn_detector"]) ? "-1" : formCollection["hdn_detector"];

            var reqId = decimal.Parse(string.IsNullOrEmpty(hdn_reqid) ? "-1" : hdn_reqid );
            var docId = decimal.Parse(string.IsNullOrEmpty(hdn_doc_id) ? "-1" : hdn_doc_id );
            var checker = string.IsNullOrEmpty(hdn_detector) ? "-1" : hdn_detector ;
            JsonResult res;
            if (docId != -1 && reqId != -1 && checker != "-1")
            {
                var docItem = studentDocSVC.FindById(docId);
                if (docItem != null)
                {
                    var path = $"~/{basePath}/{term}/{docItem.Student.Id}";
                    var PostedFiles = Request.Files;
                    if (PostedFiles.Count > 0)
                    {
                        var docName = GetDocName((byte)docItem.Category);
                        if (docName != "")
                        {
                            var x = DocumentsMangement.SaveInputStreamAsImage(PostedFiles[0], path, docName);
                            if (x)
                            {
                                var fileName = $"{docName}.{PostedFiles[0].FileName.Split('.')[1].ToLower()}";

                                docItem.FileName = fileName;
                                docItem.DocStatus = checker == "k" ? Karshenas_UpdateDocStatus : docStatus;
                                docItem.Path = path.Replace("~/", "../../../");
                                docItem.Description = "";

                                var xx = studentDocSVC.UpdatetItem(docItem);
                                res = new JsonResult { Data = new { Result = true, Messege = Request.Files.Count } };
                                return res;
                            }
                        }
                    }
                }
            }
            res = new JsonResult { Data = new { Result = false, Messege = "Invalid request !!!" } };
            return res;

            /*
            for (int i = 0; i < Request.Files.Count; i++)
            {
                HttpPostedFileBase file = Request.Files[i]; //Uploaded file
                //Use the following properties to get file's name, size and MIMEType
                int fileSize = file.ContentLength;
                string fileName = file.FileName;
                string mimeType = file.ContentType;
                System.IO.Stream fileContent = file.InputStream;
                //To save file, use SaveAs method
                var path = "~/st_documents/97-98-2/22/";
                file.SaveAs(Server.MapPath(path) + fileName); //File will be saved in application root
            }
            var res = new JsonResult { Data = new { Result = true, Messege = Request.Files.Count } };
            return res;
            */
        }








        string GetDocName(byte cat)
        {
            var res = "";
            switch (cat)
            {
                case (byte)DocType.PersonalPicture: res = DocumentsMangement.PersonalPicture; break;
                case (byte)DocType.Passport: res = DocumentsMangement.Passport; break;
                case (byte)DocType.RefugeeBooklet: res = DocumentsMangement.Passport; break;
                case (byte)DocType.IdentityCardOfForeignCitizens: res = DocumentsMangement.Passport; break;
                case (byte)DocType.LimitedTransitCard: res = DocumentsMangement.Passport; break;
                case (byte)DocType.Diploma: res = DocumentsMangement.Diploma; break;
                case (byte)DocType.Collage: res = DocumentsMangement.Collage; break;
                case (byte)DocType.Bachelor: res = DocumentsMangement.Bachelor; break;
                case (byte)DocType.Master: res = DocumentsMangement.Master; break;
                case (byte)DocType.Phd: res = DocumentsMangement.Phd; break;
                default:
                    break;
            }
            return res;
        }

        private StudentDoc SetDocumentModelByParams(decimal studentId, string fileName, byte catagory, byte docStaus, string term, bool active)
        {
            var setDoc = new StudentDoc();
            var path = $"../../../{basePath}/{term}/{studentId}";

            setDoc.SudentId = studentId;
            setDoc.FileName = fileName;
            setDoc.Path = path;
            setDoc.Category = catagory;
            setDoc.DocStatus = docStaus;
            setDoc.Term = term;
            setDoc.Active = active;
            return setDoc;
        }


        private List<Country> GetAllCountries()
        {
            var countries = countrySVC.FetchAll().ToList();
            return countries;
        }

        private void UpdateDocStatus_InRequestTable(string askedLevel, string lastLevelEducation)
        {
            if (Session["RequestId"] != null)
            {
                var reqId = decimal.Parse(Session["RequestId"].ToString());
                var request = requestSVC.FindById(reqId);
                if (request != null)
                {
                    var eudcationeDegree = educationDegreeSVC.FetchMany(s => s.SudentId == request.StudentId).OrderByDescending(ord=>ord.Level).FirstOrDefault();
                    if (eudcationeDegree != null)
                    {
                        eudcationeDegree.Level = Convert.ToByte(askedLevel);
                        //eudcationeDegree.EndTimeInLevel = string.IsNullOrEmpty(txt_LastEducationDate) ? DateTime.Now : Convert.ToDateTime(txt_LastEducationDate);
                        //eudcationeDegree.CountryId = decimal.Parse(txt_CountryID);
                        var xx = educationDegreeSVC.UpdatetItem(eudcationeDegree);
                    }
                    request.Status = (int)RequestStatus.DocsUploaded;
                    //request.CurrentLevel = byte.Parse(lastLevelEducation);
                    requestSVC.UpdatetItem(request);
                }
            }
        }




        [HttpPost]
        public JsonResult ResultMessage(string msgType = "")
        {
            JsonResult res = null;
            switch (msgType)
            {
                case "SizeOfFileIsInvalid_ErrorTitle":
                    res = new JsonResult();
                    res.Data = new MessageHandler()
                    {
                        MsgTilte = Resources.Resources.SizeOfFileIsInvalid_ErrorTitle,
                        MsgBody = Resources.Resources.SizeOfFileIsInvalid_ErrorBody
                    };
                    break;
                //-------------

                case "FileFormatIsInvalid_ErrorTitle":
                    res = new JsonResult();
                    res.Data = new MessageHandler()
                    {
                        MsgTilte = Resources.Resources.FileFormatIsInvalid_ErrorTitle,
                        MsgBody = Resources.Resources.FileFormatIsInvalid_ErrorBody
                    };
                    break;
                //-------------
                case "FormValidation_ErrorTitle":
                    res = new JsonResult();
                    res.Data = new MessageHandler()
                    {
                        MsgTilte = Resources.Resources.FormValidation_ErrorTitle,
                        MsgBody = Resources.Resources.FormValidation_ErrorBody
                    };
                    break;
                //-------------
                case "ListOfLevels":
                    res = new JsonResult();
                    res.Data = new MessageHandler()
                    {
                        MsgTilte = "",
                        MsgBody = Resources.Resources.ListOfLevels
                    };
                    break;
                //-------------
                default: break;

            }
            return res;
        }


    }


}