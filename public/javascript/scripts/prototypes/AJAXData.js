
/////////////////////////////////////////////////////////
//  Project Name:     BuecherkastenBibliothek BK
//  Author:           Anastassios Martakos
//  Language:         English / JavaScript
//  Created For / At: ETH Zuerich Department Physics
/////////////////////////////////////////////////////////

//  Description
//  
//  Makes an AJAX Request and gives the answer to the ActionHandler
//
//  Synopsis
//
//  var ajax_request = new AJAXRequest(ajax_path);
//  var ajax_request_answer = ajax_request.AJAXGetData("ahrefresh", "null", "GET");

function AJAXRequest(ajax_path_arg) {
    this.ajax_path = ajax_path_arg;  //  URL for AJAX Requests

    this.AJAXGetData = AJAXGetData;  //  Method to requests Data form the Server
    this.AJAXDone    = AJAXDone;     //  Method which is called when a AJAX Request is successfully completed
    this.AJAXFail    = AJAXFail;     //  Method which is called when a AJAX Request is not successfully completed

    function AJAXGetData(action, msg_data_arg, send_type) {  //  Requests Data from the Server
        $.ajax({
            url: this.ajax_path + "/" + action + "?msg_data=" + msg_data_arg,
            type: send_type,
            cache: false
        })
        .done(function (msg_data) { AJAXDone(msg_data, send_type); })
        .fail(function (e) { AJAXFail(e, send_type); });
    }
    
    function AJAXDone(msg_data, send_type) {  //  Gives the received to Data to the ActionHandler by Initializing an ActionHandler with the received Data
        var recv_action = new ActionHandler(JSON.parse(msg_data));
        recv_action.ProcessAction();
        recv_action = null;
        RemoveMessageData($("." + NO_CONN_ERROR));
        if(send_type == ACTION_SAVEDATA && $("." + NO_CONN_SAVE_ERR).length > 0) {
            RemoveMessageData($("." + NO_CONN_SAVE_ERR));
        }
        program_handler.intervals_collector.UpgradeInterval('bk_ajax_data_refresh', false);
        program_handler.intervals_collector.ResetCounter('bk_ajax_data_refresh');
    }
    
    function AJAXFail(e, send_type) {  //  Shows an Error Message that it could not get Data from the Server
        if($("div#msg_errors_const > p." + NO_CONN_ERROR).length <= 0) {
            AddMessageData($("div#msg_errors_const"), no_connection_err_tpl, PREPEND);
            if(send_type == ACTION_SAVEDATA) {
                AddMessageData($("div#msg_errors_const"), no_connection_err_tpl, APPEND);
            }
            program_handler.intervals_collector.UpgradeInterval('bk_ajax_data_refresh', true);
        }
        HideLoadingMessage();
    }
}
