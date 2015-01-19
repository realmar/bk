#!/usr/bin/env perl

#########################################################
##  Project Name:     BuecherkastenBibliothek BK
##  Author:           Anastassios Martakos
##  Language:         English / Perl
##  Created For / At: ETH Zuerich Department Physics
#########################################################

BEGIN {

    package MessagesTextConstants;

    use Exporter 'import';

    our @EXPORT = qw(
        DOORSERRORCODE
        DOORSNUMBER
        DOORSUSERNAME
        DBERRCONNMSG
        DBERRDISCONNMSG
        DBERRCREATEMSG
        DBERRREADMSG
        DBERRUPDATEMSG
        DBERRDELETEMSG
        DBERRBEGINWORKMSG
        DBERRCOMMITMSG
        DBERRROLLBACKMSG
        DBCONNMSG
        DBDISCONNMSG
        DBBEGINWORKMSG
        DBCOMMITMSG
        DBROLLBACKMSG
        AHSDIDEN
        AHSDDEL
        AHSDNEW
        AHSAVEDATAMSG
        AHSAVEDATANOCHANGESMSG
        AHOPENDOORSMSG
        AHUNKNOWNACTIONMSG
        AHERRSAVEDATAMSG
        AHERRREFRESHDATAMSG
        AHERROPENDOORSMSG
        AHERRUSERINPUTMSG
    );

    ##  --
    ##  doors exeptions

    use constant {
        DOORSERRORCODE => 'Error Code ',
    };

    ##  --
    ##  door messages

    use constant {
        DOORSNUMBER   => 'Door Number: ',
        DOORSUSERNAME => ' For Username: '
    };

    ##  --
    ##  db error excetions

    use constant {
        DBERRCONNMSG        => 'Failed to Connect to Database',
        DBERRDISCONNMSG     => 'Failed to Disconnect from Database',
        DBERRCREATEMSG      => 'Failed to Create Entry in Database',
        DBERRREADMSG        => 'Failed to Read from Database',
        DBERRUPDATEMSG      => 'Failed to Update Entry in Database',
        DBERRDELETEMSG      => 'Failed to Detele Entry in Database',
        DBERRBEGINWORKMSG   => 'Failed to Begin Work in Database, start transaction',
        DBERRCOMMITMSG      => 'Failed to Commit changes, stop transaction',
        DBERRROLLBACKMSG    => 'Failed to Rollback changes, rollback transaction',
    };

    ##  --
    ##  db messages

    use constant {
        DBCONNMSG => 'Successfully Connected to Database',
        DBDISCONNMSG => 'Successfully Disconnected from Database',
        DBBEGINWORKMSG => 'Successfully Begin Work, start transaction',
        DBCOMMITMSG => 'Successfully Commited Changes, stop transaction',
        DBROLLBACKMSG => 'Successfully Rollback Changes, rollback transaction'
    };

    ##  --
    ##  action handler messages

    use constant {
        AHSDIDEN => 'Data is the same no Changes are made',     ##  action handler save data is identically to the existing
        AHSDDEL  => 'Data is getting Deleted',                  ##  action handler save data is removed by user data is getting deleted in database
        AHSDNEW  => 'New Data is getting Inserted in Database',  ##  action handler save data is added a new value by user data is getting inserted in to database
        AHSAVEDATAMSG => 'Successfully saved your Data to the Database',
        AHSAVEDATANOCHANGESMSG => 'The Database is Up To Date nothing has to be saved',
        AHOPENDOORSMSG => 'The Door(s) has been succesfully Oppened, please check the BookBox'
    };

    ##  --
    ##  action handler exceptions

    use constant {
        AHUNKNOWNACTIONMSG  => 'unknown request',
        AHERRSAVEDATAMSG    => 'Failed to save your Data to the Database, please try again later. If the Problem preexists, contact your Informatic Service Group.',
        AHERRREFRESHDATAMSG => 'Failed to Refresh the Data, please try again later. If the Problem preexists, contact your Informatic Service Group',
        AHERROPENDOORSMSG   => 'Failed to open the Door(s), if the Problem preexists, contact your Informatic Service Group',
        AHERRUSERINPUTMSG   => 'A User tried to access his / her book at the bookshelf but BK wasnt able to open the door, if the problem preexists, contact your Informatic Service Group'
    };

}

1;
