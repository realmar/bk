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
    }else if($("div#msg_errors > p").length > 0 && $("div#msg_errors").hasClass("display_none")) {
        $("div#msg_errors").removeClass("display_none");
    }
    if($("div#msg_user_client > p").length <= 0 && !$("div#msg_user_client").hasClass("display_none")) {
        $("div#msg_user_client").addClass("display_none");
    }else if($("div#msg_user_client > p").lenght > 0 && $("div#msg_user_client").hasClass("display_none")) {
        $("div#msg_user_client").removeClass("display_none");
    }
}

function GetBookboxDataAndCheckDOMDoubleDataEntries() {
    var bookbox_data = [];
    var dom_double_data_entry_vals = [];
    var dom_double_data_entry = false;
    $(".bookbox.input_error").removeClass("input_error");
    for(var i = 0; i < $("div.bookbox").length; i++) {
        for(var i2 = 0; i2 < bookbox_data.length; i2++) {
            if(bookbox_data[i2] == $("div#bookbox" + i + "> input").val() && $("div#bookbox" + i + "> input").val() != "") {
                dom_double_data_entry = true;
                dom_double_data_entry_vals.push($("div#bookbox" + i + "> input").val());
            }
        }
        bookbox_data[i] = $("div#bookbox" + i + "> input").val();
    }
    if(dom_double_data_entry) {
        for(var i = 0; i < $("div.bookbox").length; i++) {
            for(var i2 = 0; i2 < dom_double_data_entry_vals.length; i2++) {
                if($("div#bookbox" + i + "> input").val() == dom_double_data_entry_vals[i2]) {
                    $("div#bookbox" + i).addClass("input_error");
                    break;
                }
            }
        }
        return GET_DOM_DATA_DOUBLE_ENTRY;
    }
    return bookbox_data;
}

function GetBookboxData() {
    var bookbox_data = [];
    for(var i = 0; i < $("div.bookbox").length; i++) {
        if($("div#bookbox" + i).hasClass("changed")) {
            bookbox_data[i] = $("div#bookbox" + i + "> input").val();
        }else{
            bookbox_data[i] = AH_NOT_CHANGED;
        }
    }
    return bookbox_data;
}

function ClearAllMessages() {
    RemoveMessageData($("div#msg_user_client > p"));
    RemoveMessageData($("div#msg_errors > p"));
}

function DisplayLoadingMessage() {
    if($("div#loading").hasClass("display_none")) {
        $("div#loading").removeClass("display_none");
    }
}

function HideLoadingMessage() {
    if(!$("div#loading").hasClass("display_none")) {
        $("div#loading").addClass("display_none");
    }
}
