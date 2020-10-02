#!/usr/bin/perl -w
#
# Copyright: GPL2
#
# author: Egon Willighagen (egon.w@linuxfocus.org)
#
use strict;
use diagnostics;

my $lfdir = "/home/flo/LinuxFocus";

if (scalar(@ARGV) != 1) {
    print "Error: must give file to process!\n";
    exit(1);
}

my $file = $ARGV[0];
if (!-e "$file") {
    print "Error: file $file does not exist!\n";
    exit(1);
}

my $target = $file;
$target =~ s/pre$/shtml/;

print "Converting $file to $target...\n";

open(OUTPUT, ">$target");
open(INPUT, "<$file");
my $line = "";
while ($line = <INPUT>) {
    if ($line =~ m/\<\!\-\-\s*macro\s*xslt\s*([^\s]*)\s*(.*)\-\-\>/i) {
        # try to expand macro
        my $stylesheet = $1;
        my $params = $2;
        chomp($params);
        print "Stylesheet: $stylesheet\n    params: $params\n";
        if (!-e "$lfdir/Nederlands/xml/stylesheets/$stylesheet.xslt") {
            print "Warning: stylesheet $stylesheet does not exist!\n";
		} else {
            if (length $params > 0) {
                print OUTPUT `cd $lfdir/Nederlands/xml; bin/xml2any db/lfdb.nl.xml stylesheets/$stylesheet.xslt $params`;
            } else {
                print OUTPUT `cd $lfdir/Nederlands/xml; bin/xml2any db/lfdb.nl.xml stylesheets/$stylesheet.xslt`;
	    }
        }
    } else {
        print OUTPUT $line;
    }
}
close(INPUT);
close(OUTPUT);

