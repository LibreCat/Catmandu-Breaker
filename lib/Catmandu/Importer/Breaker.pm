package Catmandu::Importer::Breaker;

use Catmandu::Sane;

our $VERSION = '0.01';

use Moo;
use namespace::clean;

with 'Catmandu::Importer';

sub generator {
    my ($self) = @_;
    sub {
        state $count   = 0;
        state $line;

        while ( defined( $line = $self->fh->getline ) ) {
            chomp $line;
            next if $line =~ /^\s*#/;

            my ($id,$field,$values) = split(/\s+/,$line,3);

            my ($namespace,$tag);

            if ($field =~ /^{(.*)}(\S+)/) {
                $namespace = $1;
                $tag = $2;
            }

            my $data = {
                _id       => $id ,
                field     => $field ,
                namespace => $namespace ,
                tag       => $tag ,
                data      => $values , 
            };

            return $data;
        }

        return;
    };
}

1;

__END__

=pod

=head1 NAME

Catmandu::Importer::Breaker - Package that imports the Breaker format

=head1 SYNOPSIS

    # Import from a OAI-PMH repository
    $ catmandu convert OAI --url http://biblio.ugent.be/oai to Breaker > data.breaker
    
    # Convert the Breaker format into JSON
    $ catmandu convert Breaker < data.breaker

=head1 DESCRIPTION

Inspired by the article "Metadata Analysis at the Command-Line" by Mark Phillips in
L<http://journal.code4lib.org/articles/7818> this exporter breaks a OAI-PMH DC harvest
into the Breaker format which can be analyzed further by command line tools.

=head1 BREAKER FORMAT

   <record-identifier><tab><metadata-field><tab><metadata-value>

=head1 SEE ALSO

L<Catmandu::Exporter::Breaker>

=cut
