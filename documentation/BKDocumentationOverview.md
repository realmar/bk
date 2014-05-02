Author:
Anastassios Martakos
02.04.2014

# BK Documentation Overview

## Content
  -  BKDocumentationBackend.md
  -  BKDocumentationFrontent.md
  -  BKDocumentationJavaScript.md

## Programming Style
  -  Full Object Orientated Server and Client
  -  Variables
       -  low letters, words seperated with underscore
            -  this_var, another_var
  -  Functions, Classes, everything else
       -  capital start, no word seperation
            -  ThisFunction, AnotherFunction
  -  Constants
       -  all caps
            -  THISCONST, ANOTHERCONST

## Files
### Perl

#### Backend
  -  Doors.pm
  -  Scanner.pm
#### Frontend
  -  ActionHandler.pm
#### Common
  -  BKFileHandler.pm
  -  CommonMessages.pm
  -  Constants.pm
  -  DatabaseAccess.pm
  -  MessagesTextConstants.pm

### JavaScript

#### Executation
  -  InitializeFunctions.js
  -  Main.js
#### Functions
  -  DOMChanges.js
#### Prototypes
  -  ActionHandler.js
  -  AJAXData.js
  -  Intervals.js
  -  ProgrammHandler.js
  -  WebSockets.js
#### Variables
  -  Constants.js
  -  VariablesDefinitions.js

## Working Flow
### Backend
Is wainting for input from the barcode scanner, then it checks the database for matching entries to the input. If this is the case is open the correspondent door and removes the user which is currently registered for that door from the Database.

### Frontent
Processes all request which are comming from the browser of the user, which contains sending database content to display the currently registered users related to the doors and editing this content. The Connection can be done using AJAX or WebSockets.

## OOP Tree
You have to ability for **logging** but you **have to be an object** to do so. For this there is an OOP Tree you as Object have a **parent object** called **CommonMessages** which has some functions for logging. You allways call the logging functions as if it would belong to you over the **SUPER** method. With this you pass your **$self** object, which stores some information about you which is nessecary for logging, and create a log message.  
Every Object has an **CommonMessage** object which only belongs to it.  
The **CommonMessage** object is calles **newcomsg** for initialization.

## Methods
### Common
#### BKFileHandler.pm

##### new
self:
  -  _owner_desc
  -  _filehandle
  -  _msg
##### syntax
use BK::Common::BKFileHandler;

my $bk_fh = BKFileHandler->new('>>', '/file');

$bk_fh->OpenFileHandle([mode], [file]);
$bk_fh->CloseFileHandle();
$bk_fh->WriteToFile([msg]);

#### CommonMessages.pm

##### new
self:
  -  [shift]
err:
  -  _error_type
  -  _error_msg
  -  _err_count
##### syntax
###### Usage
use parent -norequire 'CommonMessages';

sub new {
    $class = shift;
    $self = {
        _owner_desc => [_owner_desc],
        _msg        => undef
    };
    bless $self, $class;
    $self->SUPER::newcomsg();
}

$self->SUPER::ThrowMessage([msg_prio], [msg_typ], [msg_string]);
###### Methods only
  -  InitCoMSG
       -  Initialize the logging object
  -  ThrowMessage
       -  log a message, also seperates msg log from error log
  -  CreateLogString
       -  Creates the logging string, with time, owner_typ, msg_prio, msg_typ, msg_string
  -  LogError
       -  loggs an error, passes the string to the filehandler object
  -  LogMessage
       -  loggs an message, passes the strin gto the filehandler object

#### DatabaseAccess.pm
##### new
self:
  -  _owner_desc
  -  _db
  -  _msg
##### syntax
use DatabaseAccess;

my $db_conn = DatabaseAccess->new('sqlite3', '/file');

$db_conn->ConnectToDatabase([driver], [file]);
$db_conn->DisconnectFromDatabase();
$db_conn->CreateEntryDatabase([table], [column]);
$db_conn->ReadEntryDatabase([table], [name_values]);
$db_conn->UpdateEntryDatabase([table], [set_values], [name_values]);
$db_conn->DeleteEntryDatabase([table], [name_values]);
$db_conn->CommitChanges();
$db_conn->RollbackChanges();
