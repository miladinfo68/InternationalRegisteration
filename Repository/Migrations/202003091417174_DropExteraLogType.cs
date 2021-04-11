namespace ISR.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class DropExteraLogType : DbMigration
    {
        public override void Up()
        {
            DropForeignKey("International.UserLog", "LogTypeId", "International.UserLogType");
            DropForeignKey("International.UserLog", "UserLogType_Id", "International.UserLogType");
            DropIndex("International.UserLog", new[] { "LogTypeId" });
            DropIndex("International.UserLog", new[] { "UserLogType_Id" });
            RenameColumn(table: "International.UserLog", name: "UserLogType_Id", newName: "UserLogTypeId");

            
            AlterColumn("International.UserLog", "UserLogTypeId", c => c.Decimal(nullable: false, precision: 18, scale: 0));
            CreateIndex("International.UserLog", "UserLogTypeId");
            AddForeignKey("International.UserLog", "UserLogTypeId", "International.UserLogType", "Id", cascadeDelete: true);
        }
        
        public override void Down()
        {
            DropForeignKey("International.UserLog", "UserLogTypeId", "International.UserLogType");
            DropIndex("International.UserLog", new[] { "UserLogTypeId" });
            AlterColumn("International.UserLog", "UserLogTypeId", c => c.Decimal(precision: 18, scale: 0));
            RenameColumn(table: "International.UserLog", name: "UserLogTypeId", newName: "UserLogType_Id");
            CreateIndex("International.UserLog", "UserLogType_Id");
            CreateIndex("International.UserLog", "LogTypeId");
            AddForeignKey("International.UserLog", "UserLogType_Id", "International.UserLogType", "Id");
            AddForeignKey("International.UserLog", "LogTypeId", "International.UserLogType", "Id");
        }
    }
}
