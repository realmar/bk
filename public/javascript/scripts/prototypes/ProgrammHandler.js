function ProgrammHandler() {
    this.intervals_collector = new IntervalsCollector();
    this.conn_type;
    this.conn_attempt = WS_SEND_NO_WAIT;
    this.bk_websocket;
    this.bk_ajax_data;

    this.InitializeProgramm = InitializeProgramm;
    this.InitializeConnTypeWebSockets = InitializeConnTypeWebSockets;
    this.InitializeConnTypeAJAX = InitializeConnTypeAJAX;
    this.ConnectToWebSocket = ConnectToWebSocket;
    this.SetConnectionType = SetConnectionType;
    this.RefreshData = RefreshData;
    this.SaveData = SaveData;
    this.CheckBookboxStates = CheckBookboxStates;
    this.CheckMSGDataObjects = CheckMSGDataObjects;

    this.ws_tries = 10;
    this.ws_wait = 20;

    this.last_data_state = [];

    function InitializeProgramm() {
        this.ConnectToWebSocket();
        if(this.conn_type != CONN_TYPE_WEBSOCKETS) {
            this.InitializeConnTypeAJAX();
        }
        InitializeBookboxStates();
        InitializeButtons();
        this.intervals_collector.RegisterInterval(['CheckBookboxStates'], 20, 'input_check');
        this.intervals_collector.RegisterInterval(['CheckMSGDataObjects'], 20, 'msg_data_objects_check');
    }
    
    function InitializeConnTypeWebSockets() {
        this.intervals_collector.RemoveInterval('bk_websocket_try_connect');
        this.intervals_collector.RemoveInterval('bk_ajax_data_refresh');
        this.bk_ajax_data = null;
        this.intervals_collector.RegisterInterval(['bk_websocket', 'KeepAliveWS'], 80, 'bk_websocket_keep_alive');
        this.intervals_collector.RegisterInterval(['RefreshData'], 2000, 'bk_websocket_refresh');
        RemoveMessageData($("." + NO_CONN_ERROR));
    }

    function InitializeConnTypeAJAX() {
        if(programm_handler.conn_type != CONN_TYPE_AJAX) {
            this.intervals_collector.RemoveInterval('bk_websocket_keep_alive');
            this.intervals_collector.RemoveInterval('bk_websocket_refresh');
            this.bk_ajax_data = null;
            this.bk_ajax_data = new AJAXRequest(ajax_path);
            this.intervals_collector.RegisterInterval(['RefreshData'], 2000, 'bk_ajax_data_refresh');
            this.intervals_collector.RegisterInterval(['ConnectToWebSocket'], 2800, 'bk_websocket_try_connect');
            this.SetConnectionType(CONN_TYPE_AJAX);
        }
    }

    function SetConnectionType(conn_type_arg) {
        RefreshConnectionType(conn_type_arg);
        this.conn_type = conn_type_arg;
    }
    
    function ConnectToWebSocket() {
        this.bk_websocket = null;
        this.bk_websocket = new BKWebSocket(ws_path);
    }

    function RefreshData(force_refresh) {
        if(force_refresh) {
            this.last_data_state = [];
            $("div.bookbox > input").val("");
        }
        switch (this.conn_type) {
            case CONN_TYPE_WEBSOCKETS:
                this.bk_websocket.SendMSGWS(ACTION_REFRESH, null);
                break;
            case CONN_TYPE_AJAX:
                this.bk_ajax_data.AJAXGetData(ACTION_REFRESH, null, AJAX_SEND_TYPE_GET);
                break;
        }
        CheckBookboxStates();
    }
    
    function SaveData() {
        var bookbox_data = GetBookboxData();
        if(bookbox_data == GET_DOM_DATA_DOUBLE_ENTRY) {
            if($("div#msg_errors > p." + DBL_DATA).length <= 0) {
                AddMessageData($("div#msg_errors"), dom_double_data_entry_tpl);
            }
        }else{
            RemoveMessageData($("." + DBL_DATA));
            switch (this.conn_type) {
                case CONN_TYPE_WEBSOCKETS:
                    this.bk_websocket.SendMSGWS(ACTION_SAVEDATA, bookbox_data);
                    break;
                case CONN_TYPE_AJAX:
                    this.bk_ajax_data.AJAXGetData(ACTION_SAVEDATA, JSON.stringify(bookbox_data), AJAX_SEND_TYPE_POST);
                    break;
            }
        }
    }
}

function CheckBookboxStates() {
    for(var i = 0; i < programm_handler.last_data_state.length; i++) {
        var current_bookbox = $("div#bookbox" + i);
        if(($("div#bookbox" + i + "> input").val() != programm_handler.last_data_state[i]) && !($("div#bookbox" + i + "> input").val() == "" && programm_handler.last_data_state[i] == null)) {
            if(current_bookbox.hasClass("unchanged")) {
                current_bookbox.removeClass("unchanged");
            }
            current_bookbox.addClass("changed");
        }else{
            if(current_bookbox.hasClass("changed")) {
                current_bookbox.removeClass("changed");
            }
            current_bookbox.addClass("unchanged");
        }
    }
    if($(".changed.bookbox").length > 0) {
        if($("div#msg_user_client > p").length <= 0) {
            AddMessageData($("div#msg_user_client"), apply_changes_tpl);
            $("div#msg_user_client").removeClass("display_none");
        }
    }else{
        RemoveMessageData($("div#msg_user_client > p." + CHAG_CONT));
    }
}
