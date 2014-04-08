function RefreshConnectionType(connection_type) {
    switch(connection_type) {
        case CONN_TYPE_AJAX:
            $("p#connection_type_ajax").removeClass(DISPLAY_NONE);
            $("p#connection_type_websockets").addClass(DISPLAY_NONE);
            break;
        case CONN_TYPE_WEBSOCKETS:
            $("p#connection_type_ajax").addClass(DISPLAY_NONE);
            $("p#connection_type_websockets").removeClass(DISPLAY_NONE);
            break;
    }
}

function AddMessageData(dom_object, message) {
    dom_object.append(message);
}

function CheckMSGDataObjects() {
    if($("div#msg_errors > p").length <= 0 && !$("div#msg_errors").hasClass("display_none")) {
        $("div#msg_errors").addClass("display_none");
    }
    if($("div#msg_user_client > p").length <= 0 && !$("div#msg_user_client").hasClass("display_none")) {
        $("div#msg_user_client").addClass("display_none");
    }
}
