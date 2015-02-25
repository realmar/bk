
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
    $("div#open_all_doors_button").jBox('Confirm', {
        title: 'Confirm your action',
        content: 'Do you really want to open all doors?',
        confirmButton: 'Continue',
        cancleButton: 'Cancle',
        confirm: OpenAllDoorsClick
    });
    $("div.bookbox > span.edit_bookbox > span.delete_bookbox").click(function () {
        $(this).parent().prevAll("input.bookbox_input").val("");
    });
    $("div.bookbox > span.edit_bookbox > span.undo_bookbox").click(function () {
        $(this).parent().prevAll("input.bookbox_input").val(program_handler.last_data_state[$(this).parent().siblings("input.bookbox_id").val()])
    });
    $("div.bookbox > span.edit_bookbox > span.open_bookbox").click(function () {
        program_handler.OpenDoors([ parseInt($(this).parent().siblings("input.bookbox_id").attr("value")) ]);
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

function InitializeEventListeners() {
    window.onkeydown = function(e) {
        if(e.which == KEY_ENTER) {
            program_handler.SaveData();
        }
    }
}
