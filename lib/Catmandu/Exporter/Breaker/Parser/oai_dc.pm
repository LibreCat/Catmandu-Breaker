package Catmandu::Exporter::Breaker::Parser::oai_dc;

use Catmandu::Sane;
use Moo;
use Catmandu::Breaker;
use namespace::clean;

our $VERSION = '0.01';

has breaker => (is => 'lazy');

sub _build_breaker {
    Catmandu::Breaker->new;
}

sub add {
    my ($self, $data, $io) = @_;

    my $identifier = $data->{_id} // $self->breaker->counter;

    for my $element (qw(
    	title creator contributor subject publisher date 
    	type format identifier source language rights
    	description coverage relation)) {

    	next unless exists $data->{$element};

    	my $values = $data->{$element};

    	for my $val (@$values) {
    		$val =~ s{\n}{\\n}mg;
            $val =~ s{\t}{\\t}mg;
    		$io->print(
                $self->breaker->to_breaker(
                    $identifier ,
                    $element ,
                    $val
                )
            );
    	}
    }

    1;
}

1;

__END__