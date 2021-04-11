using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.Threading.Tasks;
using Dapper;
using ISR.DAL.Amozesh_Initial;
using ISR.Models;
using ISR.Repository.Interfaces;

namespace ISR.Repository
{
    public class MapperSidaAndInitialRegisterationRepository : IMapperSidaAndInitialRegisterationRepository<InsertToSida, ISR.Models.NewStudentVM>
    //public class MapperSidaAndInitialRegisterationRepository : IMapperSidaAndInitialRegisterationRepository<InsertToSida>
    {
        //private string InitialConnectionString = "Server=192.168.4.40;Database=InitialRegistration;User Id=reg_user;Password=reg*user;";
        private string InitialConnectionString = "Server=192.168.1.8;Database=InitialRegistration;User Id=ireg_user;Password=(!reg_User!);";

        string RollbackTranferedNewStudentInfoToSida(SqlConnection con, string stcode = null, decimal studentId = -1, string currenterm = "" ,decimal requestId=-1)
        {
            var res = con.QueryFirstOrDefault<string>("[International].[stp_RollbackTranferedNewStudentInfoToSida]", new
            {
                stcode = stcode,
                studentId = studentId,
                currenterm = currenterm,
                requestId= requestId
            }, commandType: CommandType.StoredProcedure);
            return res;
        }
        public string InsertInToSida(InsertToSida model)
        {
            var result = "";
            try
            {
                using (var con = new SqlConnection(InitialConnectionString))
                {
                    var res1 = con.QueryFirstOrDefault<string>("[International].[stp_InsertIntoSida]", new
                    {
                        requestId=model.requestId ,
                        term = model.term,
                        currenterm = model.currenterm,
                        stcode = model.stcode,
                        studentId = model.studentId,
                        name = model.name,
                        family = model.family,
                        namep = model.namep,
                        idd_meli = model.idd_meli,
                        sex = model.sex,
                        magh = model.magh,
                        idreshSazman = model.idreshSazman,
                        sal_vorod = model.sal_vorod,
                        nimsal_vorod = model.nimsal_vorod,
                        date_tav = model.date_tav,
                        tahol = model.tahol,
                        radif_gh = model.radif_gh,
                        rotbeh_gh = model.rotbeh_gh,
                        nomreh_gh = model.nomreh_gh,
                        tarikhmohlat = model.tarikhmohlat,
                        userId = model.userId,
                        end_madrak = model.end_madrak,
                        university = model.university,
                        date_endmadrak = model.date_endmadrak,
                        resh_endmadrak = model.resh_endmadrak,
                        mahal_tav = model.mahal_tav,
                        mahal_sodor = model.mahal_sodor,
                        meliat = model.meliat,
                        jesm = model.jesm,
                        sahmeh = model.sahmeh,
                        addressd = model.addressd,
                        tel = model.tel,
                        mobile = model.mobile,
                        code_posti = model.code_posti,
                        email = model.email,
                        ip = model.ip,
                        fsf2_date_endMadrak = model.date_endmadrak,
                        fsf2_din = model.fsf2_din,
                        fsf2_nezam = model.fsf2_nezam,
                        fsf2_radif_gh = model.fsf2_radif_gh,
                        fsf2_rotbeh_gh = model.fsf2_rotbeh_gh,
                        fsf2_nomreh_gh = model.fsf2_nomreh_gh,
                        fsf2_addressd = model.fsf2_addressd,
                        fsf2_email = model.fsf2_email,
                        fsf2_code_posti = model.fsf2_code_posti,
                        fsf2_local1 = model.fsf2_local1,
                        fsf2_Ostan = model.fsf2_Ostan,
                        fsf2_Shahrestan = model.fsf2_Shahrestan,

                        //doc images
                        personalImage = model.personalImage,
                        citizenshipImage = model.citizenshipDocImage,
                        educationDegreeImage = model.baseEducationlImage,

                    }, commandType: CommandType.StoredProcedure);

                    if (res1 != "success")
                    {
                        //rollback
                        var res11 = this.RollbackTranferedNewStudentInfoToSida(con, model.stcode, model.studentId, model.currenterm,model.requestId);
                    }

                }
            }
            catch (Exception ex)
            {
                using (var con = new SqlConnection(InitialConnectionString))
                {
                    var res22 = this.RollbackTranferedNewStudentInfoToSida(con, model.stcode, model.studentId, model.currenterm, model.requestId);
                }
                //throw ex;
            }
            return result;
        }

        public string InsertInToNewStudent(List<ISR.Models.NewStudentVM> items)
        //public string InsertInToNewStudent(DataTable items)
        {
            var res = "";
            try
            {
                using (var con = new SqlConnection(InitialConnectionString))
                {
                    var dt = ISR.Commons.Helpers.ConvertListToDataTable<ISR.Models.NewStudentVM>(items);
                    res = con.ExecuteScalar<string>("[International].[SP_Insert_into_NewStudent]",
                    new
                    {
                        stList = dt.AsTableValuedParameter("dbo.StudentType")
                        //stList = items.AsTableValuedParameter("dbo.StudentType")

                    }, commandType: CommandType.StoredProcedure);
                }
            }
            catch (Exception xx)
            {
                throw xx;
            }
            return res;
        }

        //@@@@@@@@@@@@@@@@@@@@@@@@

        //string RollbackTranferedNewStudentInfoToSida2(SqlConnection con, SqlCommand cmd, InsertToSida model)
        //{
        //    var res = "";
        //    cmd.CommandType = CommandType.StoredProcedure;
        //    cmd.CommandText = "[International].[stp_RollbackTranferedNewStudentInfoToSida]";
        //    SqlParameter[] docParams = new SqlParameter[]
        //    {
        //       new SqlParameter("@stcode" , model.stcode),
        //       new SqlParameter("@studentId" , model.studentId),
        //       //new SqlParameter("@currenterm" , model.currenterm),              
        //    };
        //    cmd.Parameters.Clear();
        //    cmd.Parameters.AddRange(docParams);          
        //    try
        //    {
        //        SqlDataReader rdr;
        //        var dt = new DataTable();
        //        if (con.State != ConnectionState.Open) con.Open();
        //        rdr = cmd.ExecuteReader();
        //        dt.Load(rdr);
        //        if (dt != null && dt.Rows.Count > 0 && dt.Rows[0][0].ToString() == "1")
        //            res = "1";
        //    }
        //    catch (Exception ex)
        //    {
        //        throw ex;
        //    }
        //    return res;
        //}


        //string TranferedNewStudentDocsToSida(SqlConnection con, SqlCommand cmd, InsertToSida model)
        //{
        //    var res = "";            
        //    cmd.CommandType = CommandType.StoredProcedure;
        //    cmd.CommandText = "[International].[stp_TranferNewStudentDocumentsToSida]";
        //    SqlParameter[] docParams = new SqlParameter[]
        //    {
        //       new SqlParameter("@stcode" , model.stcode),
        //       new SqlParameter("@studentId" , model.studentId),
        //       //new SqlParameter("@currenterm" , model.currenterm),
        //       new SqlParameter("@name" , model.name),
        //       new SqlParameter("@family" , model.family),
        //       new SqlParameter("@ip" , model.ip),
        //    };
        //    cmd.Parameters.Clear();
        //    cmd.Parameters.AddRange(docParams);
        //    cmd.Parameters.Add("@personalImage", SqlDbType.VarBinary, -1).Value = model.personalImage;
        //    try
        //    {
        //        SqlDataReader rdr;
        //        var dt = new DataTable();
        //        if (con.State != ConnectionState.Open) con.Open();
        //        rdr = cmd.ExecuteReader();
        //        dt.Load(rdr);
        //        if (dt != null && dt.Rows.Count > 0 && dt.Rows[0][0].ToString() == "success")
        //            res = "success";
        //    }
        //    catch (Exception ex )
        //    {
        //        throw ex;
        //    }
        //    return res;
        //}

        //@@@@@@@@@@@@@@@@@@@@@@@@

        //public string InsertInToSida2(InsertToSida model)
        //{
        //    var result = "";
        //    var dt = new DataTable();
        //    using (var con = new SqlConnection(InitialConnectionString))
        //    {
        //        using (SqlCommand cmd = con.CreateCommand())
        //        {
        //            cmd.CommandType = CommandType.StoredProcedure;
        //            cmd.CommandText = "[International].[stp_InsertIntoSida]";
        //            cmd.Parameters.Clear();
        //            SqlParameter[] parameters = new SqlParameter[]
        //            {
        //                new SqlParameter("@term", model.term),
        //                new SqlParameter("@currenterm" , model.currenterm),
        //                new SqlParameter("@stcode" , model.stcode),
        //                new SqlParameter("@studentId" , model.studentId),
        //                new SqlParameter("@name" , model.name),
        //                new SqlParameter("@family" , model.family),
        //                new SqlParameter("@namep" , model.namep),
        //                new SqlParameter("@idd_meli" , model.idd_meli),
        //                new SqlParameter("@sex" , model.sex),
        //                new SqlParameter("@magh" , model.magh),
        //                new SqlParameter("@idreshSazman" , model.idreshSazman),
        //                new SqlParameter("@sal_vorod" , model.sal_vorod),
        //                new SqlParameter("@nimsal_vorod" , model.nimsal_vorod),
        //                new SqlParameter("@date_tav" , model.date_tav),
        //                new SqlParameter("@tahol" , model.tahol),
        //                new SqlParameter("@radif_gh" , model.radif_gh),
        //                new SqlParameter("@rotbeh_gh" , model.rotbeh_gh),
        //                new SqlParameter("@nomreh_gh" , model.nomreh_gh),
        //                new SqlParameter("@tarikhmohlat" , model.tarikhmohlat),
        //                new SqlParameter("@userId" , model.userId),
        //                new SqlParameter("@end_madrak" , model.end_madrak),
        //                new SqlParameter("@university" , model.university),
        //                new SqlParameter("@date_endmadrak" , model.date_endmadrak),
        //                new SqlParameter("@resh_endmadrak" , model.resh_endmadrak),
        //                new SqlParameter("@mahal_tav" , model.mahal_tav),
        //                new SqlParameter("@mahal_sodor" , model.mahal_sodor),
        //                new SqlParameter("@meliat" , model.meliat),
        //                new SqlParameter("@jesm" , model.jesm),
        //                new SqlParameter("@sahmeh" , model.sahmeh),
        //                new SqlParameter("@addressd" , model.addressd),
        //                new SqlParameter("@tel", model.tel),
        //                new SqlParameter("@mobile" , model.mobile),
        //                new SqlParameter("@code_posti" , model.code_posti),
        //                new SqlParameter("@email" , model.email),
        //                new SqlParameter("@ip" , model.ip),
        //                new SqlParameter("@fsf2_date_endMadrak" , model.date_endmadrak),
        //                new SqlParameter("@fsf2_din" , model.fsf2_din),
        //                new SqlParameter("@fsf2_nezam" , model.fsf2_nezam),
        //                new SqlParameter("@fsf2_radif_gh" , model.fsf2_radif_gh),
        //                new SqlParameter("@fsf2_rotbeh_gh" , model.fsf2_rotbeh_gh),
        //                new SqlParameter("@fsf2_nomreh_gh" , model.fsf2_nomreh_gh),
        //                new SqlParameter("@fsf2_addressd" , model.fsf2_addressd),
        //                new SqlParameter("@fsf2_email" , model.fsf2_email),
        //                new SqlParameter("@fsf2_code_posti" , model.fsf2_code_posti),
        //                new SqlParameter("@fsf2_local1" , model.fsf2_local1),
        //                new SqlParameter("@fsf2_Ostan" , model.fsf2_Ostan),
        //                new SqlParameter("@fsf2_Shahrestan" , model.fsf2_Shahrestan),
        //            };
        //            cmd.Parameters.AddRange(parameters);
        //            cmd.Parameters.Add("@personalImage", SqlDbType.VarBinary, -1).Value = model.personalImage;

        //            //cmd.Parameters.AddWithValue("@personalImage", model.personalImage);
        //            //cmd.Parameters.AddWithValue("@citizenshipImage", model.citizenshipDocImage);
        //            //cmd.Parameters.AddWithValue("@educationDegreeImage", model.baseEducationlImage);
        //            try
        //            {
        //                SqlDataReader rdr;
        //                if (con.State != ConnectionState.Open) con.Open();
        //                rdr = cmd.ExecuteReader();
        //                dt.Load(rdr);
        //                if (dt != null && dt.Rows.Count > 0 && dt.Rows[0][0].ToString() != "success")
        //                {
        //                    var res1 = this.RollbackTranferedNewStudentInfoToSida2(con, cmd, model);
        //                }
        //                else
        //                {
        //                    var res2 = this.TranferedNewStudentDocsToSida(con, cmd, model);
        //                    if (res2 != "success")
        //                    {
        //                        var res3 = this.RollbackTranferedNewStudentInfoToSida2(con, cmd, model);
        //                    }
        //                }
        //            }
        //            catch (Exception x)
        //            {
        //                var res4 = this.RollbackTranferedNewStudentInfoToSida2(con, cmd, model);
        //                if (con.State != ConnectionState.Closed) con.Close();
        //                //throw x;
        //            }
        //        }
        //    }
        //    if (dt != null && dt.Rows.Count > 0)
        //    {
        //        result = dt.Rows[0][0].ToString();
        //    }
        //    return result;
        //}

        //@@@@@@@@@@@@@@@@@@@@@@@@

        //public string InsertInToSida3(InsertToSida model)
        //{
        //    var result = "";
        //    var dt = new DataTable();
        //    using (SqlConnection con = new SqlConnection(InitialConnectionString))
        //    {
        //        con.Open();
        //        using (var trans = con.BeginTransaction())
        //        {
        //            try
        //            {
        //                using (var cmd = new SqlCommand("", con, trans))
        //                {
        //                    cmd.CommandText = "SET ANSI_WARNINGS OFF";
        //                    cmd.ExecuteNonQuery();

        //                    cmd.CommandType = CommandType.StoredProcedure;
        //                    cmd.CommandText = "[International].[stp_InsertIntoSida]";
        //                    SqlParameter[] parameters = new SqlParameter[]
        //                   {
        //                        new SqlParameter("@term", model.term),
        //                        new SqlParameter("@currenterm" , model.currenterm),
        //                        new SqlParameter("@stcode" , model.stcode),
        //                        new SqlParameter("@studentId" , model.studentId),
        //                        new SqlParameter("@name" , model.name),
        //                        new SqlParameter("@family" , model.family),
        //                        new SqlParameter("@namep" , model.namep),
        //                        new SqlParameter("@idd_meli" , model.idd_meli),
        //                        new SqlParameter("@sex" , model.sex),
        //                        new SqlParameter("@magh" , model.magh),
        //                        new SqlParameter("@idreshSazman" , model.idreshSazman),
        //                        new SqlParameter("@sal_vorod" , model.sal_vorod),
        //                        new SqlParameter("@nimsal_vorod" , model.nimsal_vorod),
        //                        new SqlParameter("@date_tav" , model.date_tav),
        //                        new SqlParameter("@tahol" , model.tahol),
        //                        new SqlParameter("@radif_gh" , model.radif_gh),
        //                        new SqlParameter("@rotbeh_gh" , model.rotbeh_gh),
        //                        new SqlParameter("@nomreh_gh" , model.nomreh_gh),
        //                        new SqlParameter("@tarikhmohlat" , model.tarikhmohlat),
        //                        new SqlParameter("@userId" , model.userId),
        //                        new SqlParameter("@end_madrak" , model.end_madrak),
        //                        new SqlParameter("@university" , model.university),
        //                        new SqlParameter("@date_endmadrak" , model.date_endmadrak),
        //                        new SqlParameter("@resh_endmadrak" , model.resh_endmadrak),
        //                        new SqlParameter("@mahal_tav" , model.mahal_tav),
        //                        new SqlParameter("@mahal_sodor" , model.mahal_sodor),
        //                        new SqlParameter("@meliat" , model.meliat),
        //                        new SqlParameter("@jesm" , model.jesm),
        //                        new SqlParameter("@sahmeh" , model.sahmeh),
        //                        new SqlParameter("@addressd" , model.addressd),
        //                        new SqlParameter("@tel", model.tel),
        //                        new SqlParameter("@mobile" , model.mobile),
        //                        new SqlParameter("@code_posti" , model.code_posti),
        //                        new SqlParameter("@email" , model.email),
        //                        new SqlParameter("@ip" , model.ip),
        //                        new SqlParameter("@fsf2_date_endMadrak" , model.date_endmadrak),
        //                        new SqlParameter("@fsf2_din" , model.fsf2_din),
        //                        new SqlParameter("@fsf2_nezam" , model.fsf2_nezam),
        //                        new SqlParameter("@fsf2_radif_gh" , model.fsf2_radif_gh),
        //                        new SqlParameter("@fsf2_rotbeh_gh" , model.fsf2_rotbeh_gh),
        //                        new SqlParameter("@fsf2_nomreh_gh" , model.fsf2_nomreh_gh),
        //                        new SqlParameter("@fsf2_addressd" , model.fsf2_addressd),
        //                        new SqlParameter("@fsf2_email" , model.fsf2_email),
        //                        new SqlParameter("@fsf2_code_posti" , model.fsf2_code_posti),
        //                        new SqlParameter("@fsf2_local1" , model.fsf2_local1),
        //                        new SqlParameter("@fsf2_Ostan" , model.fsf2_Ostan),
        //                        new SqlParameter("@fsf2_Shahrestan" , model.fsf2_Shahrestan),
        //                   };
        //                    cmd.Parameters.AddRange(parameters);
        //                    cmd.Parameters.AddWithValue("@personalImage", model.personalImage);
        //                    cmd.Parameters.AddWithValue("@citizenshipImage", model.citizenshipDocImage);
        //                    cmd.Parameters.AddWithValue("@educationDegreeImage", model.baseEducationlImage);
        //                    //cmd.ExecuteNonQuery();
        //                    SqlDataReader rdr;
        //                    if (con.State != ConnectionState.Open) con.Open();
        //                    rdr = cmd.ExecuteReader();
        //                    dt.Load(rdr);

        //                    cmd.Parameters.Clear();

        //                    cmd.CommandText = "SET ANSI_WARNINGS ON";
        //                    cmd.ExecuteNonQuery();

        //                    trans.Commit();
        //                }
        //            }
        //            catch (Exception x)
        //            {
        //                trans.Rollback();
        //            }

        //        }
        //        con.Close();
        //    }
        //    if (dt != null && dt.Rows.Count > 0)
        //    {
        //        result = dt.Rows[0][0].ToString();
        //    }
        //    return result;
        //}

        //@@@@@@@@@@@@@@@@@@@@@@@@

        //public void Createfnewstudent(List<AzmoonStudent> stInfo)
        //{

        //    DataTable dt = ToDataTable(stInfo);
        //    SqlCommand cmdControl = new SqlCommand();
        //    cmdControl.Connection = conn;
        //    cmdControl.CommandType = CommandType.StoredProcedure;
        //    cmdControl.CommandText = "[International].[SP_Insert_into_NewStudent]";

        //    cmdControl.Parameters.AddWithValue("@stList", dt);
        //    cmdControl.Parameters["@stList"].SqlDbType = SqlDbType.Structured;
        //    cmdControl.Parameters["@stList"].TypeName = "dbo.[StudentType]";

        //    try
        //    {
        //        conn.Open();
        //        cmdControl.ExecuteNonQuery();
        //        conn.Close();

        //    }
        //    catch (Exception)
        //    {

        //        throw;
        //    }
        //}
        //@@@@@@@@@@@@@@@@@@@@@@@@
    }
}
