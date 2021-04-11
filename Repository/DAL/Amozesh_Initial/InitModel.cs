namespace ISR.DAL.Amozesh_Initial
{
    using System;
    using System.Data.Entity;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Linq;

    public partial class InitModel : DbContext
    {
        public InitModel(): base("name=InitModel")
        {
        }

        public virtual DbSet<Account> Accounts { get; set; }
        public virtual DbSet<Address> Addresses { get; set; }
        public virtual DbSet<CandidateField> CandidateFields { get; set; }
        public virtual DbSet<CitizenShip> CitizenShips { get; set; }
        public virtual DbSet<College> Colleges { get; set; }
        public virtual DbSet<Country> Countries { get; set; }
        public virtual DbSet<EducationDegree> EducationDegrees { get; set; }
        public virtual DbSet<FieldForForeign> FieldForForeigns { get; set; }
        public virtual DbSet<NewStudent> NewStudents { get; set; }
        public virtual DbSet<Person> People { get; set; }
        public virtual DbSet<RelatedPerson> RelatedPersons { get; set; }
        public virtual DbSet<Request> Requests { get; set; }
        public virtual DbSet<Role> Roles { get; set; }
        public virtual DbSet<Student> Students { get; set; }
        public virtual DbSet<StudentDoc> StudentDocs { get; set; }
        public virtual DbSet<StudentDocType> StudentDocTypes { get; set; }
        public virtual DbSet<User> Users { get; set; }
        public virtual DbSet<User_Role> User_Role { get; set; }
        public virtual DbSet<UserAccess> UserAccesses { get; set; }
        public virtual DbSet<UserLog> UserLogs { get; set; }
        public virtual DbSet<UserLogType> UserLogTypes { get; set; }
        public virtual DbSet<v_Amozesh_Fresh> v_Amozesh_Fresh { get; set; }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Account>()
                .Property(e => e.Id)
                .HasPrecision(18, 0);

            modelBuilder.Entity<Account>()
                .Property(e => e.StudentId)
                .HasPrecision(18, 0);

            modelBuilder.Entity<Address>()
                .Property(e => e.Id)
                .HasPrecision(18, 0);

            modelBuilder.Entity<Address>()
                .Property(e => e.PersonId)
                .HasPrecision(18, 0);

            modelBuilder.Entity<CandidateField>()
                .Property(e => e.Id)
                .HasPrecision(18, 0);

            modelBuilder.Entity<CandidateField>()
                .Property(e => e.StudentId)
                .HasPrecision(18, 0);

            modelBuilder.Entity<CandidateField>()
                .Property(e => e.FieldId)
                .HasPrecision(18, 0);

            modelBuilder.Entity<CitizenShip>()
                .Property(e => e.Id)
                .HasPrecision(18, 0);

            modelBuilder.Entity<CitizenShip>()
                .Property(e => e.PersonId)
                .HasPrecision(18, 0);

            modelBuilder.Entity<CitizenShip>()
                .Property(e => e.CountryId)
                .HasPrecision(18, 0);

            modelBuilder.Entity<CitizenShip>()
                .Property(e => e.IssuePlace)
                .HasPrecision(18, 0);

            modelBuilder.Entity<College>()
                .Property(e => e.Id)
                .HasPrecision(18, 0);

            modelBuilder.Entity<College>()
                .Property(e => e.SIDA_Code)
                .HasPrecision(18, 0);

            modelBuilder.Entity<College>()
                .Property(e => e.LanguageCode)
                .IsUnicode(false);

            modelBuilder.Entity<Country>()
                .Property(e => e.Id)
                .HasPrecision(18, 0);

            modelBuilder.Entity<EducationDegree>()
                .Property(e => e.Id)
                .HasPrecision(18, 0);

            modelBuilder.Entity<EducationDegree>()
                .Property(e => e.SudentId)
                .HasPrecision(18, 0);

            modelBuilder.Entity<EducationDegree>()
                .Property(e => e.FieldId)
                .HasPrecision(18, 0);

            modelBuilder.Entity<EducationDegree>()
                .Property(e => e.EducationDegreePlace)
                .HasPrecision(18, 0);

            modelBuilder.Entity<FieldForForeign>()
                .Property(e => e.Id)
                .HasPrecision(18, 0);

            modelBuilder.Entity<FieldForForeign>()
                .Property(e => e.Field_Name)
                .IsUnicode(false);

            modelBuilder.Entity<FieldForForeign>()
                .Property(e => e.LanguageCode)
                .IsUnicode(false);

            modelBuilder.Entity<FieldForForeign>()
                .Property(e => e.CollegeId)
                .HasPrecision(18, 0);

            modelBuilder.Entity<FieldForForeign>()
                .Property(e => e.Code_Baygan)
                .IsUnicode(false);

            modelBuilder.Entity<FieldForForeign>()
                .HasMany(e => e.CandidateFields)
                .WithOptional(e => e.FieldForForeign)
                .HasForeignKey(e => e.FieldId);

            modelBuilder.Entity<NewStudent>()
                .Property(e => e.stcodeTemp)
                .IsUnicode(false);

            modelBuilder.Entity<NewStudent>()
                .Property(e => e.idd)
                .IsUnicode(false);

            modelBuilder.Entity<NewStudent>()
                .Property(e => e.idd_meli)
                .IsUnicode(false);

            modelBuilder.Entity<NewStudent>()
                .Property(e => e.idresh)
                .HasPrecision(18, 0);

            modelBuilder.Entity<NewStudent>()
                .Property(e => e.date_tav)
                .IsUnicode(false);

            modelBuilder.Entity<NewStudent>()
                .Property(e => e.radif_gh)
                .IsUnicode(false);

            modelBuilder.Entity<NewStudent>()
                .Property(e => e.rotbeh_gh)
                .IsUnicode(false);

            modelBuilder.Entity<NewStudent>()
                .Property(e => e.nomreh_gh)
                .IsUnicode(false);

            modelBuilder.Entity<NewStudent>()
                .Property(e => e.code_posti)
                .IsUnicode(false);

            modelBuilder.Entity<NewStudent>()
                .Property(e => e.tel)
                .IsUnicode(false);

            modelBuilder.Entity<NewStudent>()
                .Property(e => e.mobile)
                .IsUnicode(false);

            modelBuilder.Entity<NewStudent>()
                .Property(e => e.email)
                .IsUnicode(false);

            modelBuilder.Entity<NewStudent>()
                .Property(e => e.addressd)
                .IsUnicode(false);

            modelBuilder.Entity<NewStudent>()
                .Property(e => e.dateenteghal)
                .IsUnicode(false);

            modelBuilder.Entity<NewStudent>()
                .Property(e => e.idgeraesh)
                .HasPrecision(18, 0);

            modelBuilder.Entity<NewStudent>()
                .Property(e => e.par)
                .IsUnicode(false);

            modelBuilder.Entity<NewStudent>()
                .Property(e => e.dav)
                .IsUnicode(false);

            modelBuilder.Entity<NewStudent>()
                .Property(e => e.date_sabtenam)
                .IsUnicode(false);

            modelBuilder.Entity<NewStudent>()
                .Property(e => e.mahal_tav)
                .HasPrecision(18, 0);

            modelBuilder.Entity<NewStudent>()
                .Property(e => e.mahal_sodor)
                .HasPrecision(18, 0);

            modelBuilder.Entity<NewStudent>()
                .Property(e => e.tahol)
                .HasPrecision(18, 0);

            modelBuilder.Entity<NewStudent>()
                .Property(e => e.end_madrak)
                .HasPrecision(18, 0);

            modelBuilder.Entity<NewStudent>()
                .Property(e => e.din)
                .HasPrecision(18, 0);

            modelBuilder.Entity<NewStudent>()
                .Property(e => e.resh_endmadrak)
                .HasPrecision(18, 0);

            modelBuilder.Entity<NewStudent>()
                .Property(e => e.date_endmadrak)
                .IsUnicode(false);

            modelBuilder.Entity<NewStudent>()
                .Property(e => e.avrg_payeh)
                .IsUnicode(false);

            modelBuilder.Entity<NewStudent>()
                .Property(e => e.dip_avrg)
                .IsUnicode(false);

            modelBuilder.Entity<NewStudent>()
                .Property(e => e.sahmeh)
                .HasPrecision(18, 0);

            modelBuilder.Entity<NewStudent>()
                .Property(e => e.sahmeh_Ostan)
                .IsUnicode(false);

            modelBuilder.Entity<NewStudent>()
                .Property(e => e.university)
                .HasPrecision(18, 0);

            modelBuilder.Entity<NewStudent>()
                .Property(e => e.bomi)
                .HasPrecision(18, 0);

            modelBuilder.Entity<NewStudent>()
                .Property(e => e.jesm)
                .HasPrecision(18, 0);

            modelBuilder.Entity<NewStudent>()
                .Property(e => e.meliat)
                .HasPrecision(18, 0);

            modelBuilder.Entity<NewStudent>()
                .Property(e => e.job)
                .IsUnicode(false);

            modelBuilder.Entity<NewStudent>()
                .Property(e => e.sal_vorod)
                .HasPrecision(18, 0);

            modelBuilder.Entity<NewStudent>()
                .Property(e => e.janbazi_nesbat)
                .IsUnicode(false);

            modelBuilder.Entity<NewStudent>()
                .Property(e => e.janbaz_rayaneh)
                .IsUnicode(false);

            modelBuilder.Entity<NewStudent>()
                .Property(e => e.khedmat_add)
                .IsUnicode(false);

            modelBuilder.Entity<NewStudent>()
                .Property(e => e.DataEnterDate)
                .IsUnicode(false);

            modelBuilder.Entity<NewStudent>()
                .Property(e => e.StateWelfareLetter)
                .IsUnicode(false);

            modelBuilder.Entity<NewStudent>()
                .Property(e => e.StateWelfareLetterDate)
                .IsUnicode(false);

            modelBuilder.Entity<NewStudent>()
                .Property(e => e.JobTel)
                .IsUnicode(false);

            modelBuilder.Entity<NewStudent>()
                .Property(e => e.JobPostalcode)
                .IsUnicode(false);

            modelBuilder.Entity<NewStudent>()
                .Property(e => e.SpouseFirstName)
                .IsUnicode(false);

            modelBuilder.Entity<NewStudent>()
                .Property(e => e.SpouseLastName)
                .IsUnicode(false);

            modelBuilder.Entity<NewStudent>()
                .Property(e => e.SpouseJobTitle)
                .IsUnicode(false);

            modelBuilder.Entity<NewStudent>()
                .Property(e => e.Accessories)
                .IsUnicode(false);

            modelBuilder.Entity<NewStudent>()
                .Property(e => e.LocalFacilities)
                .IsUnicode(false);

            modelBuilder.Entity<NewStudent>()
                .Property(e => e.ReligionBranches)
                .HasPrecision(18, 0);

            modelBuilder.Entity<NewStudent>()
                .Property(e => e.SimultaneousEntrance)
                .HasPrecision(18, 0);

            modelBuilder.Entity<NewStudent>()
                .Property(e => e.SimultaneousField)
                .HasPrecision(18, 0);

            modelBuilder.Entity<NewStudent>()
                .Property(e => e.SimultaneousLevel)
                .HasPrecision(18, 0);

            modelBuilder.Entity<NewStudent>()
                .Property(e => e.SimultaneousUni)
                .HasPrecision(18, 0);

            modelBuilder.Entity<NewStudent>()
                .Property(e => e.SimultaneousUniType)
                .HasPrecision(18, 0);

            modelBuilder.Entity<NewStudent>()
                .Property(e => e.SimultaneousStudy)
                .HasPrecision(18, 0);

            modelBuilder.Entity<NewStudent>()
                .Property(e => e.RequestId)
                .HasPrecision(18, 0);

            modelBuilder.Entity<NewStudent>()
                .Property(e => e.NewStudentId)
                .HasPrecision(18, 0);

            modelBuilder.Entity<Person>()
                .Property(e => e.Id)
                .HasPrecision(18, 0);

            modelBuilder.Entity<Person>()
                .HasMany(e => e.CitizenShips)
                .WithRequired(e => e.Person)
                .WillCascadeOnDelete(false);   


            //modelBuilder.Entity<Person>()
            //    .HasMany(e => e.Students)
            //    .WithRequired(e => e.Person)
            //    .WillCascadeOnDelete(false);

            modelBuilder.Entity<RelatedPerson>()
                .Property(e => e.Id)
                .HasPrecision(18, 0);

            modelBuilder.Entity<RelatedPerson>()
                .Property(e => e.MainPersonId)
                .HasPrecision(18, 0);

            modelBuilder.Entity<RelatedPerson>()
                .Property(e => e.RelatedPersonId)
                .HasPrecision(18, 0);
           
            modelBuilder.Entity<Request>()
                .Property(e => e.Id)
                .HasPrecision(18, 0);

            modelBuilder.Entity<Request>()
                .Property(e => e.StudentId)
                .HasPrecision(18, 0);

            modelBuilder.Entity<Role>()
                .Property(e => e.Id)
                .HasPrecision(18, 0);

            modelBuilder.Entity<Student>()
                .Property(e => e.Id)
                .HasPrecision(18, 0);

            //modelBuilder.Entity<Student>()
            //    .Property(e => e.PersonId)
            //    .HasPrecision(18, 0);

            modelBuilder.Entity<Student>()
                .Property(e => e.Language)
                .IsUnicode(false);

            modelBuilder.Entity<Student>()
                .HasMany(e => e.EducationDegrees)
                .WithOptional(e => e.Student)
                .HasForeignKey(e => e.SudentId);

            modelBuilder.Entity<Student>()
                .HasMany(e => e.StudentDocs)
                .WithRequired(e => e.Student)
                .HasForeignKey(e => e.SudentId)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<StudentDoc>()
                .Property(e => e.Id)
                .HasPrecision(18, 0);

            modelBuilder.Entity<StudentDoc>()
                .Property(e => e.SudentId)
                .HasPrecision(18, 0);

            modelBuilder.Entity<StudentDoc>()
                .Property(e => e.Web_msg_stu_Idnaghs)
                .HasPrecision(18, 0);

            modelBuilder.Entity<StudentDocType>()
                .HasMany(e => e.StudentDocs)
                .WithOptional(e => e.StudentDocType)
                .HasForeignKey(e => e.Category);

            modelBuilder.Entity<User>()
                .Property(e => e.Id)
                .HasPrecision(18, 0);

            modelBuilder.Entity<User_Role>()
                .Property(e => e.Id)
                .HasPrecision(18, 0);

            modelBuilder.Entity<User_Role>()
                .Property(e => e.UserId)
                .HasPrecision(18, 0);

            modelBuilder.Entity<User_Role>()
                .Property(e => e.RoleId)
                .HasPrecision(18, 0);

            modelBuilder.Entity<UserAccess>()
                .Property(e => e.RoleId)
                .HasPrecision(18, 0);

            modelBuilder.Entity<UserLog>()
                .Property(e => e.ID)
                .HasPrecision(18, 0);

            //modelBuilder.Entity<UserLog>()
            //    .Property(e => e.LogTypeId)
            //    .HasPrecision(18, 0);

            modelBuilder.Entity<UserLog>()
                .Property(e => e.UserId)
                .HasPrecision(18, 0);

            //modelBuilder.Entity<UserLog>()
            //    .Property(e => e.UserLogType_Id)
            //    .HasPrecision(18, 0);

            modelBuilder.Entity<UserLogType>()
                .Property(e => e.Id)
                .HasPrecision(18, 0);

            //modelBuilder.Entity<UserLogType>()
            //    .HasMany(e => e.UserLogs)
            //    .WithOptional(e => e.UserLogType)
            //    .HasForeignKey(e => e.UserLogType_Id);

            //modelBuilder.Entity<UserLogType>()
            //    .HasMany(e => e.UserLogs1)
            //    .WithOptional(e => e.UserLogType1)
            //    .HasForeignKey(e => e.LogTypeId);

            modelBuilder.Entity<v_Amozesh_Fresh>()
                .Property(e => e.SidaFieldId)
                .HasPrecision(18, 0);

            modelBuilder.Entity<v_Amozesh_Fresh>()
                .Property(e => e.SidaFieldName)
                .IsUnicode(false);

            modelBuilder.Entity<v_Amozesh_Fresh>()
                .Property(e => e.CodeSazman)
                .IsUnicode(false);
        }
    }
}
