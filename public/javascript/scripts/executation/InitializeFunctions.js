function InitializeButtons() {
    $("div#save_button").click(function () {
        programm_handler.SaveData();
    });
    $("div#refresh_button").click(function () {
        programm_handler.RefreshData('force_refresh');
    });
    $("div#delete_all_button").click(function () {
        $("div.bookbox > input").val("");
    });
}

function InitializeRemoveMSGButton(msg_button) {
    $(msg_button).click(function () {
        RemoveMessageData(msg_button.parent());
    });
}

function InitializeBookboxStates() {
    $("div.bookbox").addClass("unchanged");
}
