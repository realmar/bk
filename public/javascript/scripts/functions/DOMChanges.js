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

function RemoveMessageData(dom_object) {
    if(dom_object.length > 0) {
        dom_object.remove();
    }
}

function CheckMSGDataObjects() {
    if($("div#msg_errors > p").length <= 0 && !$("div#msg_errors").hasClass("display_none")) {
        $("div#msg_errors").addClass("display_none");
    }
    if($("div#msg_user_client > p").length <= 0 && !$("div#msg_user_client").hasClass("display_none")) {
        $("div#msg_user_client").addClass("display_none");
    }
}

function GetBookboxData() {
    var bookbox_data = [];
    for(var i = 0; i < $("div.bookbox").length; i++) {
        for(var i2 = 0; i2 < bookbox_data.length; i2++) {
            if(bookbox_data[i2] == $("div#bookbox" + i + "> input").val() && $("div#bookbox" + i + "> input").val() != "") {
                return GET_DOM_DATA_DOUBLE_ENTRY;
            }
        }
        bookbox_data[i] = $("div#bookbox" + i + "> input").val();
    }
    return bookbox_data;
}

function ClearAllMessages() {
    RemoveMessageData($("div#msg_user_client > p"));
    RemoveMessageData($("div#msg_errors > p"));
}
