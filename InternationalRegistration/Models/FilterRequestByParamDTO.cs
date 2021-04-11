using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ISR.web.Models
{
    public class FilterRequestByParamDTO
    {
        public string ReqStatus { get; set; }
        public string Term { get; set; }
        public string RequestID { get; set; }
        public string Filter { get; set; }

    }
}