using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Drawing.Imaging;
using System.Globalization;
using System.IO;
using System.Net;
using System.Net.Mail;
using System.Reflection;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Configuration;

namespace ISR.Commons
{
    public static class Helpers
    {
        public static string NormalizePersianDateFormat(string inputDate)
        {
            var parts = inputDate.Split('/');
            if (parts.Length == 3)
            {
                if (parts[0].Length == 2)
                    parts[0] = parts[0].StartsWith("9") ? (parts[0] = "13" + parts[0]) : (parts[0] = "14" + parts[0]);
                if (parts[1].Length == 1) parts[1] = "0" + parts[1];
                if (parts[2].Length == 1) parts[2] = "0" + parts[2];
                if (parts[0].Length == 4 && parts[1].Length == 2 && parts[2].Length == 2)
                    return parts[0] + "/" + parts[1] + "/" + parts[2];
            }
            return string.Empty;
        }

        //#################################

        public static byte[] ImageToByteArray(Image imageIn)
        {
            MemoryStream ms = new MemoryStream();
            imageIn.Save(ms, ImageFormat.Gif);
            return ms.ToArray();
        }
        public static byte[] ImageToByteArray(string filePath)
        {
            FileStream stream = new FileStream(filePath, FileMode.Open, FileAccess.Read);
            BinaryReader reader = new BinaryReader(stream);
            byte[] photo = reader.ReadBytes((int)stream.Length);
            reader.Close();
            stream.Close();
            return photo;
            }

        public static Image ByteArrayToImage(byte[] bytes)
        {
            MemoryStream ms = new MemoryStream(bytes);
            Image returnImage = Image.FromStream(ms);
            return returnImage;
        }

        public static string TimeStamp()
        {
            //return DateTime.UtcNow.ToString("yyyy-MM-dd HH:mm:ss.fff",CultureInfo.InvariantCulture);
            return DateTime.Now.Millisecond.ToString();
        }



        public static string RandomString(int size, bool lowerCase)
        {
            StringBuilder builder = new StringBuilder();
            Random random = new Random();
            char ch;
            for (int i = 0; i < size; i++)
            {
                ch = Convert.ToChar(Convert.ToInt32(Math.Floor(26 * random.NextDouble() + 65)));
                builder.Append(ch);
            }
            if (lowerCase)
                return builder.ToString().ToLower();
            return builder.ToString();
        }

        //#################################

        public static string Encrypt(this string PasswordPlainText)
        {
            string plainText = PasswordPlainText.Trim();
            string cipherText = "";                 // encrypted text
            string passPhrase = "Pas5pr@se";        // can be any string
            string initVector = "@1B2c3D4e5F6g7H8"; // must be 16 bytes
            EncryptionClass ThisKey = new EncryptionClass(passPhrase, initVector);
            cipherText = ThisKey.Encrypt(plainText);
            return cipherText;
        }

        public static string Decrypt(this string CipherText)
        {
            string plainText = "";
            string cipherText = CipherText;                 // encrypted text
            string passPhrase = "Pas5pr@se";        // can be any string
            string initVector = "@1B2c3D4e5F6g7H8"; // must be 16 bytes

            EncryptionClass ThisKey =
            new EncryptionClass(passPhrase, initVector);
            plainText = ThisKey.Decrypt(cipherText);

            return plainText;
        }

        //#################################
        public static List<T> ConvertDataTableToList<T>(this DataTable dt)
        {
            List<T> data = new List<T>();
            foreach (DataRow row in dt.Rows)
            {
                T item = GetItem<T>(row);
                data.Add(item);
            }
            return data;
        }
        public static T GetItem<T>(DataRow dr)
        {
            Type temp = typeof(T);
            T obj = Activator.CreateInstance<T>();

            foreach (DataColumn column in dr.Table.Columns)
            {
                foreach (PropertyInfo pro in temp.GetProperties())
                {
                    if (pro.Name == column.ColumnName && dr[column.ColumnName] != DBNull.Value && dr[column.ColumnName] != null)
                        pro.SetValue(obj, dr[column.ColumnName], null);
                    else
                        continue;
                }
            }
            return obj;
        }
        //#################################

        public static DataTable ConvertListToDataTable<T>(IList<T> data)
        {
            PropertyDescriptorCollection properties = TypeDescriptor.GetProperties(typeof(T));
            DataTable table = new DataTable();
            foreach (PropertyDescriptor prop in properties)
                table.Columns.Add(prop.Name, Nullable.GetUnderlyingType(prop.PropertyType) ?? prop.PropertyType);
            foreach (T item in data)
            {
                DataRow row = table.NewRow();
                foreach (PropertyDescriptor prop in properties)
                    row[prop.Name] = prop.GetValue(item) ?? DBNull.Value;
                table.Rows.Add(row);
            }
            return table;
        }
        //#################################

        public static bool SendEmail(string strTo, string strSubject, string strBody, string dir = "rtl")
        {
            string Username = "noreply";
            string Password = "A*_*rohani";
            string SmtpServer = "mail.iauec.ac.ir";

            string From = Username + "@iauec.ac.ir";
            string s_html = "<html><div style='direction: " + dir + "; font-family:Tahoma'>";
            string e_html = "</div></html>";
            try
            {
                SmtpClient s = new SmtpClient(SmtpServer);
                s.Port = 25;
                s.Credentials = new NetworkCredential(From, Password);
                s.DeliveryMethod = SmtpDeliveryMethod.Network;
                s.UseDefaultCredentials = true;
                s.EnableSsl = false;

                MailMessage m = new MailMessage(From, strTo);
                m.IsBodyHtml = true;
                m.Subject = strSubject;

                m.Body = s_html + strBody + e_html;

                s.Send(m);

                return true;
            }
            catch (Exception ex)
            {
                return false;
            }
        }

        public static string GregorianToJalali(this DateTime date)
        {
            PersianCalendar pc = new PersianCalendar();
            return pc.GetYear(date) + "/" + pc.GetMonth(date) + "/" + pc.GetDayOfMonth(date);
        }

        public static string GetDefaultCulturOfLanguage(string lang)
        {
            switch (lang)
            {
                case "fa":
                    return "fa-IR";
                case "en":
                    return "en-GB";
                case "ar":
                    return "ar-IQ";
                default:
                    return WebConfigurationManager.AppSettings["DefaultCulture"];
            }
        }
        public static string CreateMD5(string input)
        {
            using (System.Security.Cryptography.MD5 md5 = System.Security.Cryptography.MD5.Create())
            {
                byte[] inputBytes = System.Text.Encoding.ASCII.GetBytes(input);
                byte[] hashBytes = md5.ComputeHash(inputBytes);

                StringBuilder sb = new StringBuilder();
                for (int i = 0; i < hashBytes.Length; i++)
                {
                    sb.Append(hashBytes[i].ToString("X2"));
                }
                return sb.ToString();
            }
        }
        public static List<KeyValuePair<string, int>> GetEnumList<T>()
        {
            var list = new List<KeyValuePair<string, int>>();
            foreach (var e in Enum.GetValues(typeof(T)))
            {
                list.Add(new KeyValuePair<string, int>(e.ToString(), Convert.ToInt32(e)));
            }
            return list;
        }

        public static bool IsNumeric(string str)
        {
            string regexNumber = @"^([\d]+)$";
            return new Regex(regexNumber).IsMatch(str);
        }

       
        /// convert arabic letters to persian
        /// </summary>
        /// <param name="strInput"></param>
        /// <returns></returns>
        public static string ToPersianLetters(this string arabicString)
        {
            string res = "";
            string arabicStr = arabicString.Trim();
            if (arabicStr.Length > 0)
            {
                res = arabicStr.Replace("ك", "ک");
                res = res.Replace("ئ", "ی");
                res = res.Replace("ي", "ی");
                //res = res.Replace("آ", "ا");
                res = res.Replace("أ", "ا");
                res = res.Replace("إ", "ا");
                res = res.Replace("ۀ", "ه");
                res = res.Replace("ة", "ه");
                res = res.Replace("ؤ", "و");
                //----------------------------------
                res = res.Replace("دِ", "د");
                res = res.Replace("بِ", "ب");
                res = res.Replace("زِ", "ز");
                res = res.Replace("ذِ", "ذ");
                res = res.Replace("شِ", "ش");
                res = res.Replace("سِ", "س");
                //----------------------------------
                res = res.Replace("۱", "١");
                res = res.Replace("۲", "٢");
                res = res.Replace("۳", "٣");
                res = res.Replace("۴", "٤");
                res = res.Replace("۵", "٥");
                res = res.Replace("۶", "٦");
                res = res.Replace("۷", "٧");
                res = res.Replace("۸", "٨");
                res = res.Replace("۹", "٩");
                res = res.Replace("۰", "٠");
            }
            return res;
        }

    }
}
