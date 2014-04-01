function BKWebSocket(ws_path_arg) {
    this.socket;

    this.OpenWebSocket = OpenWebSocket;
    this.OnOpenWS = OnOpenWS;
    this.OnMessageWS = OnMessageWS;
    this.SendDataWS = SendDataWS;
    this.SendMSGWS = SendMSGWS;
    this.CheckWSReadyState = CheckWSReadyState;
    this.KeepAliveWS = KeepAliveWS;

    this.OpenWebSocket(ws_path_arg);
    this.socket.onopen = OnOpenWS();

    this.socket.onmessage = function(e) {
        this.OnMessageWS(e);
    };

    function OpenWebSocket(ws_path_arg) {
        this.socket = new WebSocket(ws_path_arg);
    }

    function OnOpenWS(callback) {
    }

    function OnMessageWS(e) {
        this.data = JSON.parse(e.data);
    }

    function SendDataWS(data) {
            var ws_tries_local = 0;
            while(programm_handler.conn_attempt == WS_SEND_WAIT) {
            }
            if(programm_handler.conn_attempt == WS_SEND_ABORD) {
                return 0;
            }
            while(programm_handler.conn_state != WS_READY_STATE_OPEN) {
                if(ws_tries_local <= programm_handler.ws_tries) {
                    sleep(programm_handler.ws_wait);
                }else{
                    programm_handler.conn_attempt = WS_SEND_ABORD;
                    programm_handler.InitializeConnTypeAJAX();
                    return 0;
                }
            }
            this.socket.send(data);
        }
    }

    function SendMSGWS(action, msg_data, ws_tries_local) {
        this.SendDataWS(JSON.stringify({
            'action'   : action,
            'msg_data' : msg_data
        }));
    }

    function CheckWSReadyState() {
        programm_handler.ProcessWebSocketReadyState(this.socket.readyState);
    }

    function KeepAliveWS() {
        this.SendDataWS('keep alive');
    }
}
