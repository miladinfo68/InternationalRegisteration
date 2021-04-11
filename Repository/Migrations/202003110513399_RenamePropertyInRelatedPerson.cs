namespace ISR.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class RenamePropertyInRelatedPerson : DbMigration
    {
        public override void Up()
        {
            DropForeignKey("International.RelatedPerson", "Person_Id", "International.Person");
            DropIndex("International.RelatedPerson", new[] { "Person_Id" });
            DropColumn("International.RelatedPerson", "Person_Id");
        }
        
        public override void Down()
        {
            AddColumn("International.RelatedPerson", "Person_Id", c => c.Decimal(precision: 18, scale: 0));
            CreateIndex("International.RelatedPerson", "Person_Id");
            AddForeignKey("International.RelatedPerson", "Person_Id", "International.Person", "Id");
        }
    }
}
