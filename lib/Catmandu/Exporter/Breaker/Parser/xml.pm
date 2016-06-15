package Catmandu::Exporter::Breaker::Parser::xml;

use Catmandu::Sane;
use Moo;
use Catmandu::Breaker;
use Carp;
use Data::Dumper;
use namespace::clean;

our $VERSION = '0.01';

has breaker => (is => 'lazy');

sub _build_breaker {
    Catmandu::Breaker->new;
}

sub add {
    my ($self, $data, $io) = @_;

    my $identifier = $data->{_id} // $self->breaker->counter;

    $self->xpath_gen($data,[],sub {
        my ($tag,$value) = @_;

        $io->print(
            $self->breaker->to_breaker(
                $identifier ,
                $tag ,
                $value)
        );
    });

    1;
}

sub xpath_gen {
    my ($self,$data,$path,$callback) = @_;

    if (ref($data) eq 'HASH') {
        for my $key (keys %$data) {
            my $value = $data->{$key};
            if (ref($value)) {
                $self->xpath_gen($value,[@$path,$key],$callback);
            }
            else {
                $callback->(join("/",@$path,$key),$value);
            }
        }
        return;
    }
    elsif (ref($data) eq 'ARRAY') {
        for my $value (@$data) {
            if (ref($value)) {
                $self->xpath_gen($value,$path,$callback);
            }
            else {
                $callback->(join("/",@$path),$value);
            }
        }
    }
}

1;

__END__