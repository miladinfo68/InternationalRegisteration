namespace ISR.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class Add_Country_CitizenShipViewModel : DbMigration
    {
        public override void Up()
        {
            CreateIndex("International.CitizenShip", "CountryId");
            AddForeignKey("International.CitizenShip", "CountryId", "International.Country", "Id");
        }
        
        public override void Down()
        {
            DropForeignKey("International.CitizenShip", "CountryId", "International.Country");
            DropIndex("International.CitizenShip", new[] { "CountryId" });
        }
    }
}
