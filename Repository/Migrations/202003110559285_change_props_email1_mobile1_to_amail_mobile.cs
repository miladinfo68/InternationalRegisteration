namespace ISR.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class change_props_email1_mobile1_to_amail_mobile : DbMigration
    {
        public override void Up()
        {
            DropForeignKey("International.Student", "PersonId", "International.Person");
            AddColumn("International.Account", "Email", c => c.String(maxLength: 100));
            AddColumn("International.Account", "Mobile", c => c.String(maxLength: 20));
            AddColumn("International.Address", "Email", c => c.String(maxLength: 100));
            AddColumn("International.Address", "Mobile", c => c.String(maxLength: 30));
            AlterColumn("International.Account", "ResetPasswordToken", c => c.String(maxLength: 500));
            AlterColumn("International.FieldForForeigns", "Field_Name", c => c.String(maxLength: 300, unicode: false));
            AlterColumn("International.FieldForForeigns", "LanguageCode", c => c.String(maxLength: 20, unicode: false));
            AlterColumn("International.FieldForForeigns", "Code_Baygan", c => c.String(maxLength: 20, unicode: false));
            AlterColumn("International.Colleges", "LanguageCode", c => c.String(maxLength: 20, unicode: false));
            AlterColumn("International.EducationDegree", "UniversityName", c => c.String(maxLength: 200));
            AlterColumn("International.EducationDegree", "CountryName", c => c.String(maxLength: 200));
            AlterColumn("International.EducationDegree", "FieldTitle", c => c.String(maxLength: 400));
            AlterColumn("International.Address", "PhoneNo", c => c.String(maxLength: 30));
            AlterColumn("International.Address", "PreCodeForMobile", c => c.String(maxLength: 20));
            AlterColumn("International.Address", "PreCodeForPhoneNo", c => c.String(maxLength: 20));
            AlterColumn("International.Country", "Name", c => c.String(nullable: false, maxLength: 200));
            AlterColumn("International.StudentDocs", "Path", c => c.String(maxLength: 400));
            AlterColumn("International.StudentDocType", "DocNam", c => c.String(maxLength: 200));
            AlterColumn("International.Role", "DisplayName", c => c.String(maxLength: 200));
            AlterColumn("International.User", "Username", c => c.String(maxLength: 200));
            AlterColumn("International.User", "DisplayName", c => c.String(maxLength: 200));
            AlterColumn("International.User", "Password", c => c.String(nullable: false, maxLength: 400));
            AlterColumn("International.User", "ResetPasswordToken", c => c.String(maxLength: 400));
            AlterColumn("International.UserLog", "Description", c => c.String(maxLength: 400));
            AlterColumn("International.UserLogType", "Title", c => c.String(maxLength: 200));
            //AlterColumn("International.v_Amozesh_Fresh", "SidaFieldName", c => c.String(maxLength: 400, unicode: false));
            //AlterColumn("International.v_Amozesh_Fresh", "CodeSazman", c => c.String(maxLength: 20, unicode: false));
            AddForeignKey("International.Student", "PersonId", "International.Person", "Id", cascadeDelete: true);
            DropColumn("International.Account", "Email1");
            DropColumn("International.Account", "Mobile1");
            DropColumn("International.Address", "Email2");
            DropColumn("International.Address", "Mobile2");
        }
        
        public override void Down()
        {
            AddColumn("International.Address", "Mobile2", c => c.String(maxLength: 20));
            AddColumn("International.Address", "Email2", c => c.String(maxLength: 100));
            AddColumn("International.Account", "Mobile1", c => c.String(maxLength: 20));
            AddColumn("International.Account", "Email1", c => c.String(maxLength: 100));
            DropForeignKey("International.Student", "PersonId", "International.Person");
           // AlterColumn("International.v_Amozesh_Fresh", "CodeSazman", c => c.String(maxLength: 10, unicode: false));
            //AlterColumn("International.v_Amozesh_Fresh", "SidaFieldName", c => c.String(maxLength: 156, unicode: false));
            AlterColumn("International.UserLogType", "Title", c => c.String(maxLength: 100));
            AlterColumn("International.UserLog", "Description", c => c.String(maxLength: 200));
            AlterColumn("International.User", "ResetPasswordToken", c => c.String(maxLength: 200));
            AlterColumn("International.User", "Password", c => c.String(nullable: false, maxLength: 100));
            AlterColumn("International.User", "DisplayName", c => c.String(maxLength: 100));
            AlterColumn("International.User", "Username", c => c.String(maxLength: 100));
            AlterColumn("International.Role", "DisplayName", c => c.String(maxLength: 100));
            AlterColumn("International.StudentDocType", "DocNam", c => c.String(maxLength: 100));
            AlterColumn("International.StudentDocs", "Path", c => c.String(maxLength: 200));
            AlterColumn("International.Country", "Name", c => c.String(nullable: false, maxLength: 100));
            AlterColumn("International.Address", "PreCodeForPhoneNo", c => c.String(maxLength: 5));
            AlterColumn("International.Address", "PreCodeForMobile", c => c.String(maxLength: 5));
            AlterColumn("International.Address", "PhoneNo", c => c.String(maxLength: 20));
            AlterColumn("International.EducationDegree", "FieldTitle", c => c.String(maxLength: 100));
            AlterColumn("International.EducationDegree", "CountryName", c => c.String(maxLength: 100));
            AlterColumn("International.EducationDegree", "UniversityName", c => c.String(maxLength: 100));
            AlterColumn("International.Colleges", "LanguageCode", c => c.String(maxLength: 2, unicode: false));
            AlterColumn("International.FieldForForeigns", "Code_Baygan", c => c.String(maxLength: 10, unicode: false));
            AlterColumn("International.FieldForForeigns", "LanguageCode", c => c.String(maxLength: 2, unicode: false));
            AlterColumn("International.FieldForForeigns", "Field_Name", c => c.String(maxLength: 100, unicode: false));
            AlterColumn("International.Account", "ResetPasswordToken", c => c.String(maxLength: 200));
            DropColumn("International.Address", "Mobile");
            DropColumn("International.Address", "Email");
            DropColumn("International.Account", "Mobile");
            DropColumn("International.Account", "Email");
            AddForeignKey("International.Student", "PersonId", "International.Person", "Id");
        }
    }
}
