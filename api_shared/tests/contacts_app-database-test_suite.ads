
with AUnit.Test_Suites;
pragma Elaborate_All (AUnit);
pragma Elaborate_All (AUnit.Test_Suites);

package Contacts_App.Database.Test_Suite is
   function Suite return AUnit.Test_Suites.Access_Test_Suite;
end;

