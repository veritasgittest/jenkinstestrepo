#!usr/bin/perl
# Usage:
#	keyword_apply.pl file_path < file_contents
#
# [filter keyword_expansion]
#	clean  = .git_filters/keyword_clean.pl
#	smudge = .git_filters/keyword_apply.pl %f

$path = shift;
$path =~ /.*\/(.*)/;
$filename = $1;

if(0==length($filename)){
$filename = $path;
}

# Need to add filename and to use git log for this to be accurate.
$rev = `git log -- $path |head -n 3`;
$rev =~ /^Author:\s*(.*)\s*$/m
$author = $1;
$author =~ /\s*(.*)\s*<.*/;
$name = $1;
$rev =~ /^Date:\s*(.*)\s*$/m
$date = $1;
$rev =~ /^commit (.*)$/m;
$ident = $1;
#This copyrights content may come from a file
@copyright = (
'This is place holding copyrights text which must be replaced',
'All rights are reserved');
while(<>){
    s/\$Date[^\$]*\$/\$Date: $date \$/g;
    s/\$Author[^\$]*\$/\$Author: $author \$/g;
    s/\$Id[^\$]*\$/\$Id: $filename | $date | $name \$/g;
    s/\$File[^\$]*\$/\$File: $filename \$/g;
    s/\$Source[^\$]*\$/\$Source: $path \$/g;
	s/\$Revision[^\$]*\$/\$Revision: $ident \$/g;
    if ( /\s*\$Copyrights/ ) {
        $cflag = 1;
        $pre   = $`;
        $post  = $';
        if ( $post =~ /\$/ ) {
            $cflag = 0;
            $post = $';
            InsertCopyright( $pre, $post );
        }
        next;
    }
    if ( /\$/ && $cflag ) {
        $cflag = 0;
        $post  = $';
        InsertCopyright( $pre, $post );
        next;
    }
    next if ( $cflag );
    print;
}
