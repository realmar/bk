function BKWebSocket(ws_path_arg) {
    var socket;
    this.OpenWebSocket(ws_path_arg);
    this.socket.onopen = OnOpenWS();

    programm_handler.ProcessWebSocketReadyState(this.socket.readystate);

    this.socket.onmessage = OnMessageWS(e);
}

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
