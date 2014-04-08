function InitializeButtons() {
    $("div#save_button").click(function () {
        programm_handler.SaveData();
    });
    $("div#refresh_button").click(function () {
        programm_handler.RefreshData('force_refresh');
    });
}

function InitializeBookboxStates() {
    $("div.bookbox").addClass("unchanged");
}
