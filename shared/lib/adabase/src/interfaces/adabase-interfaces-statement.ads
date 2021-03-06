--  This file is covered by the Internet Software Consortium (ISC) License
--  Reference: ../../License.txt

with AdaBase.Results.Sets;

package AdaBase.Interfaces.Statement is

   type iStatement is limited interface;

   function successful    (Stmt : iStatement) return Boolean is abstract;
   function column_count  (Stmt : iStatement) return Natural is abstract;

   function last_driver_message (Stmt : iStatement) return String is abstract;
   function last_insert_id      (Stmt : iStatement) return Trax_ID is abstract;
   function last_sql_state      (Stmt : iStatement) return SQL_State
                                 is abstract;
   function last_driver_code    (Stmt : iStatement) return Driver_Codes
                                 is abstract;

   function data_discarded      (Stmt : iStatement) return Boolean is abstract;

   procedure discard_rest       (Stmt : out iStatement) is null;


   function execute         (Stmt : out iStatement) return Boolean is abstract;
   function execute         (Stmt : out iStatement; parameters : String;
                             delimiter  : Character := '|')
                             return Boolean is abstract;

   function rows_affected   (Stmt : iStatement)
                             return Affected_Rows is abstract;

   function rows_returned   (Stmt : iStatement)
                             return Affected_Rows is abstract;

   function column_name     (Stmt : iStatement; index : Positive)
                             return String is abstract;

   function column_table    (Stmt : iStatement; index : Positive)
                             return String is abstract;

   function column_native_type (Stmt : iStatement; index : Positive)
                                return field_types is abstract;

   function fetch_next      (Stmt    : out iStatement)
                             return AdaBase.Results.Sets.Datarow is abstract;

   function fetch_all       (Stmt : out iStatement)
                             return AdaBase.Results.Sets.Datarow_Set
                             is abstract;

   function fetch_bound     (Stmt : out iStatement) return Boolean is abstract;

   procedure fetch_next_set (Stmt         : out iStatement;
                             data_present : out Boolean;
                             data_fetched : out Boolean) is null;

   procedure iterate (Stmt    : out iStatement;
                      process : not null access procedure) is null;

   procedure iterate (Stmt    : out iStatement;
                      process : not null access procedure
                        (row : AdaBase.Results.Sets.Datarow)) is null;

   ------------------------------------------------------------------------
   --  Technically there should be 18-20 of each listed.  They are all
   --  implemented in the base class so they get inherited.  I'm too
   --  Lazy to add 116 prototypes here.
   --
   --     procedure bind    (Stmt    : out Base_Statement;
   --                        index   : Positive;
   --                        vaxx    : AR.nbyte0_access);
   --     procedure bind    (Stmt    : out Base_Statement;
   --                        heading : String;
   --                        vaxx    : AR.nbyte0_access);
   --     procedure assign  (Stmt    : out Base_Statement;
   --                        index   : Positive;
   --                        vaxx    : AR.nbyte0_access);
   --     procedure assign  (Stmt    : out Base_Statement;
   --                        moniker : String;
   --                        vaxx    : AR.nbyte0_access);
   --     procedure assign  (Stmt    : out Base_Statement;
   --                        index   : Positive;
   --                        vaxx    : AR.nbyte0);
   --     procedure assign  (Stmt    : out Base_Statement;
   --                        moniker : String;
   --                        vaxx    : AR.nbyte0);
   -------------------------------------------------------------------------

end AdaBase.Interfaces.Statement;
