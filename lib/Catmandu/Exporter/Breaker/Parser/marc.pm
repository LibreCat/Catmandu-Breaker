package Catmandu::Exporter::Breaker::Parser::marc;

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

    my $record = $data->{record};

    for my $field (@$record) {
        my ($tag,$ind1,$ind2,@data) = @$field;
        $ind1 = ' ' unless $ind1;
        $ind2 = ' ' unless $ind2;
        my $txt = '';
        for (my $i = 0 ; $i < @data ; $i += 2) {
            if ($i == 0 && $data[$i] eq '_') {
                $txt .= $data[$i+1];
            }
            else {
                $txt .= '$$' . $data[$i] . $data[$i+1];
            }
        }

        $data =~ s{\n}{\\n}mg;
        $data =~ s{\t}{\\t}mg;
        
        $io->print(
            $self->breaker->to_breaker(
                $identifier ,
                $tag ,
                $txt)
        );
    }

    1;
}

1;

__END__