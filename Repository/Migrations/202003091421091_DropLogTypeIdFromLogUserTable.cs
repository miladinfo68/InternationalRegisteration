namespace ISR.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class DropLogTypeIdFromLogUserTable : DbMigration
    {
        public override void Up()
        {
            DropColumn("International.UserLog", "LogTypeId");
        }
        
        public override void Down()
        {
            AddColumn("International.UserLog", "LogTypeId", c => c.Decimal(precision: 18, scale: 0));
        }
    }
}
