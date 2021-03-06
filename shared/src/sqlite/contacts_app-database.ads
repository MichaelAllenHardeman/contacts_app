with AdaBase.Driver.Base.SQLite;
with AdaBase.Statement.Base.SQLite;
with AdaBase.Logger.Facility;

package Contacts_App.Database is

   DEFAULT_FILE : constant String := "../database/sqlite/contacts_app.db";
   DEFAULT_LOG  : constant String := "sqlite.log";

   subtype Database_Driver       is AdaBase.Driver.Base.SQLite.SQLite_Driver;
   subtype Statement_Type        is AdaBase.Statement.Base.SQLite.SQLite_Statement;
   subtype Statement_Type_Access is AdaBase.Statement.Base.SQLite.SQLite_Statement_Access;
   
   Driver : Database_Driver;

   procedure Connect;
   procedure Disconnect;

end;
