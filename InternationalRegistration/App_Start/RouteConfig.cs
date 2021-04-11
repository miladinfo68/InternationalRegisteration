using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.Mvc;
using System.Web.Routing;

namespace InternationalRegistration
{
    public class RouteConfig
    {
        public static void RegisterRoutes(RouteCollection routes)
        {
            routes.IgnoreRoute("{resource}.axd/{*pathInfo}");

            routes.MapRoute(
                name: "WithLanguage",
                url: "{lang}/{controller}/{action}/{id}",
                defaults: new { lang = WebConfigurationManager.AppSettings["DefaultLang"], controller = "Account", action = "Index", id = UrlParameter.Optional },
                constraints: new { lang = "fa|en|ar" }
            );
            routes.MapRoute(
               name: "Default",
               url: "{controller}/{action}/{id}",
               defaults: new { controller = "Account", action = "Index", id = UrlParameter.Optional }
           );
        }
    }
}
