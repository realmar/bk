
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
        program_handler.SaveData();
    });
    $("div#refresh_button").click(function () {
        program_handler.RefreshData('force_refresh');
    });
    $("div#delete_all_button").click(function () {
        $("div.bookbox > input.bookbox_input").val("");
    });
    $("div#open_all_doors_button").click(function () {
        $("div#open_all_doors_button").removeClass("display_inline");
        $("div#open_all_doors_button").addClass("display_none");
        $("div#open_all_doors_button_inactive").removeClass("display_none");
        $("div#open_all_doors_button_inactive").addClass("display_inline");
        program_handler.OpenDoors([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
    });
    $("div.bookbox > p > span.edit_bookbox > span.delete_bookbox").click(function () {
        $(this).parent().parent().next("input.bookbox_input").val("");
    });
    $("div.bookbox > p > span.edit_bookbox > span.undo_bookbox").click(function () {
        $(this).parent().parent().next("input.bookbox_input").val(program_handler.last_data_state[$(this).parent().parent().siblings("input.bookbox_id").val()])
    });
    $("div.bookbox > p > span.edit_bookbox > span.open_bookbox").click(function () {
        program_handler.OpenDoors([ parseInt($(this).parent().parent().siblings("input.bookbox_id").attr("value")) ]);
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
