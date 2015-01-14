
/////////////////////////////////////////////////////////
//  Project Name:     BuecherkastenBibliothek BK
//  Author:           Anastassios Martakos
//  Language:         English / JavaScript
//  Created For / At: ETH Zuerich Department Physics
/////////////////////////////////////////////////////////

//  Description
//
//  Handles everything that needs to be initialized eg. DOM Element which are Buttons

function InitializeButtons() {  //  Initializes all Buttons
    $("div#save_button").click(function () {
        programm_handler.SaveData();
    });
    $("div#refresh_button").click(function () {
        programm_handler.RefreshData('force_refresh');
    });
    $("div#delete_all_button").click(function () {
        $("div.bookbox > input.bookbox_input").val("");
    });
    $("div.bookbox > p > span.edit_bookbox > span.delete_bookbox").click(function () {
        $(this).parent().parent().next("input.bookbox_input").val("");
    });
    $("div.bookbox > p > span.edit_bookbox > span.undo_bookbox").click(function () {
        $(this).parent().parent().next("input.bookbox_input").val(programm_handler.last_data_state[$(this).parent().parent().siblings("input.bookbox_id").val()])
    });
    $("div.bookbox > p > span.edit_bookbox > span.open_bookbox").click(function () {
        programm_handler.OpenDoors([ parseInt($(this).parent().parent().siblings("input.bookbox_id").attr("value")) ]);
    });
}

function InitializeRemoveMSGButton(msg_button) {  //  Initialized a specific Message Button
    $(msg_button).click(function () {
        RemoveMessageData(msg_button.parent());
    });
}

function InitializeBookboxStates() {  // Initialized the Bookboxes
    $("div.bookbox").addClass("unchanged");
}
