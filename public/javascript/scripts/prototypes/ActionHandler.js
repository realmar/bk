function ActionHandler(msg_data_arg) {
    this.msg_data = msg_data_arg;

    this.ProcessAction = ProcessAction;

    function ProcessAction() {
        RemoveMessageData($("div#all_errors > p." + AH_ERROR));
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
                var date_time_throw_time =  new Date(this.msg_data["all_infos"][msg_cat][i][THROW_TIME] * 1000);
                if(msg_cat == AH_SUCC_SAVE_DATA.replace(/\_/gi, "")) {
                    if($("div#msg_user_client > p." + AH_SUCC_SAVE_DATA)) {
                        RemoveMessageData($("div#msg_user_client > p." + AH_SUCC_SAVE_DATA));
                    }
                    var new_message_obj = AddMessageData($("div#msg_user_client"), MakeMsgDOMString([MSG_USER, AH_SUCC_SAVE_DATA], String(date_time_throw_time.toLocaleDateString() + " " + date_time_throw_time.toLocaleTimeString()), null, this.msg_data["all_infos"][msg_cat][i][MSG_STRING], USER_FRINDELY_MSG), PREPEND);
                    InitializeRemoveMSGButton(new_message_obj.find(".remove_msg"));
                }else{
                    var new_message_obj = AddMessageData($("div#msg_user_client"), MakeMsgDOMString([MSG_USER, AH_MESSAGE], String(date_time_throw_time.toLocaleDateString() + " " + date_time_throw_time.toLocaleTimeString()), msg_cat, this.msg_data["all_infos"][msg_cat][i][MSG_STRING], NOT_USER_FRIENDLY_MSG), APPEND);
                    InitializeRemoveMSGButton(new_message_obj.find(".remove_msg"));
                }
            }
        }
        for(var err_cat in this.msg_data["all_errors"]) {
            for(var i = 0; i < this.msg_data["all_errors"][err_cat].length; i++)  {
                var date_time_throw_time = new Date(this.msg_data["all_errors"][err_cat][i][THROW_TIME] * 1000);
                var new_message_obj = AddMessageData($("div#msg_errors"), MakeMsgDOMString([MSG_ERRORS, AH_ERROR], String(date_time_throw_time.toLocaleDateString() + ' ' + date_time_throw_time.toLocaleTimeString()), err_cat, this.msg_data["all_errors"][err_cat][i][MSG_STRING], NOT_USER_FRIENDLY_MSG), PREPEND);
                InitializeRemoveMSGButton(new_message_obj.find(".remove_msg"));
            }
        }
        HideLoadingMessage();
    }
}
