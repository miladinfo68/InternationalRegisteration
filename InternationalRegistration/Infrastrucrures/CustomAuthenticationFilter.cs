using ISR.web.Models;
using System;
using System.Web.Mvc;
using System.Web.Mvc.Filters;
using System.Web.Routing;

namespace ISR.Infrastrucrures
{
    public class CustomAuthenticationFilter : ActionFilterAttribute, IAuthenticationFilter
    {
        public void OnAuthentication(AuthenticationContext filterContext)
        {
            if (filterContext.HttpContext.Session["UserCmsInfo"] == null)
            {
                filterContext.Result = new HttpUnauthorizedResult();
            }
        }
        public void OnAuthenticationChallenge(AuthenticationChallengeContext filterContext)
        {
            if (filterContext.Result is HttpUnauthorizedResult)
            {
                //Redirecting the user to the Login View of Account Controller                  
                filterContext.Result = new RedirectToRouteResult(new RouteValueDictionary(new {lang = "fa" , controller = "Account", action = "LoginCMS" }));                
            }
        }
    }
}