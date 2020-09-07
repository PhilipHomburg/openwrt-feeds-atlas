#!/usr/bin/perl -I/home/atlas/HTML-Barcode-Code128-0.11/blib/lib -I/Users/antony/perl-lib/lib/ -I/opt/local/lib/perl5/site_perl/5.12.4/darwin-thread-multi-2level -I/opt/local/lib/perl5/site_perl/5.12.4/ -I/Users/antony/.cpan/build/Net-SSH-Perl-1.36-MYISCN/lib

use strict;
use warnings;
use Barcode::Code128;
#use Net::SSH::Perl; 
my $labelfile = "/tmp/label";

sub genPNG($$);

sub genPNG($$)
{
	my $filename = shift;
	my $mac_address = shift;

	use Barcode::Code128 'FNC1';
	my $code = new Barcode::Code128;
	$code->code('A');     # Enforce 128A?
		open(PNG, ">$filename") or die "Can't write code128.png: $!\n";
	binmode(PNG);
	$code->width(220);
	$code->height(50);
	$code->border(0);
	$code->scale(1);
	$code->show_text(0);
	$code->top_margin(4);
	$code->bottom_margin(4);
	$code->left_margin(2);
	$code->right_margin(2);
	print PNG $code->png($mac_address);
	close(PNG);
}

sub createLabel ($$) 
{
my($mac, $id) = @_; 

my($mac_address, $probe_id) = @_;
my $png_filename = "code128.png";
genPNG($png_filename, $mac);

open TEX, ">", $labelfile . ".tex"; # yes, unsafe
select TEX;
print <<'EOF1';
\documentclass{memoir}
\setstocksize{32mm}{67mm} %% dymo 99012 paper
\setlength{\headheight}{0mm}
\setlength{\headsep}{-28mm}
\setlength{\textwidth}{53mm} %% -4 mm
\setlength{\textheight}{26mm} %% -6 mm
\setlength{\oddsidemargin}{-18mm}
\setlength{\parindent}{0mm}
\usepackage{graphicx}

\begin{document}
\pagestyle{empty}
\sffamily
EOF1

print <<"EOF2";
\\includegraphics[width=5cm]{$png_filename}

\\begin{tabular}{ l c r}
MAC $mac_address \\\\
Probe ID $probe_id \\\\\
http://atlas.ripe.net\\\\
\\end{tabular}
EOF2

print <<"EOF3";
\\end{document}
EOF3
close TEX;

# now we make the pdf - after we clean up, the mess
if (qx[pdflatex $labelfile 2>/dev/null] != 0) {
warn "Er ging iets falikant verkeerd";
} else {
unlink $labelfile . ".log", $labelfile . ".aux";
}
select STDOUT;
}
 

#main 
while (1) {

	my $m;

	print "Enter MAC : ";
	$m =  <>;
	chomp $m;
	$m =~ s/://g;

	unless ( length($m) == 12) {
		print " is NOT recognized as a MAC address not 12 charecters\n";
		next;
	}

	$m =~ m/[0-9A-Fa-f]*(.*)/;
	if(defined $1 and (length($1) > 1)) {
		print " is NOT recognized as a MAC address. $1 is not [0-9A-Fa-f]* \n";
                next;
	}

	my $labelfilepdf = "./label.pdf";
	unlink $labelfilepdf;
	#my $verify_cmd = "/home/atlas/verify/probe-verify-mr3020.sh $m";

	my $extra;

	my @lines = qx[./verify-with-https.sh "$m"];

	next unless($lines[0]);
	chomp $lines[0];

	my @f = split /\s+/, $lines[0];
	next unless($f[0]);

	my $mac; 
	my $id;
	if($f[1] eq "SUCCESS") {
		$mac = $f[4];
		$id = $f[7];
		print "SUCCESS 1 MAC = $mac Probe ID $id\n"; 
		$mac =~ s/://g;
		createLabel ($mac, $id);

		if (-e "$labelfilepdf")
		{
			my @lines = qx[lp -d DYMO_LabelWriter_450 "$labelfilepdf"];
		}

	}
	else {
		print "$lines[0]\n";
	}
	
}
