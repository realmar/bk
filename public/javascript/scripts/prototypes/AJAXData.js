function AJAXRequest(ajax_path_arg) {
    var ajax_path = ajax_path_arg;
}

function AJAXGetData(action, send_type) {
    $.ajax({
        url: this.ajax_path + "/" + action,
        type: send_type
    })
    .done(AJAXDone(msg_data))
    .fail(AJAXFail());
}

function AJAXDone(msg_data) {
    var recv_action = new ActionHandler(JSON.parse(msg_data));
    recv_action.ProcessAction();
}

function AJAXFail() {
}