package Catmandu::Exporter::Breaker::Parser::oai_dc;

use Catmandu::Sane;
use Moo;
use namespace::clean;

our $VERSION = '0.01';

sub add {
    my ($self, $data, $io) = @_;
    
    return if $data->{_status} eq 'deleted';

    my $identifier = $data->{_identifier};

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
                sprintf("%s\t{http://purl.org/dc/elements/1.1/}%s\t%s\n"
    					, $identifier
    					, $element
    					, $val)
            );
    	}
    }

    1;
}

1;

__END__