package Catmandu::Importer::Breaker;

use Catmandu::Sane;
use Moo;
use namespace::clean;

our $VERSION = '0.01';

with 'Catmandu::Importer';

has record => (is => 'ro', default => sub { 0 });

sub generator {
    my ($self) = @_;
    sub {
        state $prev_id;
        state $line;
        state $data = {};

        while ( defined( $line = $self->fh->getline ) ) {
            chomp $line;
            next if $line =~ /^\s*#/;

            my ($id,$field,$values) = split(/\s+/,$line,3);

            my $copy;

            if ($self->record && defined($prev_id) && $id ne $prev_id) {
                # Set a copy
                $copy = {%$data};
                $data = {};
            }

            my ($namespace,$tag);

            if ($field =~ /^{(.*)}(\S+)/) {
                $namespace = $1;
                $tag = $2;
            }

            if ($self->record) {
                $data->{_id} = $id;
                push @{$data->{field}}      , $field;
                push @{$data->{namespace}} , $namespace;
                push @{$data->{tag}}       , $tag;
                push @{$data->{data}}      , $values;

                $prev_id = $id;

                return $copy if defined $copy;
            }
            else {
                return {
                    _id       => $id ,
                    field     => $field ,
                    namespace => $namespace ,
                    tag       => $tag ,
                    data      => $values , 
                };
            }
        }

        if (defined $data) {
            my $copy = {%$data};
            $data = undef;
            return $copy;
        }
        else {
            return undef;
        }
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
    
    # Convert the Breaker format by line into JSON
    $ catmandu convert Breaker < data.breaker

    # Convert the Breaker format by record into JSON
    $ catmandu convert Breaker --record 1 < data.breaker

=head1 DESCRIPTION

Inspired by the article "Metadata Analysis at the Command-Line" by Mark Phillips in
L<http://journal.code4lib.org/articles/7818> this exporter breaks a OAI-PMH DC harvest
into the Breaker format which can be analyzed further by command line tools.

=head1 CONFIGURATION

=over

=item file

Read input from a local file given by its path. Alternatively a scalar
reference can be passed to read from a string.

=item fh

Read input from an L<IO::Handle>. If not specified, L<Catmandu::Util::io> is used to
create the input stream from the C<file> argument or by using STDIN.

=item encoding

Binmode of the input stream C<fh>. Set to C<:utf8> by default.

=item fix

An ARRAY of one or more fixes or file scripts to be applied to imported items.

=item record 

The to a true value to join all record values in an array see C<BREAKER OUTPUT FORMAT>

=back

=head1 BREAKER INPUT FORMAT

   <record-identifier><tab><metadata-field><tab><metadata-value>

=head1 BREAKER OUTPUT FORMAT

The breaker format is parsed into a Hash containing 4 fields:

    _id:   the idenifier of the record
    field: the full name (plus namespace) of a field
    namespace: the namespace of a field
    tag:   the name of a field
    data:  the content of the field

When the C<record> option is set to a true value than the field,namespace,tag
and data will contain an array of all possible values in a record.

=head1 SEE ALSO

L<Catmandu::Exporter::Breaker>

=cut
