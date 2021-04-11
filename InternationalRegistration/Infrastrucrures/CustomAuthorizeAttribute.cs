using System;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;
using ISR.Commons.enums;
using ISR.DAL;
using ISR.Services;
using ISR.web.Models;

namespace ISR.Infrastrucrures
{
    public class CustomAuthorizeAttribute : AuthorizeAttribute
    {
        //private readonly string[] allowedroles;    
        //public CustomAuthorizeAttribute(params string[] roles)
        //{
        //    this.allowedroles = roles;
        //}
        private readonly IUserRoleService _userRoleService;
        private readonly IUserService _userService;
        private readonly IRoleService _roleService;
        private readonly IUserAccessService _userAccessService;
        public CustomAuthorizeAttribute()
        {
            _userRoleService = _userRoleService ?? new UserRoleService();
            _userService = _userService ?? new UserService();
            _roleService = _roleService ?? new RoleService();
            _userAccessService = _userAccessService ?? new UserAccessService();
        }
        //=================================
        protected override bool AuthorizeCore(HttpContextBase httpContext)
        {
            //bool authorize = false;
            httpContext.Session["HasAnyRole"] = false;
            if (httpContext.Session["UserCmsInfo"] != null && !string.IsNullOrEmpty((httpContext.Session["UserCmsInfo"] as UserLoginCmsViewModel).UserId.ToString()))
            {               
                var uId = (httpContext.Session["UserCmsInfo"] as UserLoginCmsViewModel).UserId;
                var rawUrl = httpContext.Request.RawUrl.Trim().ToLower();
                var currentUserAccesses = (from ur in _userRoleService.FetchAll()
                                           join u in _userService.FetchAll() on ur.UserId equals u.Id
                                           join r in _roleService.FetchAll() on ur.RoleId equals r.Id
                                           join ac in _userAccessService.FetchAll() on r.Id equals ac.RoleId into tempAccess
                                           from t in tempAccess.DefaultIfEmpty()
                                           where ur.UserId == uId
                                           select new
                                           {
                                               Url = t != null ? $"/{t.ControllerName}/{t.ActionName}" : null,                                              
                                               RoleId = ur.RoleId
                                           }).Distinct().ToList();

                if (currentUserAccesses.Count() > 0)
                {
                    var currentUserRoles = currentUserAccesses.Select(s => s.RoleId).Distinct().ToList();
                    var strUserRoles = string.Join(",", currentUserRoles).Trim();
                    if (!string.IsNullOrEmpty(strUserRoles))
                    {
                        if (strUserRoles.Contains(RoleIds.Admin))
                        {
                            httpContext.Session["HasAnyRole"] = true;
                            return (bool)httpContext.Session["HasAnyRole"];
                        }
                        else
                        {
                            if (!string.IsNullOrEmpty(rawUrl))
                            {
                                var allUrls = currentUserAccesses.Where(w=>!string.IsNullOrEmpty(w.Url)).Select(s => s.Url.ToLower()).Distinct().ToList();
                                foreach (var url in allUrls)
                                {
                                    if (rawUrl.Contains(url))
                                    {
                                        httpContext.Session["HasAnyRole"] = true;
                                        return (bool)httpContext.Session["HasAnyRole"];
                                    }
                                }
                            }
                        }
                    }
                }
            }

            return (bool)httpContext.Session["HasAnyRole"];
        }
        //=================================
        protected override void HandleUnauthorizedRequest(AuthorizationContext filterContext)
        {

            if (filterContext.HttpContext.Session["HasAnyRole"] != null && (bool)filterContext.HttpContext.Session["HasAnyRole"])
            {
                //redirect to requested view (return propitious view)
                base.HandleUnauthorizedRequest(filterContext);
            }
            else
            {
                //calling access denied page
                filterContext.HttpContext.Session["HasAnyRole"] = null;
                filterContext.Result = new RedirectToRouteResult(new RouteValueDictionary(new { lang = "fa", controller = "Error", action = "AccessDeny" }));
            }
        }

    }
}