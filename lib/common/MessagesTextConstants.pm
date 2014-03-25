#!/usr/bin/env perl

BEGIN {

    package MessagesTextConstants;

    use Exporter 'import';

    our @EXPORT = qw(
        DBERRCONNMSG
        DBERRDISCONNMSG
        DBERRCREATEMSG
        DBERRREADMSG
        DBERRUPDATEMSG
        DBERRDELETEMSG
        DBERRCOMMITMSG
        DBERRROLLBACKMSG
    );

    ##  --
    ##  db error excetions

    use constant {
        DBERRCONNMSG     => 'Failed to Connect to Database',
        DBERRDISCONNMSG  => 'Failed to Disconnect from Database',
        DBERRCREATEMSG   => 'Failed to Create Entry in Database',
        DBERRREADMSG     => 'Failed to Read from Database',
        DBERRUPDATEMSG   => 'Failed to Update Entry in Database',
        DBERRDELETEMSG   => 'Failed to Detele Entry in Database',
        DBERRCOMMITMSG   => 'Failed to Commit changes',
        DBERRROLLBACKMSG => 'Failed to Rollback changes'
    };

}

1;
