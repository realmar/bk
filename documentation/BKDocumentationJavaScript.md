Author:
Anastassios Martakos
02.04.2014

# BK Documentation JavaScript

## Required Files
### Executation
  -  InitializeFunctions.js
  -  Main.js
### Functions
  -  DOMChanges.js
### Prototypes
  -  ActionHandler.js
  -  AJAXData.js
  -  Intervals.js
  -  ProgrammHandler.js
  -  WebSockets.js
### Variables
  -  Constants.js
  -  VariablesDefinitions.js

## Methods
### ActionHandler.js

#### Variables
  -  msg_data
#### Functions
  -  ProcessAction
#### syntax
var ah = new ActionHandler('nodata');

ah.ProcessAction();  //  Processes the data which comes from the server, mainly insert it into the GUI

### AJAXData.js

#### Variables
  -  ajax_path
#### Functions
  -  AJAXGetData
  -  AJAXDone
  -  AJAXFail
#### syntax
var ajax_data = new AJAXData('https://ajax.data.com/');

ajax_data.AJAXGetData([msg_data_arg], [send_type]);  //  Sends an AJAX Request and process the respond afterwards

  -  AJAXDone
       -  Called when the AJAX Request is successfully completed
  -  AJAXFail
       -  Called when the AJAX Request is not successfully completed

### Intervals.js

#### Variables
  -  intervals
#### Functions
  -  RegisterInterval
  -  RemoveInterval
#### syntax
var intervals_collector = new Intervals();

intervals_collector.RegisterInterval([function], [diff_time], [name]);  //  Register an interval
intervals_collector.RemoveInterval([name]);                             //  Remoce an interval

### ProgrammHandler.js

#### Variables
  -  intervals_collector
  -  conn_type
  -  conn_attempt
  -  bk_websocket
  -  bk_ajax_data
  -  ws_tries
  -  ws_wait
  -  last_data_state
#### Functions
  -  InitializeProgramm
  -  InitializeConnTypeWebSockets
  -  InitializeConnTypeAJAX
  -  ConnectToWebSocket
  -  SetConnectionType
  -  RefreshData
  -  SaveData
  -  CheckBookboxStates
  -  CheckMSGDataObjects
#### syntax
var programm_handler = new ProgrammHandler();

programm_handler.InitializeProgramm();            //  Initialized the programm_handler which starts off with trying to connect to an WebSocket and if this fails to connect with AJAX, then register the according intervals for each connection method and come other intervals for the input check and for the msg check
programm_handler.InitializeConnTypeWebSockets();  //  Removes the AJAX intervals, register some new intervals for the WebSockets and changes the connection type
programm_handler.InitializeConnTypeAJAX();        //  Removes the WebSockets intervals, initialize the AJAXData object, add some intervals for AJAXData and changes the connection type
programm_handler.ConnectToWebSocket();            //  Sets the current WebSockets variable to null and initialize a new WebSockets object
programm_handler.SetConnectionType();             //  Sets the connection type
programm_handler.RefreshData();                   //  Refresh the data in the GUI, sends the request the server
programm_handler.SaveData();                      //  Save the data in the GUI to the server, sends the data to the server
programm_handler.CheckBookboxStates();            //  Checks if the content of the input fields has changed or collides and mark them respectively
programm_handler.CheckMSGDataObjects();           //  Checks if there is a need to display messaging objects in the GUI and if not hides them

programm_handler.intervals_collector.intervals  //  display all current active intervals
programm_handler.bk_websocket.socket            //  native WebSocket
programm_handler.bk_ajax_data.ajax_path         //  AJAX URL Path
programm_handler.bk_websocket                   //  WebSockets Object
programm_handler.bk_ajax_data                   //  AJAXData Object
programm_handler.intervals_collector            //  Intervals Object

The **programm_handler** is the object which controlls the whole client side part from the GUI to the Data Transmissions. It determines by itself if it **can use Websockets or AJAX** for data transmissions. First it makes an AJAX Connection then it tries to connect with WebSockets if this is successfull the data transmissions is made with WebSockets. If they are not available the data transmission is made with AJAX. The fallback to AJAX and the upgrade to WebSockets is automatically but the prefered mode is WebSockets.  
If BK is operating with WebSockets the User will experience a huge performace increase what data loading and Data Saving includes, basically the whole programm will run faster and smoother. But WebSockets are not on all Browser supportet because it is a new technology.  
The programm_handler register several intervals for AJAX and within that an interval which tries to connect to WebSockets and several for Websockets.

### WebSockets.js

#### Variables
  -  socket
#### Functions
  -  OpenWebSocket
  -  OnOpenWS
  -  OnMessageWS
  -  OnCloseWS
  -  OnErrorWS
  -  CloseWebSocket
  -  SendDataWS
  -  SendMSGWS
  -  KeepAliveWS
#### syntax
var websocket = new WebSockets('wss://websocket.datatransactions.com/ws');

websocket.OpenWebSocket([ws_path_arg]);
websocket.CloseWebSocket();
websocket.SendDataWS([data]);
websocket.SendMSGWS([action], [msg_data]);
websocket.KeepAliveWS();
