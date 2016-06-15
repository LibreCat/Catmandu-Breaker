package Catmandu::Importer::Breaker;

use Catmandu::Sane;
use Moo;
use Catmandu::Breaker;
use namespace::clean;

our $VERSION = '0.01';

with 'Catmandu::Importer';

has group => (is => 'ro', default => sub { 0 });

sub generator {
    my ($self) = @_;
    sub {
        state $prev_id;
        state $line;
        state $data = {};

        my $breaker = Catmandu::Breaker->new;

        while ( defined( $line = $self->fh->getline ) ) {
            chomp $line;
            next if $line =~ /^\s*#/;

            my $fields    = $breaker->from_breaker($line);

            my $id        = $fields->{identifier};
            my $tag       = $fields->{tag};
            my $values    = $fields->{value};

            my $copy;

            if ($self->group && defined($prev_id) && $id ne $prev_id) {
                # Set a copy
                $copy = {%$data};
                $data = {};
            }

            if ($self->group) {
                $data->{_id} = $id;
                push @{$data->{tag}}       , $tag;
                push @{$data->{data}}      , $values;

                $prev_id = $id;

                return $copy if defined $copy;
            }
            else {
                return {
                    _id       => $id ,
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
    $ catmandu convert Breaker --group 1 < data.breaker

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
    tag:   the name of a field
    data:  the content of the field

When the C<record> option is set to a true value than the field,namespace,tag
and data will contain an array of all possible values in a record.

=head1 SEE ALSO

L<Catmandu::Exporter::Breaker>

=cut
