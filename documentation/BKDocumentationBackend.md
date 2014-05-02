Author:
Anastassios Martakos
02.04.2014

# BK Documentation Backend

## Required Files
### Backend
  -  Doors.pm
  -  Scanner.pm
### Common
  -  BKFileHandler.pm
  -  CommonMessages.pm
  -  Constants.pm
  -  DatabaseAccess.pm
  -  MessagesTextConstants.pm

## Methods
### Doors.pm

#### new
self:
  -  _owner_desc
  -  _doors
  -  _msg

#### syntax
use Doors;

my $doors = Doors_new(ARRAY);

$doors->GetDoors();
$doors->SetDoors([doors]);
$doors->OpenDoor([door]);

### Scanner.pm

#### new
self:
  -  _owner_desc
  -  _input
  -  _msg
#### syntax
use Scanner

my $scanner = Scanner->new();

$scanner->GetInput();

Note this method only reads the input from the barcode scanner. It is nessesary that it is a method to do logging.
