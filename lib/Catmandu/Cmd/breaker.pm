package Catmandu::Cmd::breaker;

use Catmandu::Sane;

our $VERSION = '0.02';

use parent 'Catmandu::Cmd';
use Catmandu;
use Catmandu::Util;
use Catmandu::Breaker;
use namespace::clean;

sub command {
    my ($self, $opts, $args) = @_;

    unless (@$args == 1) {
        say STDERR "usage: $0 breaker file\n";
        exit 1;
    }

    my $file = $args->[0];

    my $io = Catmandu::Util::io($file);

    my $breaker = Catmandu::Breaker->new;

    $breaker->parse($io);
}

1;

__END__

=pod

=head1 NAME

Catmandu::Cmd::breaker - Parse Catmandu::Breaker exports

=head1 EXAMPLES

  catmandu breaker <BREAKER.FILE>

  $ catmandu convert XML --path book to Brealer --handler xml < t/book.xml > data.breaker
  $ catmandu breaker data.breaker

=cut