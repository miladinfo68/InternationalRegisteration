using System.Web;

namespace ISR.web.Models
{
    public class StudentDocsViewModel
    {
        public HttpPostedFileBase PassportFile { get; set; }
        public HttpPostedFileBase DiplomaFile { get; set; }
        public HttpPostedFileBase CollageFile { get; set; }
        public HttpPostedFileBase BachelorFile { get; set; }
        public HttpPostedFileBase MasterFile { get; set; }
        public HttpPostedFileBase PhdFile { get; set; }

    }
}