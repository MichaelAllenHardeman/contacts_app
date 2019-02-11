with AdaBase.Results.Sets;
with Contacts_App.Database;

with Ada.Text_IO;

package body Contacts_App.Authorization.User is

   use AdaBase;
   
   ---------------
   -- Get_By_ID --
   ---------------
   function Get_By_ID (ID : in Natural) return User_State is
      Statement : Database.Statement_Type := Database.Driver.Prepare_Select (Tables     => "users", 
                                                                             Columns    => "*",
                                                                             Conditions => "id = :id");
   begin
      Statement.Assign ("id", ID'Image);
      
      if not Statement.Execute       then raise Program_Error;  end if;
      if 0 = Statement.Rows_Returned then raise User_Not_Found; end if;
      
      declare
         Row         : Results.Sets.Datarow := Statement.Fetch_Next;
         User_ID     : Natural := Natural (Row.Column("id").As_Byte4);
         Username    : String  := Row.Column("name").As_String;
         Password    : String  := Row.Column("password").As_String;
         Given_Name  : String  := Row.Column("given_name").As_String;
         Family_Name : String  := Row.Column("family_name").As_String;
      begin
         return User_State'(Name_Length        => Username'Length,
                            Password_Length    => Password'Length,
                            Given_Name_Length  => Given_Name'Length,
                            Family_Name_Length => Family_Name'Length,
                            ID                 => User_ID,
                            Name               => Username,
                            Password           => Password,
                            Given_Name         => Given_Name,
                            Family_Name        => Family_Name);
      end;
   end;
   
   ------------------------
   -- Get_By_Credentials --
   ------------------------
   function Get_By_Credentials (Credentials : in Authorization.Credentials.Credentials_State) return User_State is
      Statement : Database.Statement_Type := Database.Driver.Prepare_Select (Tables     => "users", 
                                                                             Columns    => "*", 
                                                                             Conditions => "name = :name and password = :password");
   begin
      Statement.Assign ("name",     Credentials.Username);
      Statement.Assign ("password", Credentials.Password);
      
      if not Statement.Execute       then raise User_Not_Found; end if;
      if 0 = Statement.Rows_Returned then raise User_Not_Found; end if;
      
      declare
         Row         : Results.Sets.Datarow := Statement.Fetch_Next;
         ID          : Natural := Natural (Row.Column("id").As_Byte4);
         Username    : String  := Row.Column("name").As_String;
         Password    : String  := Row.Column("password").As_String;
         Given_Name  : String  := Row.Column("given_name").As_String;
         Family_Name : String  := Row.Column("family_name").As_String;
      begin
         return User_State'(Name_Length        => Username'Length,
                            Password_Length    => Password'Length,
                            Given_Name_Length  => Given_Name'Length,
                            Family_Name_Length => Family_Name'Length,
                            ID                 => ID,
                            Name               => Username,
                            Password           => Password,
                            Given_Name         => Given_Name,
                            Family_Name        => Family_Name);
      end;
      
   end;
   
end;
