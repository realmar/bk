Author:
Anastassios Martakos
02.04.2014

# BK Documentation Frontent

## Required Files
### Frontent
  -  ActionHandler.pm
### Common
  -  BKFileHandler.pm
  -  CommonMessages.pm
  -  Constants.pm
  -  DatabaseAccess.pm
  -  MessagesTextConstants.pm

## Methods
### ActionHandler

#### new
self:
  -  _owner_desc
  -  _action
  -  _data
  -  _db_conn
  -  _proc_ac
  -  _msg
#### syntax
use ActionHandler;

my $ac = ActionHandler->new('refresh', 'nodata');

$ac->ProcessAction();         //  Determines from the [action] given what operation it should execute
$ac->RefreshData();           //  Gets all data from the database and sends it to the client
$ac->SaveData();              //  Write all data from the client to the database and RefreshData afterwards
$ac->GetAllEntries();         //  Gets all entries from the database
$ac->ToJSON();                //  converts an object to a JSON string
$ac->FromJSON();              //  converts a string to an object
$ac->PrepareWebSocketData();  //  Prepare the data for transmission over WebSockets
$ac->CollectAllErrors();      //  Collects all Errors for data transmission to the client
$ac->PrepareDataToSend();     //  Prepares the data for transmission to the client
