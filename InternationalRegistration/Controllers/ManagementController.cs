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
    //[CustomAuthorize(RoleIds.Admin, RoleIds.ISR_Manager, RoleIds.Enrollment_Manager, RoleIds.ISR_Expert)]
    [CustomAuthorize]
    public class ManagementController : Controller
    {       
        public ActionResult Index()
        {        
            return View();
        }
    }
}