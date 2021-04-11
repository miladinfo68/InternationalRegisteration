using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace ISR.web.Controllers
{
    public class ErrorController : Controller
    {
        // GET: AccessDeny
        public ActionResult AccessDeny()
        {
            return View();
        }

        [HttpPost]
        public JsonResult Logout()
        {
            Session["UserCmsInfo"] = null;
            return new JsonResult { Data = new { Result = true } };
        }
    }
}