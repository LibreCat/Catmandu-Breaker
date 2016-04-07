use strict;
use warnings;
use Test::More;

use_ok 'Catmandu::Importer::Breaker';
require_ok 'Catmandu::Importer::Breaker';

my $text = <<EOF;
oai:search.ugent.be:ser01:000179913 {http://purl.org/dc/elements/1.1/}title Forst und Holz (1988).
oai:search.ugent.be:ser01:000179913 {http://purl.org/dc/elements/1.1/}publisher Hannover : Schaper,
oai:search.ugent.be:ser01:000179913 {http://purl.org/dc/elements/1.1/}date  n.d.
oai:search.ugent.be:ser01:000179913 {http://purl.org/dc/elements/1.1/}type  text
oai:search.ugent.be:ser01:000179913 {http://purl.org/dc/elements/1.1/}language  ger
oai:search.ugent.be:ser01:000179913 {http://purl.org/dc/elements/1.1/}description Verderzetting van: Der Forst- und Holzwirt [ISSN 0015-7961]
oai:search.ugent.be:ser01:000179913 {http://purl.org/dc/elements/1.1/}description Vanaf 2011 opgenomen in: AFZ. Der Wald [ISSN 1430-2713]
EOF

my $importer = Catmandu::Importer::Breaker->new(file => \$text);

ok $importer;

{
  my $data = $importer->first;

  is $data->{_id} , 'oai:search.ugent.be:ser01:000179913';
  is $data->{namespace} , 'http://purl.org/dc/elements/1.1/';
  is $data->{tag} , 'title';
  is $data->{data} , 'Forst und Holz (1988).';
}

done_testing;