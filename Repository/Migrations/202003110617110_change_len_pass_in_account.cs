namespace ISR.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class change_len_pass_in_account : DbMigration
    {
        public override void Up()
        {
            DropForeignKey("International.Student", "PersonId", "International.Person");
            DropIndex("International.Student", new[] { "PersonId" });
            AlterColumn("International.Account", "Password", c => c.String(nullable: false, maxLength: 200));
            AlterColumn("International.Student", "PersonId", c => c.Decimal(precision: 18, scale: 0));
            //AlterColumn("International.v_Amozesh_Fresh", "SidaFieldName", c => c.String(unicode: false));
            //AlterColumn("International.v_Amozesh_Fresh", "CodeSazman", c => c.String(unicode: false));
            CreateIndex("International.Student", "PersonId");
            AddForeignKey("International.Student", "PersonId", "International.Person", "Id");
        }
        
        public override void Down()
        {
            DropForeignKey("International.Student", "PersonId", "International.Person");
            DropIndex("International.Student", new[] { "PersonId" });
            //AlterColumn("International.v_Amozesh_Fresh", "CodeSazman", c => c.String(maxLength: 20, unicode: false));
            //AlterColumn("International.v_Amozesh_Fresh", "SidaFieldName", c => c.String(maxLength: 400, unicode: false));
            AlterColumn("International.Student", "PersonId", c => c.Decimal(nullable: false, precision: 18, scale: 0));
            AlterColumn("International.Account", "Password", c => c.String(nullable: false, maxLength: 100));
            CreateIndex("International.Student", "PersonId");
            AddForeignKey("International.Student", "PersonId", "International.Person", "Id", cascadeDelete: true);
        }
    }
}
