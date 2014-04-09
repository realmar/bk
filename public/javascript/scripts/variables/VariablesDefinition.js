//  --
//  programm variables

var ws_path = "ws://banshee.ethz.ch:3003/ws";
var ajax_path = "http://banshee.ethz.ch:3000";
var programm_handler;

//  --
//  template variables

var apply_changes_tpl = '<p class="' + MSG_USER + ' ' + CHAG_CONT + '">You Changed the Content to Apply the changes <span class="mark_orange">(colored orange)</span> press Save</p>';
var no_connection_err_tpl = '<p class="' + MSG_ERRORS + ' ' + NO_CONN_ERROR + '">ERROR: conn_err<br>Could not connect to Server, it seems that you are Offline<br>Check you Internet Connection</p>';
var no_conn_save_err_tpl = '<p class="' + MSG_ERRORS + ' ' + NO_CONN_SAVE_ERR + '>ERROR: conn_err<br>Could not save your Data because you are Offline<br>Check your Internet Connection and Try Again</p>';
var dom_double_data_entry_tpl = '<p class="' + MSG_ERRORS + ' ' + DBL_DATA + '>ERROR: dbl_data<br>You assigned a Username to at least to Doors<br>A User can only be assigned to one Door</p>';
