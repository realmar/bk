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
    this.ProcessWebSocketReadyState = ProcessWebSocketReadyState;
    this.RefreshData = RefreshData;
    this.SaveData = SaveData;

    this.ws_tries = 10;
    this.ws_wait = 20;

    function InitializeProgramm() {
        this.ConnectToWebSocket();
        setTimeout(ProcessWebSocketReadyState(), 200);
        if(this.conn_type == CONN_TYPE_AJAX) {
            this.InitializeConnTypeAJAX();
        }
        InitializeButtons();
    }
    
    function InitializeConnTypeWebSockets() {
        //  this.intervals_collector.RemoveInterval('bk_ajax_data_refresh');
        //  this.bk_ajax_data = null;
        this.intervals_collector.RegisterInterval(this.bk_websocket.KeepAliveWS(), 80, 'bk_websocket_keep_alive');
        this.intervals_collector.RegisterInterval(this.RefreshData(), 2000, 'bk_websocket_refresh');
    }

    function InitializeConnTypeAJAX() {
        this.bk_ajax_data = new AJAXRequest(ajax_path);
        this.SetConnectionType(CONN_TYPE_AJAX);
        this.intervals_collector.RegisterInterval(this.RefreshData(), 2000, 'bk_ajax_data_refresh');
    }

    function SetConnectionType(conn_type_arg) {
        RefreshConnectionType(conn_type_arg);
        this.conn_type = conn_type_arg;
    }
    
    function ConnectToWebSocket() {
        this.bk_websocket = new BKWebSocket(ws_path);
    }

    function ProcessWebSocketReadyState() {
        if(this.bk_websocket.socket.readState != this.bk_websocket.socket.OPEN) {
            this.SetConnectionType(CONN_TYPE_AJAX);
        }else{
            this.SetConnectionType(CONN_TYPE_WEBSOCKETS);
        }
    }
    
    function RefreshData() {
        switch (this.conn_type) {
            case CONN_TYPE_WEBSOCKETS:
                this.bk_websocket.SendMSGWS(ACTION_REFRESH);
                break;
            case CONN_TYPE_AJAX:
                this.bk_ajax_data.AJAXGetData(ACTION_REFRESH, AJAX_SEND_TYPE_GET);
                break;
        }
    }
    
    function SaveData() {
        switch (this.conn_type) {
            case CONN_TYPE_WEBSOCKETS:
                break;
            case CONN_TYPE_AJAX:
                break;
        }
    }
}
