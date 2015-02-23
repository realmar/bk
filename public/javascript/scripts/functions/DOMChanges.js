
/////////////////////////////////////////////////////////
//  Project Name:     BuecherkastenBibliothek BK
//  Author:           Anastassios Martakos
//  Language:         English / JavaScript
//  Created For / At: ETH Zuerich Department Physics
/////////////////////////////////////////////////////////

//  Description
//  
// Changes the DOM Content

function RefreshConnectionType(connection_type) {  //  Changes the Connection Type Label
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

function AddMessageData(dom_object, message, mode) {  //  Adds a Message
    var message_obj = $(message);
    if(mode == APPEND) {
        dom_object.append(message_obj);
    }else if(mode == PREPEND) {
        dom_object.prepend(message_obj);
    }
    return message_obj;
}

function RemoveMessageData(dom_object) {  //  Removes a Message
    if(dom_object.length > 0) {
        dom_object.remove();
    }
}

function CheckMSGDataObjects() {  //  Checks if the Message Areas should be visible or not by checking if they have any Messages in it
    if($("div#msg_errors > p").length <= 0 && !$("div#msg_errors").hasClass("display_none")) {
        $("div#msg_errors").addClass("display_none");
    }else if($("div#msg_errors > p").length > 0 && $("div#msg_errors").hasClass("display_none")) {
        $("div#msg_errors").removeClass("display_none");
    }
    if($("div#msg_user_client > p").length <= 0 && !$("div#msg_user_client").hasClass("display_none")) {
        $("div#msg_user_client").addClass("display_none");
    }else if($("div#msg_user_client > p").length > 0 && $("div#msg_user_client").hasClass("display_none")) {
        $("div#msg_user_client").removeClass("display_none");
    }
    if($("div#msg_errors_const > p").length <= 0 && !$("div#msg_errors_const").hasClass("display_none")) {
        $("div#msg_errors_const").addClass("display_none");
    }else if($("div#msg_errors_const > p").length > 0 && $("div#msg_errors_const").hasClass("display_none")) {
        $("div#msg_errors_const").removeClass("display_none");
    }
    if($("div#msg_user_client_const > p").length <= 0 && !$("div#msg_user_client_const").hasClass("display_none")) {
        $("div#msg_user_client_const").addClass("display_none");
    }else if($("div#msg_user_client_const > p").length > 0 && $("div#msg_user_client_const").hasClass("display_none")) {
        $("div#msg_user_client_const").removeClass("display_none");
    }
}

function GetBookboxDataAndCheckDOMDoubleDataEntries() {  //  Checks if there are double Entries in the Bookboxes and gets the Content of all Bookboxes, returns that it has double Entries or if this is not the case an ARRAY with all Bookboxes Data
    var bookbox_data = [];
    var dom_double_data_entry_vals = [];
    var dom_double_data_entry = false;
    $(".bookbox.double_data").removeClass("double_data");
    for(var i = 0; i < $("div.bookbox").length; i++) {
        for(var i2 = 0; i2 < bookbox_data.length; i2++) {
            if(bookbox_data[i2] == $("div#bookbox" + i + "> input.bookbox_input").val() && $("div#bookbox" + i + "> input.bookbox_input").val() != "") {
                dom_double_data_entry = true;
                dom_double_data_entry_vals.push($("div#bookbox" + i + "> input.bookbox_input").val());
            }
        }
        bookbox_data[i] = $("div#bookbox" + i + "> input.bookbox_input").val();
    }
    if(dom_double_data_entry) {
        for(var i = 0; i < $("div.bookbox").length; i++) {
            for(var i2 = 0; i2 < dom_double_data_entry_vals.length; i2++) {
                if($("div#bookbox" + i + "> input.bookbox_input").val() == dom_double_data_entry_vals[i2]) {
                    $("div#bookbox" + i).addClass("double_data");
                    break;
                }
            }
        }
        if($("div#msg_user_client_const > p." + DBL_DATA).length <= 0) {
            AddMessageData($("div#msg_user_client_const"), dom_double_data_entry_tpl, APPEND);
        }
        return GET_DOM_DATA_DOUBLE_ENTRY;
    }
    RemoveMessageData($("div#msg_user_client_const > p." + DBL_DATA));
    return bookbox_data;
}

function GetBookboxData() {  //  Returns an ARRAY with all Bookboxes Data
    var bookbox_data = [];
    for(var i = 0; i < $("div.bookbox").length; i++) {
        if($("div#bookbox" + i).hasClass("changed")) {
            bookbox_data[i] = $("div#bookbox" + i + "> input.bookbox_input").val();
        }else{
            bookbox_data[i] = AH_NOT_CHANGED;
        }
    }
    return bookbox_data;
}

function ClearAllMessages() {  //  Removes all Messages
    RemoveMessageData($("div#msg_user_client > p"));
    RemoveMessageData($("div#msg_errors > p"));
}

function DisplayLoadingMessage() {  //  Displays the Loading gif
    if($("div#loading").hasClass("display_none")) {
        $("div#loading").removeClass("display_none");
    }
}

function HideLoadingMessage() {  //  Hides the Loading gif
    if(!$("div#loading").hasClass("display_none")) {
        $("div#loading").addClass("display_none");
    }
}

function MakeMsgDOMString(classes, thow_time , msg_type, msg_string, mode) {  //  Makes and returns a message STRING, it can return a user friendly STRING or a not user friendly STRING, this depends on the message type or also known as logging facility
    var classes_string = "";
    var dom_msg_string = "";
    for(var i = 0; i < classes.length; i++) {
        classes_string += classes[i];
        if(i < classes.length - 1) {
            classes_string += ' ';
        }
    }
    if(mode == USER_FRINDELY_MSG) {
        dom_msg_string = '<p class="' + classes_string + '"><span class="msg_common">[' + thow_time + ']</span> ' + msg_string + '<span class="display_inline remove_msg">X</span></p>';
    }else if(mode == NOT_USER_FRIENDLY_MSG) {
        dom_msg_string = '<p class="' + classes_string + '"><span class="msg_common">[' + thow_time + ']</span> msg_type:' + msg_type + ' msg_string: ' + msg_string + '<span class="display_inline remove_msg">X</span></p>';
    }
    return dom_msg_string;
}

function ToLowercase() {
    $('div.bookbox > input.bookbox_input').each(function () {
        $(this).val($(this).val().toLowerCase());
    });
}

function RemoveObjectAfterTime(object) {
    setTimeout(function () {
        RemoveMessageData(object);
    }, MSG_DISAPPAIR_TIME);
}
