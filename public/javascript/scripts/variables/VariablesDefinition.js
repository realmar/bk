
/////////////////////////////////////////////////////////
//  Project Name:     BuecherkastenBibliothek BK
//  Author:           Anastassios Martakos
//  Language:         English / JavaScript
//  Created For / At: ETH Zuerich Department Physics
/////////////////////////////////////////////////////////

//  --
//  programm variables

var ws_path   = "<WS_PROTOCOL>://<HOSTNAME>:<BK_PORT>/ws";
var ajax_path = "<AJAX_PROTOCOL>://<HOSTNAME>:<BK_PORT>";
var programm_handler;

//  --
//  template variables

var apply_changes_tpl         = '<p class="' + MSG_USER + ' ' + CHAG_CONT + ' ' + AH_MESSAGE + '">You Changed the Content to Apply the changes <span class="mark_orange">(colored orange)</span> press Save</p>';
var no_connection_err_tpl     = '<p class="' + MSG_ERRORS + ' ' + NO_CONN_ERROR + ' ' + AH_ERROR + '">Could not connect to Server, it seems that you are offline, check you Internet Connection</p>';
var no_conn_save_err_tpl      = '<p class="' + MSG_ERRORS + ' ' + NO_CONN_SAVE_ERR + ' ' + AH_ERROR + '">ERROR: conn_err<br>Could not save your Data because you are Offline<br>Check your Internet Connection and Try Again</p>';
var dom_double_data_entry_tpl = '<p class="' + MSG_USER + ' ' + DBL_DATA + ' ' + AH_MESSAGE + '">There is Data which exists at least twice, if you think this is wrong, check your Input</p>';
var open_doors_tpl            = '<p class="' + MSG_USER + ' ' + OPN_DOORS + ' ' + AH_MESSAGE + '">Opening Door(s) please hold on ...</p>';
