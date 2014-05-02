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

ah.ProcessAction();

### AJAXData.js

#### Variables
  -  ajax_path
#### Functions
  -  AJAXGetData
  -  AJAXDone
  -  AJAXFail
#### syntax
var ajax_data = new AJAXData('https://ajax.data.com/');

ajax_data.AJAXGetData([msg_data_arg], [send_type]);

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

intervals_collector.RegisterInterval([function], [diff_time], [name]);
intervals_collector.RemoveInterval([name]);

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

programm_handler.InitializeProgramm();
programm_handler.InitializeConnTypeWebSockets();
programm_handler.InitializeConnTypeAJAX();
programm_handler.ConnectToWebSocket();
programm_handler.SetConnectionType();
programm_handler.RefreshData();
programm_handler.SaveData();
programm_handler.CheckBookboxStates();
programm_handler.CheckMSGDataObjects();

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
#### Functions
#### syntax
