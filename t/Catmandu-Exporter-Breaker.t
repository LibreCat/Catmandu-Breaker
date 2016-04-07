#!perl -T

use strict;
use warnings;
use Test::More;

BEGIN {
    use_ok 'Catmandu::Exporter::Breaker';
}

require_ok 'Catmandu::Exporter::Breaker';

done_testing 2;
