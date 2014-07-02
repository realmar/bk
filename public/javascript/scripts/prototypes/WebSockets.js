
/////////////////////////////////////////////////////////
//  Project Name:     BuecherkastenBibliothek BK
//  Author:           Anastassios Martakos
//  Language:         English / JavaScript
//  Created For / At: ETH Zuerich Department Physics
/////////////////////////////////////////////////////////

//  Description
//
//  Makes WebSocket connections with the Server and sends and receives requests and answers which it gives to the ActionHandler
//
//  Synopsis
//
//  var web_socket = new BKWebSocket(ws_path);
//  web_socket.SendMSGWS('ahrefresh', 'null');

function BKWebSocket(ws_path_arg) {
    this.socket;  //  Stores the WebSocket

    this.OpenWebSocket  = OpenWebSocket;   //  Connect to WebSocket
    this.OnOpenWS       = OnOpenWS;        //  Called when the WebSocket if initialized and ready to use
    this.OnMessageWS    = OnMessageWS;     //  Called if a Messages comes in the WebSocket
    this.OnCloseWS      = OnCloseWS;       //  Called if the WebSocket is closed
    this.OnErrorWS      = OnErrorWS;       //  Called if the WebSocket throws an Error
    this.CloseWebSocket = CloseWebSocket;  //  Close the WebSocket
    this.SendDataWS     = SendDataWS;      //  Send Data with the WebSocket, waits until the WebSocket is ready then sends the Data
    this.SendMSGWS      = SendMSGWS;       //  Prepare Data to Send with the WebSocket then sends Data over SendDataWS to the Server
    this.KeepAliveWS    = KeepAliveWS;     //  Sends KeepAlive to the Server, is to no loose the Connection to the Server

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
            setTimeout(WaitForWebSocket(), programm_handler.ws_wait);
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
