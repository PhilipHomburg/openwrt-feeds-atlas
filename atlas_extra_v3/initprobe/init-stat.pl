#!/usr/bin/perl

use strict;
my %dates;
my %s;
my %lapt;
my $total;
my $TD = '<td style="text-align: right;">';
my $TDD ='</td>';
my $H3 = '<h3>';
my $H33 = '</h3>'; 
my %macsP2;
my %macsP1;
my %machP1E;
my %machP2E;

while (<>) {
	chomp;
	my @F = split /\s+/, $_;
	$F[0] =~ m/-prod-(\w)/; 
	my $l=$1; 
	$F[0] =~ m/:(\d+)/;
	my $date=$1;  	
	if((($F[1] eq "SUCCESS") && $l eq 'v')) {
		# verified probes
		if(defined($macsP2{$F[4]})) {
			print "seeing duplicates $F[4] $_\n";
			next;
		}
		else {
			$macsP2{$F[4]} = 1;
			$s{'p2'}{$date}++;
			$lapt{'p2'}++;
			unless(defined ( $dates{$date})) {
				$dates{$date} = 0;
			}
			#print "$l $date $dates{$date} $s{'p2'}{$date} \n";
		}
	}
	elsif($F[1] eq "SUCCESS") {
		#initialized probes 
		$lapt{$l}++;
		$total++;
		$s{$l}{$date}++;
		$dates{$date}++;
 		#print "$l $date $s{$l}{$date}\n";
	}
	if(($F[1] eq "ERROR") && ($F[3] eq "probe") ) {
		#print "$date $F[4]\n";
		$s{'err'}{$date}++;
		$lapt{'err'}++;
	}
}

END { 
	printf ("<table> <tr><td> date </td>");
	foreach my$l (sort {$a cmp $b} keys %s) {
		printf (" <td> %5s</td>", $l);
	}
	printf (" <td> P1 </td> </tr>\n");
	foreach my $d (sort {$a <=> $b} keys %dates) {
		print "<tr>  <td> $d </td>";
		foreach my $l (sort keys %s) {
			printf " $TD %5d $TDD", $s{$l}{$d};
		}
		printf "$TD %6d $TDD </tr>\n",  $dates{$d}; 
	}
	printf ("<tr> <td>Total # </td>");
	foreach my$l (sort {$a cmp $b} keys %s) {
		printf ("$TD %5d $TDD", $lapt{$l});
	}
	printf ("$TD %6d $TDD </tr>\n</table>\n", $total);
}
