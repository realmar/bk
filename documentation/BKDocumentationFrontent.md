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

$ac->ProcessAction();
$ac->RefreshData();
$ac->SaveData();
$ac->GetAllEntries();
$ac->ToJSON();
$ac->FromJSON();
$ac->PrepareWebSocketData();
$ac->CollectAllErrors();
$ac->PrepareDataToSend();
