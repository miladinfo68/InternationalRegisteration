using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ISR.web.Models
{
    public class RoleViewModel
    {
        public decimal RoleId { get; set; }
        public string RoleName { get; set; }
        public string DisplayName { get; set; }
        public bool? Active { get; set; }

        public string IsCkecked { get; set; }
    }
}