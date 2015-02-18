
/////////////////////////////////////////////////////////
//  Project Name:     BuecherkastenBibliothek BK
//  Author:           Anastassios Martakos
//  Language:         English / JavaScript
//  Created For / At: ETH Zuerich Department Physics
/////////////////////////////////////////////////////////

//  --
//  program variables

var ws_path   = "wss://" + window.location.hostname + ":443/ws";
var ajax_path = "https://" + window.location.hostname + ":443";
var program_handler;

//  --
//  template variables

var apply_changes_tpl         = '<p class="' + MSG_USER + ' ' + CHAG_CONT + ' ' + AH_MESSAGE + '">You changed the content. To Apply the changes <span class="mark_orange">(colored orange)</span> press Save</p>';
var no_connection_err_tpl     = '<p class="' + MSG_ERRORS + ' ' + NO_CONN_ERROR + ' ' + AH_ERROR + '">Could not connect to server, it seems that you are offline, check you internet connection</p>';
var no_conn_save_err_tpl      = '<p class="' + MSG_ERRORS + ' ' + NO_CONN_SAVE_ERR + ' ' + AH_ERROR + '">ERROR: conn_err<br>Could not save your data because you are offline<br>check your internet connection and try again</p>';
var dom_double_data_entry_tpl = '<p class="' + MSG_USER + ' ' + DBL_DATA + ' ' + AH_MESSAGE + '">There are users assigned at least twice, if you think this is wrong, check your Input</p>';
var open_doors_tpl            = '<p class="' + MSG_USER + ' ' + OPN_DOORS + ' ' + AH_MESSAGE + '">Opening Door(s) please hold on ...</p>';
