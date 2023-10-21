"! <p class="shorttext synchronized" lang="en">CA-TBX: Value help supporting tool</p>
"!
"! <p>This class is not only to call a value-help, but also to read and write values from / into the screen
"! fields. And so it is / must also possible to register screen fields without assignment to a value-help
"! field.</p>
"! <p>E. g., call the value-help for a supplier Id and provide the purchasing org. as default selection value.
"! After the user made his selection, read the supplier master record to provide the payment and inco terms
"! as they appear all together in the same screen. For such a case you need to register the mentioned additional
"! fields to provide there values too.</p>
CLASS zcl_ca_vh_tool DEFINITION PUBLIC
                                CREATE PUBLIC.

* P U B L I C   S E C T I O N
  PUBLIC SECTION.
*   i n t e r f a c e s
    INTERFACES:
      if_xo_const_message.

*   a l i a s e s
    ALIASES:
*     Message types
      c_msgty_e                   FOR  if_xo_const_message~error,
      c_msgty_i                   FOR  if_xo_const_message~info,
      c_msgty_s                   FOR  if_xo_const_message~success,
      c_msgty_w                   FOR  if_xo_const_message~warning.

*   i n s t a n c e   a t t r i b u t e s
    DATA:
*     o b j e c t   r e f e r e n c e s
      "! <p class="shorttext synchronized" lang="en">Constants and value checks for value/search help tool</p>
      mo_vh_options            TYPE REF TO zcl_ca_c_vh_tool READ-ONLY,

*     s i n g l e   v a l u e s
      "! <p class="shorttext synchronized" lang="en">Program name for value/search help call</p>
      mv_progname              TYPE syrepid READ-ONLY,
      "! <p class="shorttext synchronized" lang="en">Screen / dnypro number for value/search help call</p>
      mv_screen_no             TYPE syst_dynnr READ-ONLY,
      "! <p class="shorttext synchronized" lang="en">Actual step loop index for value help call in table control</p>
      mv_actual_table_ctrl_row TYPE syst_stepl READ-ONLY.

*   i n s t a n c e   m e t h o d s
    METHODS:
      "! <p class="shorttext synchronized" lang="en">Set corresponding search help field name for screen field</p>
      "!
      "! @parameter iv_scr_field_name     | <p class="shorttext synchronized" lang="en">Screen field name</p>
      "! @parameter iv_idx_table_ctrl_row | <p class="shorttext synchronized" lang="en">Index of the table control row (SY-STEPL) -&gt; see REGISTER...</p>
      "! @parameter iv_vh_field_name      | <p class="shorttext synchronized" lang="en">Name of corresponding field in value help</p>
      "! @raising   zcx_ca_vh_tool        | <p class="shorttext synchronized" lang="en">Common exception: While calling/supporting value/search help</p>
      assign_vh_field_to_scr_field
        IMPORTING
          iv_scr_field_name     TYPE csequence
          iv_idx_table_ctrl_row TYPE syst_stepl DEFAULT 0
          iv_vh_field_name      TYPE ddshlpsfld
        RAISING
          zcx_ca_vh_tool,

      "! <p class="shorttext synchronized" lang="en">Call value/search help</p>
      "!
      "! @parameter iv_return_field    | <p class="shorttext synchronized" lang="en">Receiving dynpro field, if empty set all registered fields</p>
      "! @parameter iv_use_screen_val  | <p class="shorttext synchronized" lang="en">X = Use entered value for selection screen field</p>
      "! @parameter iv_set_to_screen   | <p class="shorttext synchronized" lang="en">X = Set selected value directly into screen field</p>
      "! @parameter iv_convert_to_ext  | <p class="shorttext synchronized" lang="en">X = Convert value into external type of receiver field</p>
      "! @parameter iv_only_input_flds | <p class="shorttext synchronized" lang="en">X = Set only for input fields; 0 = Set also for display flds</p>
      "! @parameter it_vh_select_opt   | <p class="shorttext synchronized" lang="en">Selection options for value/search helps</p>
      "! @parameter iv_title           | <p class="shorttext synchronized" lang="en">Title for popup (overwriting standard)</p>
      "! @parameter iv_max_hits        | <p class="shorttext synchronized" lang="en">Restrict hits of selection list</p>
      "! @parameter iv_pos_at_column   | <p class="shorttext synchronized" lang="en">Horizontal position on screen (column)</p>
      "! @parameter iv_pos_at_row      | <p class="shorttext synchronized" lang="en">Vertical position on screen (row/line)</p>
      "! @parameter result             | <p class="shorttext synchronized" lang="en">X = User cancelled -> if not supplied a message is send</p>
      "! @raising   zcx_ca_vh_tool     | <p class="shorttext synchronized" lang="en">Common exception: While calling/supporting value/search help</p>
      "! @raising   zcx_ca_ui          | <p class="shorttext synchronized" lang="en">Common exception: UI interaction messages</p>
      call_f4_value_help
        IMPORTING
          iv_return_field    TYPE ddshlpdfld OPTIONAL
          iv_use_screen_val  TYPE abap_bool  DEFAULT abap_true
          iv_set_to_screen   TYPE abap_bool  DEFAULT abap_true
          iv_convert_to_ext  TYPE abap_bool  DEFAULT abap_true
          iv_only_input_flds TYPE abap_bool  DEFAULT abap_true
          it_vh_select_opt   TYPE ddshselops OPTIONAL
          iv_title           TYPE csequence  OPTIONAL
          iv_max_hits        TYPE ddshmaxrec DEFAULT 500
          iv_pos_at_column   TYPE sycucol    DEFAULT 70
          iv_pos_at_row      TYPE sycurow    DEFAULT 15
        RETURNING
          VALUE(result)      TYPE abap_bool
        RAISING
          zcx_ca_vh_tool
          zcx_ca_ui,

      "! <p class="shorttext synchronized" lang="en">Constructor</p>
      "!
      "! @parameter iv_progname    | <p class="shorttext synchronized" lang="en">ABAP Program Name</p>
      "! @parameter iv_screen_no   | <p class="shorttext synchronized" lang="en">Current Screen Number</p>
      "! @parameter iv_vh_name     | <p class="shorttext synchronized" lang="en">Name of a value help / table name</p>
      "! @parameter iv_vh_type     | <p class="shorttext synchronized" lang="en">Type of an input help (use ZCL_CA_C_VH_TOOL=&gt;VH_TYPE-*)</p>
      "! @raising   zcx_ca_vh_tool | <p class="shorttext synchronized" lang="en">Common exception: While calling/supporting value/search help</p>
      constructor
        IMPORTING
          VALUE(iv_progname)  TYPE progname  DEFAULT sy-cprog
          VALUE(iv_screen_no) TYPE sydynnr   DEFAULT sy-dynnr
          iv_vh_name          TYPE shlpname  OPTIONAL
          iv_vh_type          TYPE ddshlptyp DEFAULT zcl_ca_c_vh_tool=>vh_type-search_help
        RAISING
          zcx_ca_vh_tool,

      "! <p class="shorttext synchronized" lang="en">Get screen field (field name + value + input flag)</p>
      "!
      "! @parameter iv_scr_field_name     | <p class="shorttext synchronized" lang="en">Screen field name</p>
      "! @parameter iv_idx_table_ctrl_row | <p class="shorttext synchronized" lang="en">Index of the table control row (SY-STEPL) -&gt; see REGISTER...</p>
      "! @parameter result                | <p class="shorttext synchronized" lang="en">Field of the current screen (with value)</p>
      "! @raising   zcx_ca_vh_tool        | <p class="shorttext synchronized" lang="en">Common exception: While calling/supporting value/search help</p>
      get_screen_field_entry
        IMPORTING
          iv_scr_field_name     TYPE csequence
          iv_idx_table_ctrl_row TYPE syst_stepl DEFAULT 0
        RETURNING
          VALUE(result)         TYPE dynpread
        RAISING
          zcx_ca_vh_tool,

      "! <p class="shorttext synchronized" lang="en">Get value of screen field</p>
      "!
      "! @parameter iv_scr_field_name     | <p class="shorttext synchronized" lang="en">Screen field name</p>
      "! @parameter iv_idx_table_ctrl_row | <p class="shorttext synchronized" lang="en">Index of the table control row (SY-STEPL) -&gt; see REGISTER...</p>
      "! @parameter iv_convert_to_int     | <p class="shorttext synchronized" lang="en">X = Convert value into interal type of receiver field</p>
      "! @parameter ev_scr_field_value    | <p class="shorttext synchronized" lang="en">Value of screen field</p>
      "! @parameter ev_is_changable       | <p class="shorttext synchronized" lang="en">X = The field is an input field; ' ' = Display only</p>
      "! @raising   zcx_ca_vh_tool        | <p class="shorttext synchronized" lang="en">Common exception: While calling/supporting value/search help</p>
      get_screen_field_value
        IMPORTING
          iv_scr_field_name     TYPE csequence
          iv_idx_table_ctrl_row TYPE syst_stepl DEFAULT 0
          iv_convert_to_int     TYPE abap_bool DEFAULT abap_false
        EXPORTING
          ev_scr_field_value    TYPE simple
          ev_is_changable       TYPE abap_bool
        RAISING
          zcx_ca_vh_tool,

      "! <p class="shorttext synchronized" lang="en">Get table control row index to be used</p>
      "!
      "! @parameter iv_idx_table_ctrl_row | <p class="shorttext synchronized" lang="en">Index of the table control row (SY-STEPL) -&gt; see REGISTER...</p>
      "! @parameter result                | <p class="shorttext synchronized" lang="en">Table control row index to be used</p>
      get_table_control_row_index
        IMPORTING
          iv_idx_table_ctrl_row TYPE syst_stepl DEFAULT 0
        RETURNING
          VALUE(result)         TYPE syst_stepl,

      "! <p class="shorttext synchronized" lang="en">Get techn. descr. of value help incl. already set values</p>
      "!
      "! @parameter result         | <p class="shorttext synchronized" lang="en">Technical description of value/search help</p>
      "! @raising   zcx_ca_vh_tool | <p class="shorttext synchronized" lang="en">Common exception: While calling/supporting value/search help</p>
      get_technical_description
        RETURNING
          VALUE(result) TYPE shlp_descr
        RAISING
          zcx_ca_vh_tool,

      "! <p class="shorttext synchronized" lang="en">Is value/search help set?</p>
      "!
      "! @parameter iv_raise_excep | <p class="shorttext synchronized" lang="en">X = Raise exception if no value/search help is set</p>
      "! @parameter result         | <p class="shorttext synchronized" lang="en">X = Value/search help is set</p>
      "! @raising   zcx_ca_vh_tool | <p class="shorttext synchronized" lang="en">Common exception: While calling/supporting value/search help</p>
      is_value_help_set
        IMPORTING
          iv_raise_excep TYPE abap_bool DEFAULT abap_false
        RETURNING
          VALUE(result)  TYPE abap_bool
        RAISING
          zcx_ca_vh_tool,

      "! <p class="shorttext synchronized" lang="en">Read current values from screen for registered fields</p>
      read_field_values_from_screen
        IMPORTING
          iv_selection_type TYPE char1 DEFAULT zcl_ca_c_vh_tool=>selection_type-only_defined_scr_flds
        RAISING
          zcx_ca_vh_tool,

      "! <p class="shorttext synchronized" lang="en">Add / register screen field</p>
      "!
      "! @parameter iv_scr_field_name     | <p class="shorttext synchronized" lang="en">Screen field name</p>
      "! @parameter iv_idx_table_ctrl_row | <p class="shorttext synchronized" lang="en">Index of the table control row (SY-STEPL)</p>
      "! <p>Use this parameter if the class is used to read the screen values of several table control rows. To read a value in a specific
      "! row of a table control the CONSTRUCTOR provides the the current index in instance attribute MV_ACTUAL_TABLE_CTRL_ROW, which is
      "! normally sufficient.</p>
      "! @parameter iv_vh_field_name      | <p class="shorttext synchronized" lang="en">Name of corresponding field in value help</p>
      "! @raising   zcx_ca_vh_tool        | <p class="shorttext synchronized" lang="en">Common exception: While calling/supporting value/search help</p>
      register_screen_field
        IMPORTING
          iv_scr_field_name     TYPE csequence
          iv_idx_table_ctrl_row TYPE syst_stepl DEFAULT 0
          iv_vh_field_name      TYPE ddshlpsfld OPTIONAL
        RAISING
          zcx_ca_vh_tool,

      "! <p class="shorttext synchronized" lang="en">Set a new/other dialog type for value/search help</p>
      "!
      "! @parameter iv_dialog_type | <p class="shorttext synchronized" lang="en">Dialog type (MO_OPTIONS->DIALOG_TYPE-*, see docu DDSHDIATYP)</p>
      "! @raising   zcx_ca_vh_tool | <p class="shorttext synchronized" lang="en">Common exception: While calling/supporting value/search help</p>
      set_dialog_type
        IMPORTING
          iv_dialog_type TYPE ddshdiatyp
        RAISING
          zcx_ca_vh_tool,

      "! <p class="shorttext synchronized" lang="en">Set screen field value into buffer</p>
      "!
      "! @parameter iv_scr_field_name     | <p class="shorttext synchronized" lang="en">Screen field name</p>
      "! @parameter iv_idx_table_ctrl_row | <p class="shorttext synchronized" lang="en">Index of the table control line (SY-STEPL)</p>
      "! @parameter iv_scr_field_value    | <p class="shorttext synchronized" lang="en">New value for screen field (otherwise use value from buffer)</p>
      "! @parameter iv_convert_to_ext     | <p class="shorttext synchronized" lang="en">X = Convert value into external type of receiver field</p>
      "! @parameter iv_unit               | <p class="shorttext synchronized" lang="en">Base Unit of Measure</p>
      "! @parameter iv_currency           | <p class="shorttext synchronized" lang="en">Currency Key</p>
      "! @raising   zcx_ca_vh_tool        | <p class="shorttext synchronized" lang="en">Common exception: While calling/supporting value/search help</p>
      set_screen_field_value
        IMPORTING
          iv_scr_field_name     TYPE csequence
          iv_idx_table_ctrl_row TYPE syst_stepl DEFAULT 0
          iv_scr_field_value    TYPE simple OPTIONAL
          iv_convert_to_ext     TYPE abap_bool DEFAULT abap_false
          iv_unit               TYPE meins OPTIONAL
          iv_currency           TYPE waers OPTIONAL
        RAISING
          zcx_ca_vh_tool,

      "! <p class="shorttext synchronized" lang="en">Set default value for a selection field of value/search help</p>
      "!
      "! @parameter iv_scr_field_name     | <p class="shorttext synchronized" lang="en">Screen field name</p>
      "! @parameter iv_idx_table_ctrl_row | <p class="shorttext synchronized" lang="en">Index of the table control row (SY-STEPL) -&gt; see REGISTER...</p>
      "! @parameter iv_use_screen_val     | <p class="shorttext synchronized" lang="en">X = Use value from registered screen field</p>
      "! @parameter iv_default_value      | <p class="shorttext synchronized" lang="en">Default value for selection field</p>
      "! @raising   zcx_ca_conv           | <p class="shorttext synchronized" lang="en">Common exception: Conversion failed</p>
      "! @raising   zcx_ca_vh_tool        | <p class="shorttext synchronized" lang="en">Common exception: While calling/supporting value/search help</p>
      set_sel_field_default_value
        IMPORTING
          iv_scr_field_name     TYPE csequence
          iv_idx_table_ctrl_row TYPE syst_stepl DEFAULT 0
          iv_use_screen_val     TYPE abap_bool DEFAULT abap_true
          iv_default_value      TYPE simple OPTIONAL
        RAISING
          zcx_ca_vh_tool
          zcx_ca_conv,

      "! <p class="shorttext synchronized" lang="en">Set selection field of value help to display-only or input</p>
      "!
      "! @parameter iv_scr_field_name     | <p class="shorttext synchronized" lang="en">Screen field name</p>
      "! @parameter iv_idx_table_ctrl_row | <p class="shorttext synchronized" lang="en">Index of the table control row (SY-STEPL) -&gt; see REGISTER...</p>
      "! @parameter iv_display_only       | <p class="shorttext synchronized" lang="en">X = Set to dispaly-only; ' ' = set for input</p>
      "! @raising   zcx_ca_vh_tool        | <p class="shorttext synchronized" lang="en">Common exception: While calling/supporting value/search help</p>
      set_sel_field_display_only
        IMPORTING
          iv_scr_field_name     TYPE csequence
          iv_idx_table_ctrl_row TYPE syst_stepl DEFAULT 0
          iv_display_only       TYPE abap_bool DEFAULT abap_true
        RAISING
          zcx_ca_vh_tool,

      "! <p class="shorttext synchronized" lang="en">Set techn. value help descr. (overwrites actual descr.!)</p>
      "!
      "! @parameter is_vh_description | <p class="shorttext synchronized" lang="en">Technical description of value/search help</p>
      "! @raising   zcx_ca_vh_tool    | <p class="shorttext synchronized" lang="en">Common exception: While calling/supporting value/search help</p>
      set_technical_description
        IMPORTING
          is_vh_description TYPE shlp_descr
        RAISING
          zcx_ca_vh_tool,

      "! <p class="shorttext synchronized" lang="en">Write selected values into (all) registered screen fields</p>
      "!
      "! @parameter iv_scr_field_name  | <p class="shorttext synchronized" lang="en">Update only this screen field (if empty all registrd fields)</p>
      "! @parameter iv_convert_to_ext  | <p class="shorttext synchronized" lang="en">X = Convert value into external type of receiver field</p>
      "! @parameter iv_only_input_flds | <p class="shorttext synchronized" lang="en">X = Set only for input fields; 0 = Set also for display flds</p>
      "! @raising   zcx_ca_conv        | <p class="shorttext synchronized" lang="en">Common exception: Conversion failed</p>
      "! @raising   zcx_ca_vh_tool     | <p class="shorttext synchronized" lang="en">Common exception: While calling/supporting value/search help</p>
      write_values_into_scr_fields
        IMPORTING
          iv_scr_field_name  TYPE csequence OPTIONAL
          iv_convert_to_ext  TYPE abap_bool DEFAULT abap_true
          iv_only_input_flds TYPE abap_bool DEFAULT abap_true
        RAISING
          zcx_ca_conv
          zcx_ca_vh_tool.


* P R O T E C T E D   S E C T I O N
  PROTECTED SECTION.
*   i n s t a n c e   a t t r i b u t e s
    DATA:
*     o b j e c t   r e f e r e n c e s
      "! <p class="shorttext synchronized" lang="en">Registered screen fields</p>
      mt_scr_field_register TYPE zca_tt_dynpread,

*     s t r u c t u r e s
      "! <p class="shorttext synchronized" lang="en">Description of value/search help</p>
      ms_vh_description     TYPE shlp_descr.

*   i n s t a n c e   m e t h o d s
    METHODS:
      "! <p class="shorttext synchronized" lang="en">Convert selected value for screen field output</p>
      "!
      "! @parameter cs_registration_entry | <p class="shorttext synchronized" lang="en">Screen field registration entry</p>
      "! @raising   cx_sy_assign_error    | <p class="shorttext synchronized" lang="en">System Exception Using ASSIGN</p>
      "! @raising   zcx_ca_conv           | <p class="shorttext synchronized" lang="en">Common exception: Conversion failed</p>
      convert_value_for_scr_output
        CHANGING
          cs_registration_entry TYPE zca_s_dynpread
        RAISING
          cx_sy_assign_error
          zcx_ca_conv,

      "! <p class="shorttext synchronized" lang="en">Check if requested field is defined in value/search help</p>
      "!
      "! @parameter iv_vh_field_name | <p class="shorttext synchronized" lang="en">Field name of corresponding field in value/search help</p>
      "! @raising   zcx_ca_vh_tool   | <p class="shorttext synchronized" lang="en">Common exception: While calling/supporting value/search help</p>
      does_vh_field_name_exist
        IMPORTING
          iv_vh_field_name TYPE ddshlpsfld
        RAISING
          zcx_ca_vh_tool,

      "! <p class="shorttext synchronized" lang="en">Get screen field from registration table</p>
      "!
      "! @parameter iv_scr_field_name     | <p class="shorttext synchronized" lang="en">Screen field name</p>
      "! @parameter iv_idx_table_ctrl_row | <p class="shorttext synchronized" lang="en">Index of the table control row (SY-STEPL) -&gt; see REGISTER...</p>
      "! @parameter result                | <p class="shorttext synchronized" lang="en">Field of the current screen (with value)</p>
      "! @raising   zcx_ca_vh_tool        | <p class="shorttext synchronized" lang="en">Common exception: While calling/supporting value/search help</p>
      get_scr_field_from_register
        IMPORTING
          iv_scr_field_name     TYPE csequence
          iv_idx_table_ctrl_row TYPE syst_stepl DEFAULT 0
        RETURNING
          VALUE(result)         TYPE REF TO zca_s_dynpread
        RAISING
          zcx_ca_vh_tool,

      "! <p class="shorttext synchronized" lang="en">Get technical description of field</p>
      "!
      "! @parameter is_registration_entry | <p class="shorttext synchronized" lang="en">Screen field registration entry</p>
      "! @parameter result                | <p class="shorttext synchronized" lang="en">Technical description of screen field</p>
      "! @raising   zcx_ca_vh_tool        | <p class="shorttext synchronized" lang="en">Common exception: While calling/supporting value/search help</p>
      get_techn_field_description
        IMPORTING
          is_registration_entry TYPE zca_s_dynpread
        RETURNING
          VALUE(result)         TYPE REF TO cl_abap_datadescr
        RAISING
          zcx_ca_vh_tool,

      "! <p class="shorttext synchronized" lang="en">Get value help field name from screen field name</p>
      "!
      "! @parameter iv_scr_field_name     | <p class="shorttext synchronized" lang="en">Screen field name</p>
      "! @parameter iv_idx_table_ctrl_row | <p class="shorttext synchronized" lang="en">Index of the table control row (SY-STEPL) -&gt; see REGISTER...</p>
      "! @parameter result                | <p class="shorttext synchronized" lang="en">Field of value help</p>
      "! @raising   zcx_ca_vh_tool        | <p class="shorttext synchronized" lang="en">Common exception: While calling/supporting value/search help</p>
      get_vh_field_name_2_scr_field
        IMPORTING
          iv_scr_field_name     TYPE csequence
          iv_idx_table_ctrl_row TYPE syst_stepl DEFAULT 0
        RETURNING
          VALUE(result)         TYPE ddshlpsfld
        RAISING
          zcx_ca_vh_tool,

      "! <p class="shorttext synchronized" lang="en">Modify registration table</p>
      "!
      "! @parameter is_registration_entry | <p class="shorttext synchronized" lang="en">Screen field registration entry</p>
      "! @raising   zcx_ca_vh_tool        | <p class="shorttext synchronized" lang="en">Common exception: While calling/supporting value/search help</p>
      modify_registration
        IMPORTING
          is_registration_entry TYPE zca_s_dynpread
        RAISING
          zcx_ca_vh_tool,


      "! <p class="shorttext synchronized" lang="en">Determine exception and raise it after value help call</p>
      "!
      "! @parameter iv_return_code        | <p class="shorttext synchronized" lang="en">Return code of value help call</p>
      "! @parameter iv_result_is_supplied | <p class="shorttext synchronized" lang="en">X = VH-call-method parameter is supplied / ' '=Raise except</p>
      "! @parameter result                | <p class="shorttext synchronized" lang="en">X = Display only</p>
      "! @raising   zcx_ca_vh_tool        | <p class="shorttext synchronized" lang="en">Common exception: While calling/supporting value/search help</p>
      "! @raising   zcx_ca_ui             | <p class="shorttext synchronized" lang="en">Common exception: UI interaction messages</p>
      raise_exception_after_vh_call
        IMPORTING
          iv_return_code        TYPE syst_subrc
          iv_result_is_supplied TYPE abap_bool
        RETURNING
          VALUE(result)         TYPE abap_bool
        RAISING
          zcx_ca_vh_tool
          zcx_ca_ui,

      "! <p class="shorttext synchronized" lang="en">Transfer selected values into field registration</p>
      "!
      "! @parameter it_sel_values  | <p class="shorttext synchronized" lang="en">Description</p>
      "! @raising   zcx_ca_vh_tool | <p class="shorttext synchronized" lang="en">Common exception: While calling/supporting value/search help</p>
      transfer_sel_val_into_register
        IMPORTING
          it_sel_values TYPE dmc_ddshretval_table
        RAISING
          zcx_ca_vh_tool,

      "! <p class="shorttext synchronized" lang="en">Transfer values into techn. VH description for execution</p>
      "!
      "! @parameter it_vh_select_opt  | <p class="shorttext synchronized" lang="en">Selection options for value/search helps</p>
      "! @parameter iv_use_screen_val | <p class="shorttext synchronized" lang="en">X = Use entered value for selection screen field</p>
      "! @parameter iv_title          | <p class="shorttext synchronized" lang="en">Title for popup (overwriting standard)</p>
      "! @parameter result            | <p class="shorttext synchronized" lang="en">X = Display only</p>
      transfer_values_into_vh_descr
        IMPORTING
          it_vh_select_opt  TYPE ddshselops
          iv_use_screen_val TYPE abap_bool
          iv_title          TYPE csequence
        RETURNING
          VALUE(result)     TYPE ddshf4disp.


* P R I V A T E   S E C T I O N
  PRIVATE SECTION.


ENDCLASS.



CLASS zcl_ca_vh_tool IMPLEMENTATION.

  METHOD assign_vh_field_to_scr_field.
    "-----------------------------------------------------------------*
    "   Set corresponding value/search help field name for screen field
    "-----------------------------------------------------------------*
    "Check existence of value/search help field
    does_vh_field_name_exist( iv_vh_field_name ).

    "Set value/search help field name and modify buffer
    DATA(lr_registration_entry) = get_scr_field_from_register( iv_scr_field_name     = iv_scr_field_name
                                                               iv_idx_table_ctrl_row = iv_idx_table_ctrl_row ).
    lr_registration_entry->vh_field_name = iv_vh_field_name.
  ENDMETHOD.                    "assign_vh_field_to_scr_field


  METHOD call_f4_value_help.
    "-----------------------------------------------------------------*
    "   Call value/search help
    "-----------------------------------------------------------------*
    "Local data definitions
    DATA:
      lt_sel_values  TYPE dmc_ddshretval_table,
      lv_return_code TYPE sysubrc.       "RC of value/search help start

    TRY.
        "Only if SHLP description is set - with abap_true it raises an exception
        is_value_help_set( abap_true ).

        DATA(lv_display_only) = transfer_values_into_vh_descr( it_vh_select_opt  = it_vh_select_opt
                                                               iv_use_screen_val = iv_use_screen_val
                                                               iv_title          = iv_title ).
        "Initialize user action result
        result = abap_false.

        "Start value/search help execution => may replace this FM by FM F4IF_FIELD_VALUE_REQUEST -> see help of this
        CALL FUNCTION 'F4IF_START_VALUE_REQUEST'
          EXPORTING
            shlp          = ms_vh_description
            disponly      = lv_display_only
            maxrecords    = iv_max_hits
            multisel      = space           " No multiple selection
            cucol         = iv_pos_at_column
            curow         = iv_pos_at_row
          IMPORTING
            rc            = lv_return_code
          TABLES
            return_values = lt_sel_values.
        IF lv_return_code EQ 0.
          transfer_sel_val_into_register( lt_sel_values ).

          "Set selected values into registered screen fields
          IF iv_set_to_screen EQ abap_true.
            write_values_into_scr_fields( iv_scr_field_name  = iv_return_field
                                          iv_convert_to_ext  = iv_convert_to_ext
                                          iv_only_input_flds = iv_only_input_flds ).
          ENDIF.

        ELSE.
          result = raise_exception_after_vh_call( iv_return_code        = lv_return_code
                                                  iv_result_is_supplied = xsdbool( result IS SUPPLIED ) ).
        ENDIF.

      CATCH zcx_ca_conv INTO DATA(lx_error).
        DATA(lx_sht) = CAST zcx_ca_vh_tool( zcx_ca_error=>create_exception(
                                                              iv_excp_cls = zcx_ca_vh_tool=>c_zcx_ca_vh_tool
                                                              ix_error    = lx_error ) )  ##no_text.
        IF lx_sht IS BOUND.
          RAISE EXCEPTION lx_sht.
        ENDIF.
    ENDTRY.
  ENDMETHOD.                    "call_f4_value_help


  METHOD constructor.
    "-----------------------------------------------------------------*
    "   Constructor
    "-----------------------------------------------------------------*
    mo_vh_options = zcl_ca_c_vh_tool=>get_instance( ).

    IF iv_vh_name IS SUPPLIED.
      mo_vh_options->is_vh_type_valid( iv_vh_type ).

      "Get technical data for value/search help
      CALL FUNCTION 'F4IF_GET_SHLP_DESCR'
        EXPORTING
          shlpname = iv_vh_name
          shlptype = iv_vh_type
        IMPORTING
          shlp     = ms_vh_description.
      IF ms_vh_description IS INITIAL.
        "value/search help & does not exist
        RAISE EXCEPTION TYPE zcx_ca_vh_tool
          EXPORTING
            textid   = zcx_ca_vh_tool=>value_help_does_not_exist
            mv_msgty = c_msgty_e
            mv_msgv1 = CONV #( iv_vh_name ).
      ENDIF.
    ENDIF.

    "Set basic value for later use
    mv_progname  = iv_progname.
    mv_screen_no = iv_screen_no.
    "Get line no. in table control / step loop for access in reg. table
    GET CURSOR LINE mv_actual_table_ctrl_row.
  ENDMETHOD.                    "constructor


  METHOD convert_value_for_scr_output.
    "-----------------------------------------------------------------*
    "   Convert selected value for screen field output
    "-----------------------------------------------------------------*
    "Local data definitions
    DATA:
      lr_scr_field_value    TYPE REF TO data.

    FIELD-SYMBOLS:
      <lv_scr_field_value>  TYPE data.

    CREATE DATA lr_scr_field_value TYPE HANDLE cs_registration_entry-o_data_desc.
    ASSIGN lr_scr_field_value->* TO <lv_scr_field_value>.
    IF sy-subrc NE 0.
      RAISE EXCEPTION TYPE zcx_ca_conv.
    ENDIF.

    "Reconvert value into internal format to be able to respect e. g. conversion exits
    zcl_ca_conv=>external_2_internal(
                                EXPORTING
                                  external_value = cs_registration_entry-fieldvalue
                                IMPORTING
                                  internal_value = <lv_scr_field_value> ).

    "And now convert it into external format again
    zcl_ca_conv=>internal_2_external(
                                EXPORTING
                                  internal_value = <lv_scr_field_value>
                                IMPORTING
                                  external_value = cs_registration_entry-fieldvalue ).
  ENDMETHOD.                    "convert_value_for_scr_output


  METHOD does_vh_field_name_exist.
    "-----------------------------------------------------------------*
    "   Check if requested field is defined in value/search help
    "-----------------------------------------------------------------*
    IF iv_vh_field_name IS INITIAL.
      RETURN.
    ENDIF.

    "Only if SHLP description is set - with abap_true it raises an exception
    is_value_help_set( abap_true ).

    "Check existence of value help field in value/search help definition
    IF NOT line_exists( ms_vh_description-fieldprop[ fieldname = iv_vh_field_name ] ).
      "Field &1 is not defined in value/search help &2
      RAISE EXCEPTION TYPE zcx_ca_vh_tool
        EXPORTING
          textid   = zcx_ca_vh_tool=>value_help_field_not_exist
          mv_msgty = c_msgty_e
          mv_msgv1 = CONV #( iv_vh_field_name )
          mv_msgv2 = CONV #( ms_vh_description-shlpname ).
    ENDIF.
  ENDMETHOD.                    "does_vh_field_name_exist


  METHOD get_screen_field_entry.
    "-----------------------------------------------------------------*
    "   Get screen field (field name + value + input flag)
    "-----------------------------------------------------------------*
    DATA(lr_registration_entry) = get_scr_field_from_register( iv_scr_field_name     = iv_scr_field_name
                                                               iv_idx_table_ctrl_row = iv_idx_table_ctrl_row ).
    result = lr_registration_entry->s_dynpread.
  ENDMETHOD.                    "get_screen_field_entry


  METHOD get_screen_field_value.
    "-----------------------------------------------------------------*
    "   Get value of screen field
    "-----------------------------------------------------------------*
    TRY.
        DATA(lr_registration_entry) = get_scr_field_from_register( iv_scr_field_name     = iv_scr_field_name
                                                                   iv_idx_table_ctrl_row = iv_idx_table_ctrl_row ).

        IF iv_convert_to_int EQ abap_true.
          "Convert external into SAP internal data type
          zcl_ca_conv=>external_2_internal(
                                      EXPORTING
                                        external_value = lr_registration_entry->fieldvalue
                                      IMPORTING
                                        internal_value = ev_scr_field_value ).

        ELSE.
          ev_scr_field_value = lr_registration_entry->fieldvalue.
        ENDIF.

        "Flag, if field is open for input or only for output
        ev_is_changable = lr_registration_entry->fieldinp.

      CATCH zcx_ca_conv INTO DATA(lx_catched).
        DATA(lx_error) = CAST zcx_ca_vh_tool( zcx_ca_error=>create_exception(
                                                           iv_excp_cls = zcx_ca_vh_tool=>c_zcx_ca_vh_tool
                                                           iv_class    = 'ZCL_CA_CONV'
                                                           iv_method   = 'EXT_2_INT'
                                                           ix_error    = lx_catched ) ) ##no_text.
        IF lx_error IS BOUND.
          RAISE EXCEPTION lx_error.
        ENDIF.
    ENDTRY.
  ENDMETHOD.                    "get_screen_field_value


  METHOD get_scr_field_from_register.
    "-----------------------------------------------------------------*
    "   Get screen field from registration table
    "-----------------------------------------------------------------*
    TRY.
        "Get dynpro field and value from local registration buffer
        result = REF #( mt_scr_field_register[ fieldname = iv_scr_field_name
                                               stepl     = get_table_control_row_index( iv_idx_table_ctrl_row ) ] ).

      CATCH cx_sy_itab_line_not_found.
        "Screen field &1 is (still) not registered
        RAISE EXCEPTION TYPE zcx_ca_vh_tool
          EXPORTING
            textid   = zcx_ca_vh_tool=>screen_field_not_in_buffer
            mv_msgty = c_msgty_e
            mv_msgv1 = CONV #( iv_scr_field_name ).
    ENDTRY.
  ENDMETHOD.                    "get_scr_field_from_regtab


  METHOD get_table_control_row_index.
    "-----------------------------------------------------------------*
    "   Get table control row index to be used
    "-----------------------------------------------------------------*
    "The passed value will be preferred before the value from CONSTRUCTOR
    result = iv_idx_table_ctrl_row.
    IF result IS INITIAL.
      result = mv_actual_table_ctrl_row.
    ENDIF.
  ENDMETHOD.                    "get_table_control_row_index


  METHOD get_technical_description.
    "-----------------------------------------------------------------*
    "   Get value/search help description incl. already set values
    "-----------------------------------------------------------------*
    "Only if SHLP description is set - with ABAP_TRUE it raises an exception
    is_value_help_set( abap_true ).

    result = ms_vh_description.
  ENDMETHOD.                    "get_technical_description


  METHOD get_techn_field_description.
    "-----------------------------------------------------------------*
    "   Get technical description of field
    "-----------------------------------------------------------------*
    "Local data definitions
    DATA:
      lx_error             TYPE REF TO cx_root.

    FIELD-SYMBOLS:
      <lv_program_field>   TYPE data.

    TRY.
        "If it does not exist, complete technical description
        result ?= NEW zcl_ca_ddic( iv_name = is_registration_entry-fieldname )->mo_type_desc.

      CATCH zcx_ca_param
            zcx_ca_intern INTO lx_error.
        "Occurs if object can't be found or is no DDIC object
        TRY.
            "Use value/search help information to get technical description
            IF is_registration_entry-vh_field_name IS NOT INITIAL.
              "Get field description from value/search help definition
              DATA(lr_vh_field_descr) = REF #( ms_vh_description-fielddescr[
                                                      fieldname = is_registration_entry-vh_field_name ] OPTIONAL ).
              "Get data description of program field
              IF lr_vh_field_descr->rollname IS NOT INITIAL.
                result ?= NEW zcl_ca_ddic( iv_name = lr_vh_field_descr->rollname )->mo_type_desc.
              ENDIF.
            ENDIF.

            IF result      IS NOT BOUND   AND
               mv_progname IS NOT INITIAL.
              "Otherwise try to get the description for the program field. Field is no DDIC field - assign
              "program field and get the description via the "value".
              DATA(lv_program_field) = CONV char100( |({ mv_progname }){ is_registration_entry-fieldname }| ).
              ASSIGN (lv_program_field) TO <lv_program_field>.
              IF sy-subrc EQ 0.
                "Get data description of program field
                result ?= NEW zcl_ca_ddic( iv_data = <lv_program_field> )->mo_type_desc.
              ENDIF.
            ENDIF.

          CATCH zcx_ca_param
                zcx_ca_intern INTO lx_error.
            DATA(lx_sh_tool) = CAST zcx_ca_vh_tool( zcx_ca_error=>create_exception(
                                                              iv_excp_cls = zcx_ca_vh_tool=>c_zcx_ca_vh_tool
                                                              iv_class    = 'ZCL_CA_DDIC'
                                                              iv_method   = 'CONSTUCTOR'
                                                              ix_error    = lx_error ) ) ##no_text.
            RAISE EXCEPTION lx_sh_tool.
        ENDTRY.
    ENDTRY.
  ENDMETHOD.                    "get_techn_field_description


  METHOD get_vh_field_name_2_scr_field.
    "-----------------------------------------------------------------*
    "   Get value help field name from screen field name
    "-----------------------------------------------------------------*
    "Get value help field name
    DATA(lr_registration_entry) = get_scr_field_from_register( iv_scr_field_name     = iv_scr_field_name
                                                               iv_idx_table_ctrl_row = iv_idx_table_ctrl_row ).
    result = lr_registration_entry->vh_field_name.
    IF result IS INITIAL.
      result = lr_registration_entry->fieldname.
    ENDIF.
  ENDMETHOD.                    "get_vh_field_name_2_scr_field


  METHOD is_value_help_set.
    "-----------------------------------------------------------------*
    "   Is value/search help set?
    "-----------------------------------------------------------------*
    result = abap_false.
    IF ms_vh_description IS NOT INITIAL.
      result = abap_true.

    ELSEIF iv_raise_excep EQ abap_true.
      "No value/search help set - request not possible
      RAISE EXCEPTION TYPE zcx_ca_vh_tool
        EXPORTING
          textid   = zcx_ca_vh_tool=>no_value_help_set
          mv_msgty = c_msgty_e.
    ENDIF.
  ENDMETHOD.                    "is_value_help_set


  METHOD modify_registration.
    "-----------------------------------------------------------------*
    "   Modify registration table
    "-----------------------------------------------------------------*
    "Field name must not be empty
    IF is_registration_entry-fieldname IS INITIAL.
      "Value &1&2 of parameter &3 is invalid
      RAISE EXCEPTION TYPE zcx_ca_vh_tool
        EXPORTING
          textid   = zcx_ca_vh_tool=>param_invalid
          mv_msgty = c_msgty_e
          mv_msgv1 = 'SPACE'
          mv_msgv2 = 'IS_REGISTRATION_ENTRY-FIELDNAME' ##no_text.
    ENDIF.

    TRY.
        DATA(lr_registration_entry) =
                        get_scr_field_from_register( iv_scr_field_name     = is_registration_entry-fieldname
                                                     iv_idx_table_ctrl_row = is_registration_entry-stepl ).
        lr_registration_entry->s_dynpread = is_registration_entry-s_dynpread.

        IF lr_registration_entry->o_data_desc IS NOT BOUND.
          lr_registration_entry->o_data_desc = get_techn_field_description( is_registration_entry ).
        ENDIF.

      CATCH zcx_ca_vh_tool.
        APPEND INITIAL LINE TO mt_scr_field_register REFERENCE INTO lr_registration_entry.
        lr_registration_entry->* = is_registration_entry.

        "If it does not exist, complete technical description and other information
        lr_registration_entry->o_data_desc = get_techn_field_description( is_registration_entry ).
        lr_registration_entry->stepl       = get_table_control_row_index( is_registration_entry-stepl ).

        "If no program and screen was set, e. g. to call only a value help
        "without connection to a screen, set input to true
        IF mv_progname  IS INITIAL AND
           mv_screen_no IS INITIAL.
          lr_registration_entry->fieldinp = abap_true.
        ENDIF.
    ENDTRY.
  ENDMETHOD.                    "modify_scr_field_in_regtab


  METHOD raise_exception_after_vh_call.
    "-----------------------------------------------------------------*
    "   Determine exception and raise it after value help call
    "-----------------------------------------------------------------*
    CASE iv_return_code.
      WHEN 4.
        "No data to match this selection - make a new entry
        RAISE EXCEPTION TYPE zcx_ca_ui
          EXPORTING
            textid   = zcx_ca_ui=>no_values_found
            mv_msgty = c_msgty_w.

      WHEN 8.
        "User cancelled selection popup or selection list
        IF iv_result_is_supplied EQ abap_true.
          result = abap_true.
        ELSE.
          "Action was cancelled
          RAISE EXCEPTION TYPE zcx_ca_ui
            EXPORTING
              textid   = zcx_ca_ui=>canc_by_user
              mv_msgty = c_msgty_w.
        ENDIF.

      WHEN 12.
        "Fatal error occurred while calling value/search help &1
        RAISE EXCEPTION TYPE zcx_ca_vh_tool
          EXPORTING
            textid   = zcx_ca_vh_tool=>fatal_err_value_help_call
            mv_msgty = c_msgty_e
            mv_msgv1 = CONV #( ms_vh_description-shlpname ).
    ENDCASE.
  ENDMETHOD.                    "raise_exception_after_vh_call


  METHOD read_field_values_from_screen.
    "-----------------------------------------------------------------*
    "   Get current values from screen for registered fields
    "-----------------------------------------------------------------*
    "Local data definitions
    DATA:
      lt_dynpro_fields     TYPE dynpread_tabtype.

    mo_vh_options->is_selection_type_valid( iv_selection_type ).

    "Copy values for function module
    LOOP AT mt_scr_field_register REFERENCE INTO DATA(lr_registration_entry).
      APPEND lr_registration_entry->s_dynpread TO lt_dynpro_fields.
    ENDLOOP.

    "Get values from screen for registered fields
    CALL FUNCTION 'DYNP_VALUES_READ'
      EXPORTING
        dyname               = mv_progname
        dynumb               = mv_screen_no
        request              = iv_selection_type
      TABLES
        dynpfields           = lt_dynpro_fields
      EXCEPTIONS
        invalid_abapworkarea = 1
        invalid_dynprofield  = 2
        invalid_dynproname   = 3
        invalid_dynpronummer = 4
        invalid_request      = 5
        no_fielddescription  = 6
        invalid_parameter    = 7
        undefind_error       = 8
        double_conversion    = 9
        stepl_not_found      = 10
        OTHERS               = 11.
    IF sy-subrc NE 0.
      "Send error message of function module or common information
      DATA(lx_error) = CAST zcx_ca_vh_tool( zcx_ca_error=>create_exception(
                                                            iv_excp_cls = zcx_ca_vh_tool=>c_zcx_ca_vh_tool
                                                            iv_function = 'DYNP_VALUES_READ'
                                                            iv_subrc    = sy-subrc ) ) ##no_text.
      IF lx_error IS BOUND.
        RAISE EXCEPTION lx_error.
      ENDIF.

    ELSE.
      "Modify registered fields from dynpro values
      LOOP AT lt_dynpro_fields REFERENCE INTO DATA(lr_dynpro_field).
        TRY.
            lr_registration_entry = get_scr_field_from_register( lr_dynpro_field->fieldname ).
            lr_registration_entry->fieldvalue = lr_dynpro_field->fieldvalue.

          CATCH zcx_ca_vh_tool.
            CONTINUE.
        ENDTRY.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.                    "read_field_values_from_screen


  METHOD register_screen_field.
    "-----------------------------------------------------------------*
    "   Add / register screen field
    "-----------------------------------------------------------------*
    IF ms_vh_description IS NOT INITIAL AND
       iv_vh_field_name  IS NOT INITIAL.
      "Check existence of value/search help field, if it is set
      does_vh_field_name_exist( iv_vh_field_name ).
    ENDIF.

    "Set screen field name and add it to buffer
    modify_registration( is_registration_entry = VALUE #( fieldname     = iv_scr_field_name
                                                          vh_field_name = iv_vh_field_name
                                                          stepl         = iv_idx_table_ctrl_row
                                                    "Set field generally for input. In case of using method GET_VALUES_
                                                    "FROM_SCR_FIELDS this value will be overwritten.
                                                          fieldinp      = abap_true ) ).
  ENDMETHOD.                    "register_screen_field


  METHOD set_dialog_type.
    "-----------------------------------------------------------------*
    "   Set dialog type for value/search help
    "-----------------------------------------------------------------*
    "Only if SHLP description is set - with abap_true it raises an exception
    is_value_help_set( abap_true ).

    mo_vh_options->is_dialog_type_valid( iv_dialog_type ).

    "Set dialog type only if it is no collective value/search help
    IF ms_vh_description-intdescr-issimple EQ abap_false.
      "Dialog type & meaningless for a collective value/search help
      RAISE EXCEPTION TYPE zcx_ca_vh_tool
        EXPORTING
          textid   = zcx_ca_vh_tool=>dialog_type_meaningless
          mv_msgty = c_msgty_e
          mv_msgv1 = CONV #( iv_dialog_type ).

    ELSE.
      ms_vh_description-intdescr-dialogtype = iv_dialog_type.
    ENDIF.
  ENDMETHOD.                    "set_dialog_type


  METHOD set_screen_field_value.
    "-----------------------------------------------------------------*
    "   Set screen field value
    "-----------------------------------------------------------------*
    "In some cases additional values should be supplied in the screen after the selection was made.
    "Typically these fields are not registered because they have no direct connection to a search help
    "and so are normally not needed. The following behavior should support that those additional Fields
    "must not explicitly registered and ease up developers life.
    register_screen_field( iv_scr_field_name     = iv_scr_field_name
                           iv_idx_table_ctrl_row = iv_idx_table_ctrl_row ).
    DATA(ls_registration_entry) = get_screen_field_entry( iv_scr_field_name     = iv_scr_field_name
                                                          iv_idx_table_ctrl_row = iv_idx_table_ctrl_row ).

    "Convert value to external format
    CASE iv_convert_to_ext.
      WHEN abap_false.
        ls_registration_entry-fieldvalue = iv_scr_field_value.

      WHEN abap_true.
        TRY.
            "Convert SAP internal into external data type
            zcl_ca_conv=>internal_2_external(
                                       EXPORTING
                                         internal_value  = iv_scr_field_value
                                         unit_of_measure = iv_unit
                                         currency        = iv_currency
                                       IMPORTING
                                         external_value  = ls_registration_entry-fieldvalue ).

          CATCH zcx_ca_error INTO DATA(lx_catched).
            DATA(lx_error) = CAST zcx_ca_vh_tool(
                                      zcx_ca_error=>create_exception(
                                                       iv_excp_cls = zcx_ca_vh_tool=>c_zcx_ca_vh_tool
                                                       iv_class    = 'ZCL_CA_CONV'
                                                       iv_method   = 'INTERNAL_2_EXTERNAL'
                                                       ix_error    = lx_catched ) ) ##no_text.
            IF lx_error IS BOUND.
              RAISE EXCEPTION lx_error.
            ENDIF.
        ENDTRY.
    ENDCASE.

    "Transfer new screen field value to table
    modify_registration( CORRESPONDING #( ls_registration_entry ) ).
  ENDMETHOD.                    "set_screen_field_value


  METHOD set_sel_field_default_value.
    "-----------------------------------------------------------------*
    "   Set default value for a selection field of value/search help
    "-----------------------------------------------------------------*
    "Local data definitions
    DATA:
      lv_default_value     TYPE ddshvalue.

    IF iv_default_value  IS INITIAL AND
       iv_use_screen_val EQ abap_false.
      RETURN.
    ENDIF.

    "Only if SHLP description is set - with abap_true it raises an exception
    is_value_help_set( abap_true ).

    IF iv_default_value IS NOT INITIAL.
      lv_default_value = iv_default_value.

    ELSEIF iv_use_screen_val EQ abap_true.
      DATA(lr_registration_entry) = get_scr_field_from_register( iv_scr_field_name     = iv_scr_field_name
                                                                 iv_idx_table_ctrl_row = iv_idx_table_ctrl_row ).
      lv_default_value = lr_registration_entry->fieldvalue.
    ENDIF.

    "Modify select-options of value/search help
    DATA(lo_sel_options) = zcl_ca_c_sel_options=>get_instance( ).
    APPEND VALUE #( shlpname  = ms_vh_description-shlpname
                    shlpfield = iv_scr_field_name
                    sign      = lo_sel_options->sign-incl
                    option    = COND #( WHEN lv_default_value CA '*+'
                                          THEN lo_sel_options->option-cp
                                          ELSE lo_sel_options->option-eq )
                    low       = lv_default_value )                         TO ms_vh_description-selopt.
  ENDMETHOD.                    "set_sel_field_default_value


  METHOD set_sel_field_display_only.
    "-----------------------------------------------------------------*
    "   Set selection field of value/search help to display-only or input
    "-----------------------------------------------------------------*
    "Only if SHLP description is set - with abap_true it raises an exception
    is_value_help_set( abap_true ).

    "Set value and modify properties
    DATA(lv_vh_field_name) = CONV fieldname( get_vh_field_name_2_scr_field( iv_scr_field_name ) ).
    MODIFY ms_vh_description-fieldprop FROM VALUE #( shlpseldis = iv_display_only      "set input with opposite value
                                                     shlpinput  = xsdbool( iv_display_only EQ abap_false ) )
                                       TRANSPORTING shlpseldis  shlpinput
                                       WHERE fieldname EQ lv_vh_field_name.
    IF sy-subrc NE 0.
      "Field &1 is not defined in value/search help &2
      RAISE EXCEPTION TYPE zcx_ca_vh_tool
        EXPORTING
          textid   = zcx_ca_vh_tool=>value_help_field_not_exist
          mv_msgty = c_msgty_e
          mv_msgv1 = CONV #( iv_scr_field_name )
          mv_msgv2 = CONV #( ms_vh_description-shlpname ).
    ENDIF.
  ENDMETHOD.                    "set_sel_field_display_only


  METHOD set_technical_description.
    "-----------------------------------------------------------------*
    "   Set value/search help description (overwrites actual description!)
    "-----------------------------------------------------------------*
    "Only if SHLP description is set - with abap_true it raises an exception
    is_value_help_set( abap_true ).

    ms_vh_description = is_vh_description.
  ENDMETHOD.                    "set_technical_description


  METHOD transfer_sel_val_into_register.
    "-----------------------------------------------------------------*
    "   Transfer selected values into field registration
    "-----------------------------------------------------------------*
    LOOP AT mt_scr_field_register REFERENCE INTO DATA(lr_registration_entry).
      "Get selected value
      DATA(lr_sel_value) = REF #( it_sel_values[ shlpname  = ms_vh_description-shlpname
                                                 fieldname = lr_registration_entry->vh_field_name ] OPTIONAL ).
      IF lr_sel_value IS NOT BOUND.
        CONTINUE.
      ENDIF.

      "Transfer new screen field value to buffer
      lr_registration_entry->fieldvalue = lr_sel_value->fieldval.
    ENDLOOP.
  ENDMETHOD.                    "transfer_sel_val_into_register


  METHOD transfer_values_into_vh_descr.
    "-----------------------------------------------------------------*
    "   Transfer settings into techn. VH description for execution
    "-----------------------------------------------------------------*
    result = abap_true.
    LOOP AT mt_scr_field_register REFERENCE INTO DATA(lr_registration_entry).
      "If one of the screen fields is for input, set DISPLAY_ONLY (= RESULT) to FALSE.
      IF lr_registration_entry->fieldinp EQ abap_true.
        result = abap_false.
      ENDIF.

      "The FM F4IF_START_VALUE_REQUEST don't like it if it gets no return field.
      "Therefore we set here the used return field name as artificial return field.
      DATA(ls_sh_iface) = VALUE ddshiface( valtabname = ms_vh_description-intdescr-selmethod
                                           valfield   = lr_registration_entry->fieldname ).

      CASE iv_use_screen_val.
        WHEN abap_true.
          ls_sh_iface-value = lr_registration_entry->fieldvalue.
          MODIFY ms_vh_description-interface FROM ls_sh_iface
                                             TRANSPORTING valtabname  valfield  value
                                             WHERE shlpfield EQ lr_registration_entry->vh_field_name.

        WHEN OTHERS.
          MODIFY ms_vh_description-interface FROM ls_sh_iface
                                             TRANSPORTING valtabname  valfield
                                             WHERE shlpfield EQ lr_registration_entry->vh_field_name.
      ENDCASE.
    ENDLOOP.

    "Append external prepared selections
    APPEND LINES OF it_vh_select_opt TO ms_vh_description-selopt.

    "Set title if filled
    IF iv_title IS NOT INITIAL.
      ms_vh_description-intdescr-title = iv_title.
    ENDIF.
  ENDMETHOD.                    "transfer_values_into_vh_descr


  METHOD write_values_into_scr_fields.
    "-----------------------------------------------------------------*
    "   Wwrite values into (all) registered screen fields
    "-----------------------------------------------------------------*
    "Local data definitions
    DATA:
      lt_dynpro_fields      TYPE dynpread_tabtype.

    "Copy registered fields in table for function module
    LOOP AT mt_scr_field_register REFERENCE INTO DATA(lr_registration_entry).
      "Skip "output only" fields
      IF iv_only_input_flds              EQ abap_true  AND
         lr_registration_entry->fieldinp EQ abap_false.
        CONTINUE.
      ENDIF.

      "If field name is given then skip any other field
      IF iv_scr_field_name                IS NOT INITIAL       AND
         lr_registration_entry->fieldname NE iv_scr_field_name.
        CONTINUE.
      ENDIF.

      "Convert SAP internal into external data type
      IF iv_convert_to_ext EQ abap_true.
        TRY.
            convert_value_for_scr_output(
                                   CHANGING
                                     cs_registration_entry = lr_registration_entry->* ).

          CATCH cx_sy_assign_error
                zcx_ca_conv.
            CONTINUE.
        ENDTRY.
      ENDIF.

      APPEND lr_registration_entry->s_dynpread TO lt_dynpro_fields.
    ENDLOOP.

    "Set values of registered fields into screen fields
    CALL FUNCTION 'DYNP_VALUES_UPDATE'
      EXPORTING
        dyname               = mv_progname
        dynumb               = mv_screen_no
      TABLES
        dynpfields           = lt_dynpro_fields
      EXCEPTIONS
        invalid_abapworkarea = 1
        invalid_dynprofield  = 2
        invalid_dynproname   = 3
        invalid_dynpronummer = 4
        invalid_request      = 5
        no_fielddescription  = 6
        undefind_error       = 7
        OTHERS               = 8.
    IF sy-subrc NE 0.
      "Send error message of function module or common information
      DATA(lx_error) = CAST zcx_ca_vh_tool( zcx_ca_error=>create_exception(
                                                              iv_excp_cls = zcx_ca_vh_tool=>c_zcx_ca_vh_tool
                                                              iv_function = 'DYNP_VALUES_UPDATE'
                                                              iv_subrc    = sy-subrc ) ) ##no_text.
      IF lx_error IS BOUND.
        RAISE EXCEPTION lx_error.
      ENDIF.
    ENDIF.
  ENDMETHOD.                    "write_values_into_scr_fields

ENDCLASS.
