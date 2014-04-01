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
        .done(function (msg_data) {
            AJAXDone(msg_data);
        })
        .fail(AJAXFail());
    }
    
    function AJAXDone(msg_data) {
        var recv_action = new ActionHandler(JSON.parse(msg_data));
        recv_action.ProcessAction();
    }
    
    function AJAXFail() {
    }
}
