
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
        $("div.bookbox > input").val("");
    });
    $("div.bookbox > p > span.delete_bookbox").click(function () {
        $(this).parent().next("input").val("");
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
