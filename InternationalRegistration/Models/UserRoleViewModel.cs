using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ISR.web.Models
{
    public class UserRoleViewModel
    {
        public UserViewModel User { get; set; }
        //public List<RoleViewModel> AssignedRoles { get; set; }
        public List<RoleViewModel> Roles { get; set; }
    }
}