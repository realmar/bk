function BKWebSocket(ws_path_arg) {
    this.socket;

    this.OpenWebSocket = OpenWebSocket;
    this.OnOpenWS = OnOpenWS;
    this.OnMessageWS = OnMessageWS;
    this.SendDataWS = SendDataWS;
    this.SendMSGWS = SendMSGWS;
    this.KeepAliveWS = KeepAliveWS;

    if(ws_path_arg) {
        this.OpenWebSocket(ws_path_arg);
    }

    function OpenWebSocket(ws_path_arg) {
        this.socket = new WebSocket(ws_path_arg);
        this.socket.onopen = function (e) { this.OnOpenWS(); };
        this.socket.onmessage = function (e) { this.OnMessageWS(e); };
    }

    function OnOpenWS() {
        console.log('its open men' + this.socket.readyState);
        console.log('its open men' + this.socket.readyState);
        console.log('its open men' + this.socket.readyState);
        console.log('its open men' + this.socket.readyState);
        if(this.socket.readyState == this.socket.OPEN) {
            programm_handler.InitializeConnTypeWebSockets();
            programm_handler.SetConnectionType(CONN_TYPE_WEBSOCKETS);
        }
    }

    function OnMessageWS(e) {
        var recv_action = new ActionHandler(JSON.parse(e.data));
        recv_action.ProcessAction();
    }

    function SendDataWS(data) {
        var ws_tries_local = 0;
        while(programm_handler.conn_attempt == WS_SEND_WAIT) {
        }
        if(programm_handler.conn_attempt == WS_SEND_ABORD) {
            return 0;
        }
        if(this.socket.readyState != this.socket.OPEN) {
            programm_handler.conn_attempt = WS_SEND_WAIT;
            setTimeout(WaitForWebSocket(), programm_handler.ws_wait);
            function WaitForWebSocket() {
                if(this.socket.readyState != this.socket.OPEN) {
                    if(ws_tries_local <= programm_handler.ws_tries) {
                        ws_tries_local++;
                        setTimeout(WaitForWebSocket(), programm_handler.ws_wait);
                    }else{
                        programm_handler.conn_attempt = WS_SEND_ABORD;
                        programm_handler.InitializeConnTypeAJAX();
                        return 0;
                    }
                }
            }
        }
        programm_handler.conn_attempt = WS_SEND_NO_WAIT;
        this.socket.send(data);
    }

    function SendMSGWS(action, msg_data, ws_tries_local) {
        this.SendDataWS(JSON.stringify({
            'action'   : action,
            'msg_data' : msg_data
        }));
    }

    function KeepAliveWS() {
        this.SendDataWS('keep alive');
    }
}
