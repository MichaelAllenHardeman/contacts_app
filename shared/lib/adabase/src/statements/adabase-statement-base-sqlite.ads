--  This file is covered by the Internet Software Consortium (ISC) License
--  Reference: ../../License.txt

with AdaBase.Connection.Base.SQLite;
with AdaBase.Bindings.SQLite;
with Ada.Containers.Vectors;

package AdaBase.Statement.Base.SQLite is

   package ACS renames AdaBase.Connection.Base.SQLite;
   package BND renames AdaBase.Bindings.SQLite;
   package AC  renames Ada.Containers;

   type SQLite_statement (type_of_statement : Stmt_Type;
                          log_handler       : ALF.LogFacility_access;
                          sqlite_conn       : ACS.SQLite_Connection_Access;
                          initial_sql       : SQL_Access;
                          con_error_mode    : Error_Modes;
                          con_case_mode     : Case_Modes;
                          con_max_blob      : BLOB_Maximum)
   is new Base_Statement and AIS.iStatement with private;
   type SQLite_statement_access is access all SQLite_statement;

   overriding
   function column_count (Stmt : SQLite_statement) return Natural;

   overriding
   function last_insert_id (Stmt : SQLite_statement) return Trax_ID;

   overriding
   function last_sql_state (Stmt : SQLite_statement) return SQL_State;

   overriding
   function last_driver_code (Stmt : SQLite_statement) return Driver_Codes;

   overriding
   function last_driver_message (Stmt : SQLite_statement) return String;

   overriding
   procedure discard_rest   (Stmt : out SQLite_statement);

   overriding
   function execute         (Stmt : out SQLite_statement) return Boolean;

   overriding
   function execute         (Stmt : out SQLite_statement; parameters : String;
                             delimiter  : Character := '|') return Boolean;

   overriding
   function rows_returned   (Stmt : SQLite_statement) return Affected_Rows;

   overriding
   function column_name     (Stmt : SQLite_statement; index : Positive)
                             return String;

   overriding
   function column_table    (Stmt : SQLite_statement; index : Positive)
                             return String;

   overriding
   function column_native_type (Stmt : SQLite_statement; index : Positive)
                                return field_types;

   overriding
   function fetch_next (Stmt : out SQLite_statement) return ARS.Datarow;

   overriding
   function fetch_all  (Stmt : out SQLite_statement) return ARS.Datarow_Set;

   overriding
   function fetch_bound (Stmt : out SQLite_statement) return Boolean;

   overriding
   procedure fetch_next_set (Stmt         : out SQLite_statement;
                             data_present : out Boolean;
                             data_fetched : out Boolean);

private

   type column_info is record
      table         : CT.Text;
      field_name    : CT.Text;
      field_type    : field_types;
      null_possible : Boolean;
      sqlite_type   : BND.enum_field_types;
   end record;

   type sqlite_canvas is record
      buffer_binary : BND.ICS.char_array_access := null;
      buffer_text   : BND.ICS.chars_ptr         := BND.ICS.Null_Ptr;
   end record;

   type step_result_type is (unset, data_pulled, progam_complete, error_seen);

   package VColumns is new AC.Vectors (Index_Type   => Positive,
                                       Element_Type => column_info);

   package VCanvas  is new AC.Vectors (Index_Type   => Positive,
                                       Element_Type => sqlite_canvas);

   type SQLite_statement (type_of_statement : Stmt_Type;
                          log_handler       : ALF.LogFacility_access;
                          sqlite_conn       : ACS.SQLite_Connection_Access;
                          initial_sql       : SQL_Access;
                          con_error_mode    : Error_Modes;
                          con_case_mode     : Case_Modes;
                          con_max_blob      : BLOB_Maximum)
   is new Base_Statement and AIS.iStatement with
      record
         stmt_handle    : aliased BND.sqlite3_stmt_Access := null;
         step_result    : step_result_type := unset;
         assign_counter : Natural          := 0;
         num_columns    : Natural          := 0;
         column_info    : VColumns.Vector;
         bind_canvas    : VCanvas.Vector;
         sql_final      : SQL_Access;
      end record;

   procedure log_problem
     (statement  : SQLite_statement;
      category   : Log_Category;
      message    : String;
      pull_codes : Boolean := False;
      break      : Boolean := False);

   procedure initialize (Object : in out SQLite_statement);
   procedure Adjust     (Object : in out SQLite_statement);
   procedure finalize   (Object : in out SQLite_statement);
   procedure scan_column_information (Stmt : out SQLite_statement);
   procedure reclaim_canvas (Stmt : out SQLite_statement);
   function seems_like_bit_string (candidate : CT.Text) return Boolean;
   function private_execute (Stmt : out SQLite_statement) return Boolean;
   function construct_bind_slot (Stmt : SQLite_statement; marker : Positive)
                                 return sqlite_canvas;

   procedure free_binary is new Ada.Unchecked_Deallocation
     (BND.IC.char_array, BND.ICS.char_array_access);

end AdaBase.Statement.Base.SQLite;
