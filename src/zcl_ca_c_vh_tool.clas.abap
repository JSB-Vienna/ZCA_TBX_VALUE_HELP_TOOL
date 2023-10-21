"! <p class="shorttext synchronized" lang="en">CA-TBX: Constants and value checks for value help tool</p>
CLASS zcl_ca_c_vh_tool DEFINITION PUBLIC
                                  FINAL
                                  CREATE PRIVATE.
* P U B L I C   S E C T I O N
  PUBLIC SECTION.
*   c o n s t a n t s
    CONSTANTS:
      "! <p class="shorttext synchronized" lang="en">Value help dialog types</p>
      BEGIN OF dialog_type,
        "! <p class="shorttext synchronized" lang="en">Value help dialog type: Is a collective value help </p>
        collective        TYPE ddshdiatyp VALUE space ##no_text,
        "! <p class="shorttext synchronized" lang="en">Value help dialog type: Display values immediately</p>
        immediate_display TYPE ddshdiatyp VALUE 'D' ##no_text,
        "! <p class="shorttext synchronized" lang="en">Value help dialog type: Dialog with value restrictions</p>
        with_restrictions TYPE ddshdiatyp VALUE 'C' ##no_text,
        "! <p class="shorttext synchronized" lang="en">Value help dialog type: Dialog depends on set of values</p>
        set_of_value      TYPE ddshdiatyp VALUE 'A' ##no_text,
      END OF dialog_type,

      "! <p class="shorttext synchronized" lang="en">Selection types which screen fields should be read</p>
      BEGIN OF selection_type,
        "! <p class="shorttext synchronized" lang="en">Selection type: Only those fields that are registered</p>
        only_defined_scr_flds TYPE char1 VALUE space ##no_text,
        "! <p class="shorttext synchronized" lang="en">Selection type: All screen flds. independent of display-only</p>
        all_screen_fields     TYPE char1 VALUE 'A' ##no_text,
      END OF selection_type,

      "! <p class="shorttext synchronized" lang="en">Value help types</p>
      BEGIN OF vh_type,
        "! <p class="shorttext synchronized" lang="en">Value help  type: Calendar help</p>
        calendar               TYPE ddshlptyp VALUE 'CA' ##no_text,
        "! <p class="shorttext synchronized" lang="en">Value help  type: Check table</p>
        check_table            TYPE ddshlptyp VALUE 'CH' ##no_text,
        "! <p class="shorttext synchronized" lang="en">Value help  type: Check table with text table</p>
        check_table_w_texts    TYPE ddshlptyp VALUE 'CT' ##no_text,
        "! <p class="shorttext synchronized" lang="en">Value help  type: Fixed values for domains</p>
        fixed_values           TYPE ddshlptyp VALUE 'FV' ##no_text,
        "! <p class="shorttext synchronized" lang="en">Value help  type: Fixed values from flow logic</p>
        fixed_values_flowlogic TYPE ddshlptyp VALUE 'DV' ##no_text,
        "! <p class="shorttext synchronized" lang="en">Value help  type: Internal Table</p>
        internal_table         TYPE ddshlptyp VALUE 'IN' ##no_text,
        "! <p class="shorttext synchronized" lang="en">Value help  type: Matchcode</p>
        matchcode              TYPE ddshlptyp VALUE 'MC' ##no_text,
        "! <p class="shorttext synchronized" lang="en">Value help  type: Matchcode ID</p>
        matchcode_id           TYPE ddshlptyp VALUE 'MI' ##no_text,
        "! <p class="shorttext synchronized" lang="en">Value help  type: Value help </p>
        search_help            TYPE ddshlptyp VALUE 'SH' ##no_text,
        "! <p class="shorttext synchronized" lang="en">Value help  type: Value help  for data element (temporary)</p>
        for_data_element       TYPE ddshlptyp VALUE 'SR' ##no_text,
        "! <p class="shorttext synchronized" lang="en">Value help  type: Time help</p>
        time                   TYPE ddshlptyp VALUE 'CL' ##no_text,
      END OF vh_type.

*   s t a t i c   m e t h o d s
    CLASS-METHODS:
      "! <p class="shorttext synchronized" lang="en">Get instance</p>
      "!
      "! @parameter result | <p class="shorttext synchronized" lang="en">Class instance</p>
      get_instance
        RETURNING
          VALUE(result) TYPE REF TO zcl_ca_c_vh_tool.

*   i n s t a n c e   m e t h o d s
    METHODS:
      "! <p class="shorttext synchronized" lang="en">Valid value help dialog type passed?</p>
      "!
      "! @parameter dialog_type    | <p class="shorttext synchronized" lang="en">Value help dialog type</p>
      "! @raising   zcx_ca_vh_tool | <p class="shorttext synchronized" lang="en">Common exception: While calling/supporting search/value help</p>
      is_dialog_type_valid
        IMPORTING
          dialog_type TYPE ddshdiatyp
        RAISING
          zcx_ca_vh_tool,

      "! <p class="shorttext synchronized" lang="en">Valid selection type passed?</p>
      "!
      "! @parameter selection_type | <p class="shorttext synchronized" lang="en">Selection type</p>
      "! @raising   zcx_ca_vh_tool | <p class="shorttext synchronized" lang="en">Common exception: While calling/supporting search/value help</p>
      is_selection_type_valid
        IMPORTING
          selection_type TYPE char1
        RAISING
          zcx_ca_vh_tool,

      "! <p class="shorttext synchronized" lang="en">Valid value help type passed?</p>
      "!
      "! @parameter vh_type        | <p class="shorttext synchronized" lang="en">Value help type</p>
      "! @raising   zcx_ca_vh_tool | <p class="shorttext synchronized" lang="en">Common exception: While calling/supporting search/value help</p>
      is_vh_type_valid
        IMPORTING
          vh_type TYPE ddshlptyp
        RAISING
          zcx_ca_vh_tool.


* P R I V A T E   S E C T I O N
  PRIVATE SECTION.
*   s t a t i c   a t t r i b u t e s
    CLASS-DATA:
*     o b j e c t   r e f e r e n c e s
      "! <p class="shorttext synchronized" lang="en">Instance of the class itself</p>
      singleton_instance     TYPE REF TO zcl_ca_c_vh_tool.

*   i n s t a n c e   m e t h o d s
    METHODS:
      "! <p class="shorttext synchronized" lang="en">Check value against fixed_values</p>
      "!
      "! @parameter value          | <p class="shorttext synchronized" lang="en">Value under test</p>
      "! @parameter param_name     | <p class="shorttext synchronized" lang="en">Name of field/parameter for output in error message</p>
      "! @raising   zcx_ca_vh_tool | <p class="shorttext synchronized" lang="en">Common exception: While calling/supporting search/value help</p>
      check_against_fixed_values
        IMPORTING
          value      TYPE simple
          param_name TYPE csequence
        RAISING
          zcx_ca_vh_tool.

ENDCLASS.



CLASS ZCL_CA_C_VH_TOOL IMPLEMENTATION.


  METHOD check_against_fixed_values.
    "-----------------------------------------------------------------*
    "   Check value against fixed_values
    "-----------------------------------------------------------------*
    TRY.
        NEW zcl_ca_ddic( iv_data       = value
                         iv_param_name = param_name )->check_fixed_values( iv_value       = value
                                                                           iv_raise_excep = abap_true ).

      CATCH zcx_ca_param INTO DATA(catched).
        DATA(error) = CAST zcx_ca_log( zcx_ca_intern=>create_exception(
                                                           iv_excp_cls = zcx_ca_log=>c_zcx_ca_log
                                                           iv_class    = 'ZCL_CA_DDIC'
                                                           iv_method   = 'CHECK_FIXED_VALUE'
                                                           ix_error    = catched ) ) ##no_text.
        IF error IS BOUND.
          RAISE EXCEPTION error.
        ENDIF.
    ENDTRY.
  ENDMETHOD.                    "check_against_fixed_values


  METHOD get_instance.
    "-----------------------------------------------------------------*
    "   Get instance
    "-----------------------------------------------------------------*
    IF zcl_ca_c_vh_tool=>singleton_instance IS NOT BOUND.
      zcl_ca_c_vh_tool=>singleton_instance = NEW #( ).
    ENDIF.

    result = zcl_ca_c_vh_tool=>singleton_instance.
  ENDMETHOD.                    "get_instance


  METHOD is_dialog_type_valid.
    "-----------------------------------------------------------------*
    "   Valid value help dialog type passed?
    "-----------------------------------------------------------------*
    check_against_fixed_values( value      = dialog_type
                                param_name = 'DIALOG_TYPE' ) ##no_text.
  ENDMETHOD.                    "is_dialog_type_valid


  METHOD is_selection_type_valid.
    "-----------------------------------------------------------------*
    "   Valid selection type passed?
    "-----------------------------------------------------------------*
    IF selection_type NE me->selection_type-only_defined_scr_flds AND
       selection_type NE me->selection_type-all_screen_fields.
      "Parameter '&1' has invalid value '&2'
      RAISE EXCEPTION TYPE zcx_ca_vh_tool
        EXPORTING
          textid   = zcx_ca_vh_tool=>param_invalid
          mv_msgty = zcx_ca_vh_tool=>c_msgty_e
          mv_msgv1 = CONV #( selection_type ).
    ENDIF.
  ENDMETHOD.                    "is_selection_type_valid


  METHOD is_vh_type_valid.
    "-----------------------------------------------------------------*
    "   Valid value help type passed?
    "-----------------------------------------------------------------*
    check_against_fixed_values( value      = vh_type
                                param_name = 'VH_TYPE' ) ##no_text.
  ENDMETHOD.                    "is_vh_type_valid
ENDCLASS.
