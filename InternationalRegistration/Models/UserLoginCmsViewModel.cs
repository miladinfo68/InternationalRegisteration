using System.Collections.Generic;

namespace ISR.web.Models
{
    public class UserLoginCmsViewModel
    {
        public decimal UserId { get; set; }
        public string Username { get; set; }
        public string Password { get; set; }
        public string UserRoles { get; set; }//merged all role and seperated by ","
    }
}