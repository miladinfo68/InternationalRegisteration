namespace ISR.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class a : DbMigration
    {
        public override void Up()
        {
            //RenameColumn(table: "International.RelatedPerson", name: "Person1_Id", newName: "Person_Id");
            //RenameIndex(table: "International.RelatedPerson", name: "IX_Person1_Id", newName: "IX_Person_Id");
        }
        
        public override void Down()
        {
            //RenameIndex(table: "International.RelatedPerson", name: "IX_Person_Id", newName: "IX_Person1_Id");
            //RenameColumn(table: "International.RelatedPerson", name: "Person_Id", newName: "Person1_Id");
        }
    }
}
