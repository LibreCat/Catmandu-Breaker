package Catmandu::Exporter::Breaker;

use Catmandu::Sane;
use Catmandu::Util qw(:is);
use Moo;
use Carp;
use namespace::clean;

our $VERSION = '0.01';

with 'Catmandu::Exporter';

has handler => (is => 'rw', default => sub {'oai_dc'} , coerce => \&_coerce_handler );

sub _coerce_handler {
  my ($handler) = @_;

  return $handler if is_invocant($handler) or is_code_ref($handler);

  if (is_string($handler) && !is_number($handler)) {
      my $class = $handler =~ /^\+(.+)/ ? $1
        : "Catmandu::Exporter::Breaker::Parser::$handler";

      my $handler;
      eval {
          $handler = Catmandu::Util::require_package($class)->new;
      };
      if ($@) {
        croak $@;
      } else {
        return $handler;
      }
  }
  else {
  	  die "Need a Breaker::Parser"
  }
}

sub add {
	my ($self, $data) = @_;

	$self->handler->add($data,$self->fh);
}

1;

__END__

=pod

=head1 NAME

Catmandu::Exporter::Breaker - Package that exports OAI-PMH DC in a Breaker format

=head1 SYNOPSIS

  # From the command line
  $ catmandu convert OAI --url http://biblio.ugent.be/oai to Breaker

  # Using a MARCxml breaker
  $ catmandu convert OAI --url http://lib.ugent.be/oai --metadataPrefix marcxml to Breaker --handler marc

=head1 DESCRIPTION

Inspired by the article "Metadata Analysis at the Command-Line" by Mark Phillips in
L<http://journal.code4lib.org/articles/7818> this exporter breaks a OAI-PMH DC harvest
into the Breaker format which can be analyzed further by command line tools.

=head1 BREAKER FORMAT

   <record-identifier><tab><metadata-field><tab><metadata-value>

=head1 SEE ALSO

L<Catmandu::Importer::Breaker>

=cut

