package Catmandu::Breaker;

our $VERSION = '0.01';

1;

__END__

=pod

=head1 NAME

Catmandu::Breaker - Package that exports OAI-PMH DC in a Breaker format

=head1 SYNOPSIS

  # From the command line
  $ catmandu convert OAI --url http://biblio.ugent.be/oai to Breaker

  # Using a MARCXML breaker
  catmandu convert OAI --url http://lib.ugent.be/oai --metadataPrefix marcxml to Breaker --handler marcxml

=head1 DESCRIPTION

Inspired by the article "Metadata Analysis at the Command-Line" by Mark Phillips in
L<http://journal.code4lib.org/articles/7818> this exporter breaks a OAI-PMH DC harvest
into the Breaker format which can be analyzed further by command line tools.

=head1 BREAKER FORMAT

   <record-identifier><tab><metadata-field><tab><metadata-value><tab><metadatavalue>...

=head1 MODULES
 
=over
 
=item * L<Catmandu::Exporter::Breaker>
 
=back

=head1 SEE ALSO

L<Catmandu::Exporter::Breaker>

=head1 AUTHOR
 
Patrick Hochstenbach, C<< <patrick.hochstenbach at ugent.be> >>

=cut