function ActionHandler(msg_data_arg) {
    this.msg_data = msg_data_arg;

    this.ProcessAction = ProcessAction;

    function ProcessAction() {
        //  RemoveMessageData($("." + AH_ERROR));
        if(Object.keys(this.msg_data["all_errors"]).length <= 0) {
            programm_handler.CheckBookboxStates();
            for(var i = 0; i < this.msg_data["msg_data"].length; i++) {
                var current_bookbox = $("div#bookbox" + i + "> input");
                if(current_bookbox.parent().hasClass("unchanged") || programm_handler.last_data_state.length <= 0 || (current_bookbox.parent().hasClass("changed") && this.msg_data["msg_data"][i] == null && programm_handler.last_data_state[i] != null)) {
                    current_bookbox.val(this.msg_data["msg_data"][i]);
                }
            }
            RemoveMessageData($("div#msg_user_client > p." + CHAG_CONT));
            programm_handler.last_data_state = this.msg_data["msg_data"];
        }
        for(var msg_cat in this.msg_data["all_infos"]) {
            for(var i = 0; i < this.msg_data["all_infos"][msg_cat].length; i++) {
                AddMessageData($("div#msg_user_client"), '<p class="' + MSG_USER + ' ' + AH_MESSAGE + '">[' + Date(this.msg_data["all_infos"][msg_cat][i][THROW_TIME]) + '] msg_type: ' + msg_cat + ' msg_string: ' + this.msg_data["all_infos"][msg_cat][i][MSG_STRING] + '</p>');
            }
        }
        for(var err_cat in this.msg_errors["all_errors"]) {
            for(var i = 0; i < this.msg_data["all_errors"][err_cat].length; i++)  {
                AddMessageData($("div#msg_errors"), '<p class="' + MSG_ERRORS + ' ' + AH_ERROR + '">[' + Date(this.msg_data["all_errors"][err_cat][i][THROW_TIME]) + '] err_type: ' + err_cat + ' err_string: ' + this.msg_data["all_errors"][err_cat][i][MSG_STRING] + '</p>');
            }
        }
        HideLoadingMessage();
    }
}
