#!/usr/bin/perl

my ( $cflag, $pre );

while ( <STDIN> ) {
    s/\$Id[^\$]*\$/\$Id\$/g;
    s/\$Date[^\$]*\$/\$Date\$/g;
    s/\$Author[^\$]*\$/\$Author\$/g; 
    s/\$Source[^\$]*\$/\$Source\$/g; 
    s/\$File[^\$]*\$/\$File\$/g; 
    s/\$Revision[^\$]*\$/\$Revision\$/g;
    if ( /\$Copyrights/ ) {
        $cflag = 1;
        $pre   = $`;
        my $post = $';
        if ( $post =~ /\$/ ) {
            $cflag = 0;
            $post  = $';
            print $pre . '$Copyrights$' . $post;
        }
        next;
    }
    if ( /\$/ && $cflag ) {
        $cflag = 0;
        my $post  = $';
        print $pre . '$Copyrights$' . $post;
        next;
    }
    next if ( $cflag );
    print;
}
