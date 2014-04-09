function ActionHandler(msg_data_arg) {
    this.msg_data = msg_data_arg;

    this.ProcessAction = ProcessAction;

    function ProcessAction() {
        RemoveMessageData($("." . AH_ERROR));
        if(this.msg_data["all_errors"].length <= 0) {
            programm_handler.CheckBookboxStates();
            for(var i = 0; i < this.msg_data["msg_data"].length; i++) {
                var current_bookbox = $("div#bookbox" + i + "> input");
                if(current_bookbox.parent().hasClass("unchanged") || programm_handler.last_data_state.length <= 0 || (current_bookbox.parent().hasClass("changed") && this.msg_data["msg_data"][i] == null && programm_handler.last_data_state[i] != null)) {
                    current_bookbox.val(this.msg_data["msg_data"][i]);
                }
            }
            programm_handler.last_data_state = this.msg_data["msg_data"];
        }else{
            for(var err_data in this.msg_data["all_errors"]) {
                AddMessageData($("div#msg_errors"), "<p class=" + MSG_ERRORS + " " + AH_ERROR + "ERROR: err_type: " + err_data["err_type"] + " err_string: " + err_data["error_msg"] + "</p>");
            }
        }
    }
}
