package Catmandu::Exporter::Breaker::Parser::json;

use Catmandu::Sane;
use Moo;
use Catmandu::Expander;
use Catmandu::Breaker;
use namespace::clean;

our $VERSION = '0.03';

has breaker => (is => 'lazy');

sub _build_breaker {
    Catmandu::Breaker->new;
}

sub add {
    my ($self, $data, $io) = @_;

    my $identifier = $data->{_id} // $self->breaker->counter;

    my $collapse   = Catmandu::Expander->collapse_hash($data);
    delete $collapse->{_id};

    for my $tag (sort keys %$collapse) {
        my $value = $collapse->{$tag};

        $tag =~ s{\.\d+}{[]}g;

        $io->print(
            $self->breaker->to_breaker(
                $identifier ,
                $tag ,
                $value)
        );
    }

    1;
}

1;

__END__
