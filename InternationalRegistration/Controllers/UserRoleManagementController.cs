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
    //[CustomAuthorize(RoleIds.Admin)]
    [CustomAuthorize]
    public class UserRoleManagementController : Controller
    {

        private readonly IUserService _userService;
        private readonly IRoleService _roleService;
        private readonly IUserAccessService _userAccessService;
        private readonly IUserRoleService _userRoleService;
        private readonly string currentTerm = WebConfigurationManager.AppSettings["Term"];

        public UserRoleManagementController(IUserService userService, IRoleService roleService, IUserAccessService userAccessService, IUserRoleService userRoleService)
        {
            _userService = userService;
            _roleService = roleService;
            _userAccessService = userAccessService;
            _userRoleService = userRoleService;
        }
        //@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        List<UserViewModel> GetUsers(int id = 0)
        {
            List<UserViewModel> users = new List<UserViewModel>();
            if (id > 0)
            {
                var model = _userService.FindById(id);
                users[0].Username = model.Username;
                users[0].DisplayName = model.DisplayName;
                users[0].Password = Helpers.Decrypt(model.Password.Trim());
                users[0].Id = model.Id;
            }
            else
            {
                users = (from u in _userService.FetchAll()
                         select new UserViewModel
                         {
                             Id = u.Id,
                             Username = u.Username,
                             DisplayName=u.DisplayName ,
                             Password = Helpers.Decrypt(u.Password.Trim())
                         }).ToList();
            }
            return users;
        }
        //@@@@@@@@@@@@@@@@@@@@@@@@@@@@

        [HttpGet]
        public ActionResult Index(int id = 0)
        {
            var users = GetUsers(id);
            ViewBag.Roles = GetRoles();
            ViewBag.UserRoles = GetUserRoles();
            return View(users);
        }

        //@@@@@@@@@@@@@@@@@@@@@@@@@@@@

        [HttpGet]
        public ActionResult ResetPasswordUser(int id = 0)
        {
            if (id > 0)
            {
                var user = _userService.FindById(id);
                if (user != null)
                {
                    user.Password = null;
                    _userService.UpdatetItem(user);
                }
            }
            return RedirectToAction("Users", "UserRoleManagement", new { @id = 0 });
        }

        //@@@@@@@@@@@@@@@@@@@@@@@@@@@@

        [HttpPost]
        public JsonResult GetUserInfo(int id = 0)
        {
            UserViewModel data = null;
            if (id > 0)
            {
                var user = _userService.FindById(id);
                if (user != null)
                {
                    data = new UserViewModel();
                    data.Username = user.Username;
                    data.DisplayName = user.DisplayName;
                    data.Password = Helpers.Decrypt(user.Password);
                    data.Id = user.Id;
                }
            }
            return new JsonResult { Data = new { Result = data, Message = "OK" } };
        }

        //@@@@@@@@@@@@@@@@@@@@@@@@@@@@

        [HttpPost]
        public PartialViewResult CRUD_User(string id = "0", string username = "", string displayname = "", string password = "", string actionType = "")
        {
            if (!string.IsNullOrEmpty(actionType))
            {
                switch (actionType)
                {
                    case "1": //add
                        if (string.IsNullOrEmpty(id))
                        {
                            var hashPass = Helpers.Encrypt(password.Trim());
                            var user = _userService.FindOne(x => x.Username == username.Trim());
                            if (user == null)
                            {
                                var objectUser = new User();
                                objectUser.Username = username.Trim();
                                objectUser.DisplayName = displayname;
                                objectUser.Password = Helpers.Encrypt(password.Trim());
                                objectUser.Active = true;
                                _userService.AddNewItem(objectUser);
                            }
                        }
                        break;

                    case "2"://edit
                        if (!string.IsNullOrEmpty(id) && string.Compare(id, "0") > 0)
                        {
                            var user = _userService.FindById(decimal.Parse(id));
                            if (user != null)
                            {
                                user.Username = username.Trim();
                                user.DisplayName = displayname;
                                user.Password = Helpers.Encrypt(password.Trim());
                                _userService.UpdatetItem(user);
                            }
                        }
                        break;

                    case "3"://delete
                        if (!string.IsNullOrEmpty(id) && string.Compare(id, "0") > 0)
                        {
                            //delete records from related table User_Role
                            var usrId = decimal.Parse(id);
                            var userRoles = _userRoleService.FetchMany(m => m.UserId == usrId);
                            if (userRoles != null && userRoles.Count() > 0)
                            {
                                foreach (var ur in userRoles)
                                {
                                    _userRoleService.RemoveItem(ur);
                                }
                            }

                            var user = _userService.FindById(usrId);
                            if (user != null)
                            {
                                _userService.RemoveItem(user);
                            }
                        }
                        break;

                    case "4"://reset Password
                        if (!string.IsNullOrEmpty(id) && string.Compare(id, "0") > 0)
                        {
                            var user = _userService.FindById(decimal.Parse(id));
                            if (user != null)
                            {
                                user.Password = Helpers.Encrypt(string.Empty);
                                _userService.UpdatetItem(user);
                            }
                        }
                        break;
                }
            }
            return PartialView("_Users", GetUsers());
        }

        //@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        //@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        //@@@@@@@@@@@@@@@@@@@@@@@@@@@@


        List<RoleViewModel> GetRoles(int id = 0)
        {
            List<RoleViewModel> roles = new List<RoleViewModel>();
            if (id > 0)
            {
                var model = _roleService.FindById(id);

                roles[0].RoleId = model.Id;
                roles[0].RoleName = model.RoleName;
                roles[0].DisplayName = model.DisplayName;
                roles[0].Active = model.Active;
            }
            else
            {
                roles = (from r in _roleService.FetchAll()
                         select new RoleViewModel
                         {
                             RoleId = r.Id,
                             RoleName = r.RoleName,
                             DisplayName = r.DisplayName,
                             Active = r.Active
                         }).ToList();
            }
            return roles;
        }
        //======================================

        [HttpPost]
        public PartialViewResult CRUD_Role(string id = "0", string rolename = "" ,string displayname="", bool active = true, string actionType = "")
        {
            if (!string.IsNullOrEmpty(actionType))
            {
                switch (actionType)
                {
                    case "5": //add role
                        if (string.IsNullOrEmpty(id))
                        {
                            var user = _roleService.FindOne(x => x.RoleName == rolename.Trim());
                            if (user == null)
                            {
                                var objectRole = new Role();
                                objectRole.RoleName = rolename.Trim();
                                objectRole.DisplayName= displayname.Trim();
                                objectRole.Active = active;
                                _roleService.AddNewItem(objectRole);
                            }
                        }
                        break;

                    case "6"://edit role
                        if (!string.IsNullOrEmpty(id) && string.Compare(id, "0") > 0)
                        {
                            var role = _roleService.FindById(decimal.Parse(id));
                            if (role != null)
                            {
                                role.RoleName = rolename.Trim();
                                role.DisplayName = displayname.Trim();
                                role.Active = active;
                                _roleService.UpdatetItem(role);
                            }
                        }
                        break;

                    case "7"://delete role
                        if (!string.IsNullOrEmpty(id) && string.Compare(id, "0") > 0)
                        {                           
                            var role = _roleService.FindById(decimal.Parse(id));
                            if (role != null)
                            {
                                _roleService.RemoveItem(role);
                            }
                        }
                        break;


                }
            }
            return PartialView("_Roles", GetRoles());
        }


        [HttpPost]
        public JsonResult GetRoleInfo(int id = 0)
        {
            RoleViewModel data = null;
            if (id > 0)
            {
                var role = _roleService.FindById(id);
                if (role != null)
                {
                    data = new RoleViewModel();
                    data.RoleId = role.Id;
                    data.RoleName = role.RoleName;
                    data.DisplayName = role.DisplayName;
                    data.Active = role.Active;
                }
            }
            return new JsonResult { Data = new { Result = data, Message = "OK" } };
        }

        //@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        //@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        //@@@@@@@@@@@@@@@@@@@@@@@@@@@@


        List<UserRoleViewModel> GetUserRoles(int id = 0) //id==userId
        {
            var allUsers = _userService.FetchAll();
            var allRoles = _roleService.FetchAll().Select(s => new Role
            {
                Id = s.Id,
                RoleName = s.RoleName,
                DisplayName = s.DisplayName,
                Active = false
            });
            var userRoles = _userRoleService.FetchAll();



            List<UserRoleViewModel> userList = new List<UserRoleViewModel>();

            foreach (var user in allUsers)
            {

                var userAsignedRoles = (from ur in userRoles.AsEnumerable()
                                        join r in allRoles.AsEnumerable() on ur.RoleId equals r.Id
                                        //join u in allUsers.AsEnumerable() on ur.UserId equals u.Id
                                        where ur.UserId == user.Id
                                        select new
                                        {
                                            RoleId = r.Id,
                                            //UserId = u.Id,
                                            RoleName = r.RoleName,
                                            DisplayName = r.DisplayName,
                                            Active = true
                                        }).ToList();


                var model = new UserRoleViewModel
                {
                    User = new UserViewModel
                    {
                        Id = user.Id,
                        Username = user.Username,
                        DisplayName = user.DisplayName,
                        Active = user.Active == true ? true : false
                    }
                };

                var refactorAllRoles = (from rr in allRoles
                                        join ar in userAsignedRoles on rr.Id equals ar.RoleId into temp
                                        from t in temp.DefaultIfEmpty()
                                        select new RoleViewModel
                                        {
                                            RoleId = rr.Id,
                                            RoleName = rr.RoleName,
                                            DisplayName = rr.DisplayName,
                                            IsCkecked = (t != null && t.Active) ? "checked" : ""
                                        }).ToList();

                model.Roles = refactorAllRoles;
                userList.Add(model);

            }
            return userList;
        }

        //@@@@@@@@@@@@@@@@@@@@@@@@@@@@


        [HttpPost]
        public JsonResult AddOrUpdateRoles(string userId = "", string rolesList = "")
        {
            if (!string.IsNullOrEmpty(userId) && !string.IsNullOrEmpty(rolesList))
            {
                var uId = decimal.Parse(userId);
                var userRoles = _userRoleService.FetchMany(m => m.UserId == uId);
                if (userRoles !=null && userRoles.Count()>0)
                {
                    foreach (var ur in userRoles)
                    {
                        _userRoleService.RemoveItem(ur);
                    }
                }

               var roleIds = rolesList.Split(',');
                foreach (var roleId in roleIds)
                {
                    if (!string.IsNullOrEmpty(roleId))
                    {
                        var rId = decimal.Parse(roleId);
                        var userRole = _userRoleService.FindOne(ur => ur.UserId == uId && ur.RoleId == rId);
                        if (userRole == null)
                        {
                            _userRoleService.AddNewItem(new User_Role
                            {
                                UserId = uId,
                                RoleId=rId
                            });
                        }
                    }                    
                }
            }
            return new JsonResult { Data = new { Result = true, Message = "Refresh Page" } };
        }


    }
}