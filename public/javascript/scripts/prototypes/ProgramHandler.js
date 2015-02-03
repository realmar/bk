
/////////////////////////////////////////////////////////
//  Project Name:     BuecherkastenBibliothek BK
//  Author:           Anastassios Martakos
//  Language:         English / JavaScript
//  Created For / At: ETH Zuerich Department Physics
/////////////////////////////////////////////////////////

//  Description
//
//  Main Object it handles everything what has something to do with JavaScript
//  It allways want to Connect over WebSockets to the Server but if this is not possible it falls back to AJAX
//
//  Synopsis
//
//  var program_handler = new ProgramHandler();
//  program_handler.InitializeProgram();

function ProgramHandler() {
    this.intervals_collector = new IntervalsCollector();  //  Initialized a new IntercalsCollector
    this.conn_type;                                       //  Stores the Connection Type if AJAX or Websockets are used
    this.conn_attempt = WS_SEND_NO_WAIT;                  //  Sets if it has to be waited for teh Websocket to be ready
    this.bk_websocket;                                    //  Stores the Websocket Object
    this.bk_ajax_data;                                    //  Stores the AJAX Object

    this.InitializeProgram           = InitializeProgram;           //  Initialized the Program
    this.InitializeConnTypeWebSockets = InitializeConnTypeWebSockets; //  Initialized the WebSocket Content
    this.InitializeConnTypeAJAX       = InitializeConnTypeAJAX;       //  Initialized the AJAX Content
    this.ConnectToWebSocket           = ConnectToWebSocket;           //  Connects to the WebSocket
    this.SetConnectionType            = SetConnectionType;            //  Sets the Connection Type
    this.RefreshData                  = RefreshData;                  //  Refreshes the Bookbox and Messages Data, does not save the data
    this.OpenDoors                    = OpenDoors                     //  Sends Request to open a or some Doors
    this.SaveData                     = SaveData;                     //  Saves the Data from the Bookboxes to the Server
    this.CheckBookboxStates           = CheckBookboxStates;           //  Checks the Bookbox States
    this.CheckMSGDataObjects          = CheckMSGDataObjects;          //  Checks the MSGDataObjects States

    this.ws_tries = 10;  //  Tries count for the WebSocket
    this.ws_wait  = 20;  //  Time to wait between the tries

    this.last_data_state = [];  //  Stores the last state of the Bookboxes

    function InitializeProgram() {
        this.intervals_collector.RemoveInterval('bk_websocket_try_connect');
        this.intervals_collector.RemoveInterval('bk_ajax_data_refresh');
        this.intervals_collector.RemoveInterval('bk_websocket_keep_alive');
        this.intervals_collector.RemoveInterval('bk_websocket_refresh');
        this.bk_websocket = null;
        this.bk_ajax_data = null;
        this.bk_ajax_data = new AJAXRequest(ajax_path);
        this.RefreshData();
        this.InitializeConnTypeAJAX();
        InitializeBookboxStates();
        InitializeButtons();
        this.intervals_collector.RegisterInterval(['CheckBookboxStates'], 'input_check', 0, {dtshort : 20, dtlong : 0});
        this.intervals_collector.RegisterInterval(['CheckMSGDataObjects'], 'msg_data_objects_check', 0, {dtshort : 20, dtlong : 0});
    }
    
    function InitializeConnTypeWebSockets() {
        this.intervals_collector.RemoveInterval('bk_websocket_try_connect');
        this.intervals_collector.RemoveInterval('bk_ajax_data_refresh');
        this.bk_ajax_data = null;
        this.intervals_collector.RegisterInterval(['bk_websocket', 'KeepAliveWS'], 'bk_websocket_keep_alive', 0, {dtshort : 1800, dtlong : 0});
        this.intervals_collector.RegisterInterval(['RefreshData'], 'bk_websocket_refresh', 0, {dtshort : 2000, dtlong : 0});
        RemoveMessageData($("." + NO_CONN_ERROR));
    }

    function InitializeConnTypeAJAX(reinit) {
        if(program_handler.conn_type != CONN_TYPE_AJAX) {
            this.intervals_collector.RemoveInterval('bk_websocket_keep_alive');
            this.intervals_collector.RemoveInterval('bk_websocket_refresh');
            this.bk_ajax_data = null;
            this.bk_ajax_data = new AJAXRequest(ajax_path);
            this.intervals_collector.RegisterInterval(['RefreshData'], 'bk_ajax_data_refresh', 8, {dtshort : 2000, dtlong : 60000});
            this.intervals_collector.RegisterInterval(['ConnectToWebSocket'], 'bk_websocket_try_connect', 8, {dtshort : 2800, dtlong : 60000});
            this.intervals_collector.UpgradeInterval('bk_websocket_try_connect', true);
            this.SetConnectionType(CONN_TYPE_AJAX);
            RemoveMessageData($("." + NO_CONN_ERROR));
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
            DisplayLoadingMessage();
            ClearAllMessages();
            this.last_data_state = [];
            $("div.bookbox > input.bookbox_input").val("");
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
        DisplayLoadingMessage();
        GetBookboxDataAndCheckDOMDoubleDataEntries();
        var bookbox_data = GetBookboxData();
        switch (this.conn_type) {
            case CONN_TYPE_WEBSOCKETS:
                this.bk_websocket.SendMSGWS(ACTION_SAVEDATA, bookbox_data);
                break;
            case CONN_TYPE_AJAX:
                this.bk_ajax_data.AJAXGetData(ACTION_SAVEDATA, JSON.stringify(bookbox_data), AJAX_SEND_TYPE_POST);
                break;
        }
    }

    function OpenDoors(doors) {
        DisplayLoadingMessage();
        if($("div#msg_user_client_const > p." + OPN_DOORS).length <= 0) {
            AddMessageData($("div#msg_user_client_const"), open_doors_tpl, APPEND);
        }
        var opendoors = new Array();
        for(var i = 0; i < DOORS_COUNT; i++) {
            opendoors[i] = {};
            opendoors[i][OPEN_DOOR] = NOT_OPEN_DOOR;
            opendoors[i]["user"] = DOORS_USER;
        }
        for(var i = 0; i < doors.length; i++) {
            opendoors[doors[i]][OPEN_DOOR] = DO_OPEN_DOOR;
        }
        switch (this.conn_type) {
            case CONN_TYPE_WEBSOCKETS:
                this.bk_websocket.SendMSGWS(ACTION_OPEN_DOORS, opendoors);
                break;
            case CONN_TYPE_AJAX:
                this.bk_ajax_data.AJAXGetData(ACTION_OPEN_DOORS, JSON.stringify(opendoors), AJAX_SEND_TYPE_POST);
                break;
        }
    }
}

function CheckBookboxStates() {
    var bookbox_data = [];
    for(var i = 0; i < $("div.bookbox").length; i++) {
        var current_bookbox = $("div#bookbox" + i);
        if(($("div#bookbox" + i + "> input.bookbox_input").val() != program_handler.last_data_state[i]) && !($("div#bookbox" + i + "> input.bookbox_input").val() == "" && program_handler.last_data_state[i] == null)) {
            current_bookbox.addClass("changed");
        }else{
            if(current_bookbox.hasClass("changed")) {
                current_bookbox.removeClass("changed");
            }
            if($("div#bookbox" + i + "> input.bookbox_input").val() != "") {
                current_bookbox.removeClass("empty_bookbox");
                current_bookbox.addClass("unchanged");
            }else{
                current_bookbox.removeClass("unchanged");
                current_bookbox.addClass("empty_bookbox");
            }
        }
    }
    if($(".changed.bookbox").length > 0) {
        if($("div#msg_user_client_const > p." + CHAG_CONT).length <= 0) {
            AddMessageData($("div#msg_user_client_const"), apply_changes_tpl, PREPEND);
        }
    }else{
        RemoveMessageData($("div#msg_user_client_const > p." + CHAG_CONT));
    }
    GetBookboxDataAndCheckDOMDoubleDataEntries();
}
