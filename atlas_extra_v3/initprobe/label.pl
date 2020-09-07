#!/usr/bin/perl -I/home/atlas/HTML-Barcode-Code128-0.11/blib/lib -I/Users/antony/perl-lib/lib/ -I/opt/local/lib/perl5/site_perl/5.12.4/darwin-thread-multi-2level

# labelfmt
# format bib db so that we can print labels
# gets standard sqlite text input:
# 663|9785170271955|Wat 3a Warom (russisch)|B. Barhep|computer|1998|1221413368|

use strict;
use warnings;
use Barcode::Code128;

my $labelfile = "/tmp/label";

$_ = <>;  # only read one label at the time

my ($mac, $id , $extra) = split /\s+/, $_;

$mac =~ s/://g;

$id .= " " . $extra if(defined $extra);

my $png_filename = "code128.png";
genPNG($png_filename);

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
MAC $mac \\\\
Probe ID $id \\\\\
http://probev3.ripe.net\\\\
\\end{tabular}
EOF2

print <<"EOF3";
\\end{document}
EOF3
close TEX;

# now we make the pdf - after we clean up, the mess
if (system("pdflatex $labelfile") != 0) {
warn "Er ging iets falikant verkeerd";
} else {
unlink $labelfile . ".log", $labelfile . ".aux";
}
 

sub genPNG()
{
my($filename)  = @_;

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
print PNG $code->png($mac);
close(PNG);
}
