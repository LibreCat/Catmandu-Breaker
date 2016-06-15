package Catmandu::Breaker;

our $VERSION = '0.01';

use Moo;
use Carp;

has _counter => (is => 'ro', default => 0);

sub counter {
	my ($self) = @_;
	$self->{_counter} = $self->{_counter} + 1;
	$self->{_counter};
}

sub to_breaker {
	my ($self,$identifier,$tag,$value) = @_;

	croak "usage: to_breaker(idenifier,tag,value)"
			unless defined($identifier)
					&& defined($tag) && defined($value);

	$value =~ s{\n}{\\n}mg;

	sprintf "%s\t%s\t%s\n"
    					, $identifier
    					, $tag
    					, $value;				
}

sub from_breaker {
	my ($self,$line) = @_;

	my ($id,$tag,$value) = split(/\s+/,$line,3);

	croak "error line not in breaker format : $line"
			unless defined($id) && defined($tag) && defined($value);

  return +{
    	identifier => $id ,
    	tag        => $tag ,
    	value      => $value
  };
}

1;

__END__

=pod

=head1 NAME

Catmandu::Breaker - Package that exports data in a Breaker format

=head1 SYNOPSIS

  # From the command line

  # Using the default breaker
  $ catmandu convert JSON to Breaker < data.json

  # Using a OAI_DC breaker 
  $ catmandu convert OAI --url http://biblio.ugent.be/oai to Breaker --handler oai_dc

  # Using a MARCXML breaker
  $ catmandu convert MARC to Breaker --handler marc

  # Using an XML breaker
  $ catmandu convert XML --path book to Brealer --handler xml < t/book.xml > data.breaker
  
  # Find the usage of fields in the XML file above
  $ cat data.breaker | cut -f 2 | sort | uniq -c

  # Parse the Breaker format
  $ catmandu convert Breaker < data.breaker

  # Parse the Breaker format group values by record
  $ catmandu convert Breaker --group 1 < data.breaker

=head1 DESCRIPTION

Inspired by the article "Metadata Analysis at the Command-Line" by Mark Phillips in
L<http://journal.code4lib.org/articles/7818> this exporter breaks a OAI-PMH DC harvest
into the Breaker format which can be analyzed further by command line tools.

=head1 BREAKER FORMAT

   <record-identifier><tab><metadata-field><tab><metadata-value><tab><metadatavalue>...

=head1 MODULES
 
=over
 
=item * L<Catmandu::Exporter::Breaker>
 
=item * L<Catmandu::Importer::Breaker>

=back

=head1 SEE ALSO

L<Catmandu>

=head1 AUTHOR
 
Patrick Hochstenbach, C<< <patrick.hochstenbach at ugent.be> >>

=cut