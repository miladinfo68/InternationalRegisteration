namespace ISR.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class del_fake_myprop : DbMigration
    {
        public override void Up()
        {
            DropColumn("International.RelatedPerson", "MyProperty");
        }
        
        public override void Down()
        {
            AddColumn("International.RelatedPerson", "MyProperty", c => c.String());
        }
    }
}
