using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;

namespace ISR.Commons
{
    public static class DocumentsMangement
    {
        public static string PersonalPicture => "PersonalPicture";
        public static string Passport => "Passport";
        public static string Diploma => "Diploma";
        public static string Collage => "Collage";
        public static string Bachelor => "Bachelor";
        public static string Master => "Master";
        public static string Phd => "Phd";




        //#################################
        //save file on server
        public static bool SaveInputStreamAsImage(HttpPostedFileBase file, string path = "", string postedFile = "")
        {
            string serverPath = System.Web.Hosting.HostingEnvironment.MapPath(path);

            var result = true;
            var fileName = "";
            var ext = "";

            try
            {
                if (file.ContentLength > 0)
                {
                    ext = file.FileName.Split('.')[1].ToLower();

                    if (!Directory.Exists(serverPath))
                        Directory.CreateDirectory(serverPath);
                    switch (postedFile)
                    {
                        case "PersonalPicture":
                            fileName = $"{serverPath}/{PersonalPicture}.{ext}";
                            if (File.Exists(fileName))
                                File.Delete(fileName);

                            file.SaveAs(fileName);
                            break;

                        case "Passport":
                            fileName = $"{serverPath}/{Passport}.{ext}";
                            if (File.Exists(fileName))
                                File.Delete(fileName);

                            file.SaveAs(fileName);
                            break;

                        case "Diploma":
                            fileName = $"{serverPath}/{Diploma}.{ext}";
                            if (File.Exists(fileName))
                                File.Delete(fileName);

                            file.SaveAs(fileName);
                            break;

                        case "Collage":
                            fileName = $"{serverPath}/{Collage}.{ext}";
                            if (File.Exists(fileName))
                                File.Delete(fileName);

                            file.SaveAs(fileName);
                            break;

                        case "Bachelor":
                            fileName = $"{serverPath}/{Bachelor}.{ext}";
                            if (File.Exists(fileName))
                                File.Delete(fileName);

                            file.SaveAs(fileName);
                            break;

                        case "Master":
                            fileName = $"{serverPath}/{Master}.{ext}";
                            if (File.Exists(fileName))
                                File.Delete(fileName);

                            file.SaveAs(fileName);
                            break;

                        case "Phd":
                            fileName = $"{serverPath}/{Phd}.{ext}";
                            if (File.Exists(fileName))
                                File.Delete(fileName);
                            file.SaveAs(fileName);
                            break;

                        default:
                            break;
                    }
                }
                else
                    result = false;

            }
            catch (Exception x)
            {
                result = false;
                //throw;
            }
            return result;
        }



    }


}
