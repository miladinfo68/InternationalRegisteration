namespace ISR.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddFakeProperty : DbMigration
    {
        public override void Up()
        {
            AddColumn("International.RelatedPerson", "MyProperty", c => c.String());
        }
        
        public override void Down()
        {
            DropColumn("International.RelatedPerson", "MyProperty");
        }
    }
}
