#!/usr/bin/perl 
# ~/atlas/atlasmgr list_probe  | ./gen-dhcp-conf.pl   > 20130417-dhcp.conf
use strict;
my @F;
my $i = 32;

while (<>) {
	chomp;
	next unless (/^Probe/);
	@F = split /\s+/, $_;
	next unless ($F[0] =~ m/^Probe/);
	next if($F[2] < 9999);
	print "host probe$F[2] {\n";
	print "hardware ethernet $F[3];\n"; 
	printf "fixed-address %s;\n",  ipa();
	print "}\n";

} 

sub ipa() 
{

my $AB="192.168";
my $C=128;
my $D=0;
	$D = $i % 256;
	$C += int($i / 256);
	$i++;
	return "$AB\.$C\.$D";
}
