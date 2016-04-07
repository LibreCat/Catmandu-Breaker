package Catmandu::Exporter::Breaker::Parser::marcxml;

use Catmandu::Sane;
use Moo;
use namespace::clean;

our $VERSION = '0.01';

sub add {
    my ($self, $data, $io) = @_;
    
    return if $data->{_status} eq 'deleted';

    my $identifier = $data->{_identifier};

    my $record = $data->{record};

    for my $field (@$record) {
        my ($tag,$ind1,$ind2,@data) = @$field;

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
            sprintf "%s\t{http://www.loc.gov/marc/bibliographic/}%s\t%s\t%s\t%s\n"
                    , $identifier
                    , $tag
                    , $ind1
                    , $ind2
                    , $txt
        );
    }

    1;
}

1;

__END__