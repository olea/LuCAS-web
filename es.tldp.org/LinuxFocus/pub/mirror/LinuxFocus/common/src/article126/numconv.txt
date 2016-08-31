#!/usr/bin/perl -w
# vim: set sw=8 ts=8 si et:
# 
# uncomment strict to make perl compiler very 
# strict about declarations:
#use strict;
# global variables:
use vars qw($opt_d $opt_x $opt_h);
use Getopt::Std;
#
&getopts("d:x:h")||die "ERROR: No such option. -h for help\n";
&help if ($opt_h);
if ($opt_d && $opt_x){
        die "ERROR: options -x and -d are mutual exclusive.\n";
}
if ($opt_d){
        printf("decimal: %d\n",hex($opt_d));
}elsif ($opt_x){
        printf("hex: %X\n",$opt_x);
}else{
        # wrong usage -d or -x must be given:
        &help;
}
#-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
sub help{
        print "convert a number to hex or dec.
USAGE: numconv [-h] -d hexnum
       numconv [-h] -x decnum

OPTIONS: -h this help 
EXAMPLE: numconv -d 1af
\n";
        exit;
}
#-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
__END__ 
