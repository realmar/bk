function ActionHandler(msg_data_arg) {
    this.msg_data = msg_data_arg;

    this.ProcessAction = ProcessAction;

    function ProcessAction() {
        if(this.msg_data["all_errors"].length <= 0) {
            for(var i = 0; i < this.msg_data["msg_data"].length; i++) {
                $("input#bookbox" + i).value = this.msg_data["msg_data"][i];
            }
        }else{
            for(var err_data in this.msg_data["all_errors"]) {
                $("div#msg_errors").append("<p class=" + MSG_ERRORS + ">ERROR: err_type: " + err_data["error_type"] + " err_string: " + err_data["error_msg"] + "</p>");
            }
        }
    }
}
