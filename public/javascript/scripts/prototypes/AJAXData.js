function AJAXRequest(ajax_path_arg) {
    this.ajax_path = ajax_path_arg;

    this.AJAXGetData = AJAXGetData;
    this.AJAXDone = AJAXDone;
    this.AJAXFail = AJAXFail;

    function AJAXGetData(action, send_type) {
        $.ajax({
            url: this.ajax_path + "/" + action,
            type: send_type
        })
        .done(function (msg_data) { AJAXDone(msg_data); })
        .fail(function (e) { AJAXFail(e); });
    }
    
    function AJAXDone(msg_data) {
        var recv_action = new ActionHandler(JSON.parse(msg_data));
        recv_action.ProcessAction();
        recv_action = null;
        if($("." + NO_CONN_ERROR).length > 0) {
            $("." + NO_CONN_ERROR).remove();
        }
    }
    
    function AJAXFail(e) {
        if($("." + NO_CONN_ERROR).length <= 0) {
            AddMessageData($("div#msg_errors"), no_connection_err_tpl);
            $("div#msg_errors").removeClass("display_none");
        }
    }
}
