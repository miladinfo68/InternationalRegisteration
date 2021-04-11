using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http;
using System.Web.Mvc;
using System.Web.Routing;
using ISR.Services;
using ISR.Repository;
using Autofac;
using Autofac.Integration.Mvc;
using ISR.DAL.Amozesh_Initial;
using System.Web.Configuration;
using ISR.Commons;
using System.Globalization;
using System.Threading;

namespace InternationalRegistration
{
    public class MvcApplication : System.Web.HttpApplication
    {
        protected void Application_AcquireRequestState(object sender, EventArgs e)
        {
            HttpContextBase currentContext = new HttpContextWrapper(HttpContext.Current);
            RouteData routeData = RouteTable.Routes.GetRouteData(currentContext);
            if (routeData.Values["lang"] == null)
            {
                if (Session["Culture"] == null)
                {
                    Session["Culture"] = WebConfigurationManager.AppSettings["DefaultCulture"];
                    Session["lang"] = WebConfigurationManager.AppSettings["DefaultLang"];
                    System.Threading.Thread.CurrentThread.CurrentCulture = new System.Globalization.CultureInfo(WebConfigurationManager.AppSettings["DefaultCulture"]);
                    System.Threading.Thread.CurrentThread.CurrentUICulture = new System.Globalization.CultureInfo(WebConfigurationManager.AppSettings["DefaultCulture"]);
                }
                else
                {
                    System.Threading.Thread.CurrentThread.CurrentCulture = new System.Globalization.CultureInfo(Session["Culture"].ToString());
                    System.Threading.Thread.CurrentThread.CurrentUICulture = new System.Globalization.CultureInfo(Session["Culture"].ToString());
                }
                //Response.Redirect(string.Format("{0}://{1}", Request.Url.Scheme, Request.Url.Authority) + "/" + Session["lang"] + Request.Url.AbsolutePath);
            }
            else if (Session["Culture"] == null
               || Session["lang"] == null
                || !Session["Culture"].ToString().Substring(0, 2).Equals(routeData.Values["lang"])
                || !Session["lang"].ToString().Equals(routeData.Values["lang"]))
            {
                var cul = Helpers.GetDefaultCulturOfLanguage(routeData.Values["lang"].ToString());
                Session["Culture"] = cul;
                Session["lang"] = routeData.Values["lang"].ToString();
                System.Threading.Thread.CurrentThread.CurrentCulture = new System.Globalization.CultureInfo(Session["Culture"].ToString());
                System.Threading.Thread.CurrentThread.CurrentUICulture = new System.Globalization.CultureInfo(Session["Culture"].ToString());
            }
            else if (Session["Culture"].ToString() != System.Threading.Thread.CurrentThread.CurrentCulture.Name)
            {
                System.Threading.Thread.CurrentThread.CurrentCulture = new System.Globalization.CultureInfo(Session["Culture"].ToString());
                System.Threading.Thread.CurrentThread.CurrentUICulture = new System.Globalization.CultureInfo(Session["Culture"].ToString());
            }

            //if (HttpContext.Current.Request.RequestContext.RouteData.Values.ContainsKey("lang"))
            //{
            //    var lang = (string)HttpContext.Current.Request.RequestContext.RouteData.Values["lang"] ?? "en";                        

            //    Thread.CurrentThread.CurrentCulture = new CultureInfo(lang);
            //    Thread.CurrentThread.CurrentUICulture = new CultureInfo(lang);
            //}
        }

        protected void Application_Start()
        {
            AreaRegistration.RegisterAllAreas();
            RouteConfig.RegisterRoutes(RouteTable.Routes);

            var builder = new ContainerBuilder();
            var config = GlobalConfiguration.Configuration;
            builder.RegisterControllers(typeof(MvcApplication).Assembly);

            builder.Register(reg => new PersonService()).As<IPersonService>().InstancePerRequest();
            builder.Register(reg => new StudentService()).As<IStudentService>().InstancePerRequest();
            builder.Register(reg => new StudentDocService()).As<IStudentDocService>().InstancePerRequest();
            builder.Register(reg => new StudentDocTypeService()).As<IStudentDocTypeService>().InstancePerRequest();
            builder.Register(reg => new FieldForForeignService()).As<IFieldForForeignService>().InstancePerRequest();
            builder.Register(reg => new EducationDegreeService()).As<IEducationDegreeService>().InstancePerRequest();
            builder.Register(reg => new CountryService()).As<ICountryService>().InstancePerRequest();
            builder.Register(reg => new RequestService()).As<IRequestService>().InstancePerRequest();
            builder.Register(reg => new CandidateFieldService()).As<ICandidateFieldService>().InstancePerRequest();
            builder.Register(reg => new AddressService()).As<IAddressService>().InstancePerRequest();
            builder.Register(reg => new CitizenShipService()).As<ICitizenShipService>().InstancePerRequest();
            builder.Register(reg => new AccountService()).As<IAccountService>().InstancePerRequest();
            builder.Register(reg => new CollegeService()).As<ICollegeService>().InstancePerRequest();
            builder.Register(reg => new RelatedPersonService()).As<IRelatedPersonService>().InstancePerRequest();
            builder.Register(reg => new NewStudentService()).As<INewStudentService>().InstancePerRequest();
            builder.Register(reg => new SidaFieldService()).As<ISidaFieldService>().InstancePerRequest();
            //===========
            builder.Register(reg => new UserService()).As<IUserService>().InstancePerRequest();
            builder.Register(reg => new UserLogService()).As<IUserLogService>().InstancePerRequest();
            builder.Register(reg => new UserLogTypeService()).As<IUserLogTypeService>().InstancePerRequest();

            builder.Register(reg => new UserService()).As<IUserService>().InstancePerRequest();
            builder.Register(reg => new RoleService()).As<IRoleService>().InstancePerRequest();
            builder.Register(reg => new UserAccessService()).As<IUserAccessService>().InstancePerRequest();
            builder.Register(reg => new UserRoleService()).As<IUserRoleService>().InstancePerRequest();


            var container = builder.Build();
            DependencyResolver.SetResolver(new AutofacDependencyResolver(container));
        }
    }
}
