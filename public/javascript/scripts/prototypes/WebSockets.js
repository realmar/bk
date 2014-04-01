function BKWebSocket(ws_path_arg) {
    this.socket;

    this.OpenWebSocket = OpenWebSocket;
    this.OnOpenWS = OnOpenWS;
    this.OnMessageWS = OnMessageWS;
    this.SendMSGWS = SendMSGWS;
    this.CheckWSReadyState = CheckWSReadyState;

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

    function SendMSGWS(action, msg_data) {
        socket.send(JSON.stringify({
            'action'   : action,
            'msg_data' : msg_data
        }));
    }

    function CheckWSReadyState() {
        programm_handler.ProcessWebSocketReadyState(this.socket.readystate);
    }
}
