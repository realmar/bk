function BKWebSocket(ws_path_arg) {
    this.socket;

    this.OpenWebSocket = OpenWebSocket;
    this.OnOpenWS = OnOpenWS;
    this.OnMessageWS = OnMessageWS;
    this.OnCloseWS = OnCloseWS;
    this.OnErrorWS = OnErrorWS;
    this.CloseWebSocket = CloseWebSocket;
    this.SendDataWS = SendDataWS;
    this.SendMSGWS = SendMSGWS;
    this.KeepAliveWS = KeepAliveWS;

    if(ws_path_arg) {
        this.OpenWebSocket(ws_path_arg);
    }

    function OpenWebSocket(ws_path_arg) {
        this.socket = null;
        this.socket = new WebSocket(ws_path_arg);
        programm_handler.conn_attempt == WS_SEND_NO_WAIT;
        this.socket.addEventListener("open", this.OnOpenWS);
        this.socket.addEventListener("message", this.OnMessageWS);
        this.socket.addEventListener("close", this.OnCloseWS);
        this.socket.addEventListener("error", this,OnErrorWS);
    }

    function OnOpenWS(e) {
        if(this.readyState == this.OPEN) {
            programm_handler.InitializeConnTypeWebSockets();
            programm_handler.SetConnectionType(CONN_TYPE_WEBSOCKETS);
        }
    }

    function OnMessageWS(e) {
        var recv_action = new ActionHandler(JSON.parse(e.data));
        recv_action.ProcessAction();
        recv_action = null;
    }

    function OnCloseWS(e) {
        CloseWebSocket();
    }

    function OnErrorWS(e) {
        CloseWebSocket();
    }

    function CloseWebSocket() {
        programm_handler.conn_attempt == WS_SEND_ABORD;
        programm_handler.InitializeConnTypeAJAX();
    }

    function SendDataWS(data) {
        var ws_tries_local = 0;
        while(programm_handler.conn_attempt == WS_SEND_WAIT) {
        }
        if(programm_handler.conn_attempt == WS_SEND_ABORD) {
            return 0;
        }
        if(!this.socket) {
            programm_handler.conn_attempt = WS_SEND_ABORD;
            return 0;
        }
        if(this.socket.readyState != this.socket.OPEN) {
            programm_handler.conn_attempt = WS_SEND_WAIT;
            setTimeout(WaitForWebSocket(), programm_handler.ws_wait);
            function WaitForWebSocket() {
                if(!this.socket) {
                    programm_handler.conn_attempt = WS_SEND_ABORD;
                    return 0;
                }
                if(this.socket.readyState != this.socket.OPEN) {
                    if(ws_tries_local <= programm_handler.ws_tries) {
                        ws_tries_local++;
                        setTimeout(WaitForWebSocket(), programm_handler.ws_wait);
                    }else{
                        return 0;
                    }
                }
            }
        }
        if(programm_handler.conn_attempt != WS_SEND_ABORD) {
            programm_handler.conn_attempt = WS_SEND_NO_WAIT;
            !this.socket.send(data);
        }
    }

    function SendMSGWS(action, msg_data) {
        this.SendDataWS(JSON.stringify({
            'action'   : action,
            'msg_data' : msg_data
        }));
        RemoveMessageData($("." + NO_CONN_SAVE_ERR));
    }

    function KeepAliveWS() {
        this.SendMSGWS(ACTION_KEEP_ALIVE, null);
    }
}
