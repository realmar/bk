function AJAXRequest(ajax_path_arg) {
    this.ajax_path = ajax_path_arg;

    this.AJAXGetData = AJAXGetData;
    this.AJAXDone = AJAXDone;
    this.AJAXFail = AJAXFail;

    function AJAXGetData(action, msg_data_arg, send_type) {
        $.ajax({
            url: this.ajax_path + "/" + action + "?msg_data=" + msg_data_arg,
            type: send_type,
            cache: false
        })
        .done(function (msg_data) { AJAXDone(msg_data, send_type); })
        .fail(function (e) { AJAXFail(e, send_type); });
    }
    
    function AJAXDone(msg_data, send_type) {
        var recv_action = new ActionHandler(JSON.parse(msg_data));
        recv_action.ProcessAction();
        recv_action = null;
        RemoveMessageData($("." + NO_CONN_ERROR));
        if(send_type == ACTION_SAVEDATA && $("." + NO_CONN_SAVE_ERR).length > 0) {
            RemoveMessageData($("." + NO_CONN_SAVE_ERR));
        }
    }
    
    function AJAXFail(e, send_type) {
        if($("." + NO_CONN_ERROR).length <= 0) {
            AddMessageData($("div#msg_errors"), no_connection_err_tpl);
            if(send_type == ACTION_SAVEDATA) {
                AddMessageData($("div#msg_errors"), no_conn_save_err_tpl);
            }
            $("div#msg_errors").removeClass("display_none");
        }
        HideLoadingMessage();
    }
}
