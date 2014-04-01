function ProgrammHandler() {
    this.intervals_collector = new IntervalsCollector();
    this.conn_type;
    this.bk_websocket;
    this.bk_ajax_data;

    this.InitializeProgramm = InitializeProgramm;
    this.SetConnectionType = SetConnectionType;
    this.ProcessWebSocketReadyState = ProcessWebSocketReadyState;
    this.RefreshData = RefreshData;
    this.SaveData = SaveData;

    function InitializeProgramm() {
        this.bk_websocket = new BKWebSocket(ws_path);
        switch(this.conn_type) {
            case CONN_TYPE_WEBSOCKETS:
                this.intervals_collector.RegisterInterval(this.bk_websocket.CheckWSReadyState(), 20, 'bk_websocket_check_readystate');
                this.intervals_collector.RegisterInterval(this.RefreshData(), 2000, 'bk_websocket_refresh');
                break;
            case CONN_TYPE_AJAX:
                this.bk_ajax_data = new AJAXRequest(ajax_path);
                this.intervals_collector.RegisterInterval(this.RefreshData(), 2000, 'bk_ajax_data_refresh');
                break;
        }
        InitializeButtons();
    }
    
    function SetConnectionType(conn_type_arg) {
        RefreshConnectionType(CONN_TYPE_WEBSOCKETS);
        this.conn_type = conn_type_arg;
    }
    
    function ProcessWebSocketReadyState(ws_ready_state) {
        switch(ws_ready_state) {
            case WS_READY_STATE_CONNECTING:
                break;
            case WS_READY_STATE_OPEN:
                this.SetConnectionType(CONN_TYPE_WEBSOCKETS);
                break;
            case WS_READY_STATE_CLOSING:
                break;
            case WS_READY_STATE_CLOSED:
                this.SetConnectionType(CONN_TYPE_AJAX);
                break;
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
