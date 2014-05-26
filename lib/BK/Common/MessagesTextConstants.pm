#!/usr/bin/env perl

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
        DBERRCOMMITMSG
        DBERRROLLBACKMSG
        DBERRHANDLEERRORMSG
        DBCONNMSG
        DBDISCONNMSG
        DBCOMMITMSG
        DBROLLBACKMSG
        AHSDIDEN
        AHSDDEL
        AHSDNEW
    );

    ##  --
    ##  doors exeptions

    use constant {
        DOORSERRORCODE => 'Error Code '
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
        DBERRCOMMITMSG      => 'Failed to Commit changes',
        DBERRROLLBACKMSG    => 'Failed to Rollback changes',
        DBERRHANDLEERRORMSG => 'Failed to Perform database actions: '
    };

    ##  --
    ##  db messages

    use constant {
        DBCONNMSG => 'Successfully Connected to Database',
        DBDISCONNMSG => 'Successfully Disconnected from Database',
        DBCOMMITMSG => 'Successfully Commited Changes',
        DBROLLBACKMSG => 'Successfully Rollback Changes'
    };

    ##  --
    ##  action handler messages

    use constant {
        AHSDIDEN => 'Data is the same no Changes are made',     ##  action handler save data is identically to the existing
        AHSDDEL  => 'Data is getting Deleted',                  ##  action handler save data is removed by user data is getting deleted in database
        AHSDNEW  => 'New Data is getting Inserted in Database'  ##  action handler save data is added a new value by user data is getting inserted in to database
    };

    ##  --
    ##  action handler exceptions

    use constant {
        AHUNKNOWNACTIONMSG => 'unknown request'
    };

}

1;
