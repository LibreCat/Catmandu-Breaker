# NAME

Catmandu::Breaker - Package that exports data in a Breaker format

# SYNOPSIS

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

# DESCRIPTION

Inspired by the article "Metadata Analysis at the Command-Line" by Mark Phillips in
[http://journal.code4lib.org/articles/7818](http://journal.code4lib.org/articles/7818) this exporter breaks a OAI-PMH DC harvest
into the Breaker format which can be analyzed further by command line tools.

# BREAKER FORMAT

    <record-identifier><tab><metadata-field><tab><metadata-value><tab><metadatavalue>...

# MODULES

- [Catmandu::Exporter::Breaker](https://metacpan.org/pod/Catmandu::Exporter::Breaker)
- [Catmandu::Importer::Breaker](https://metacpan.org/pod/Catmandu::Importer::Breaker)

# SEE ALSO

[Catmandu](https://metacpan.org/pod/Catmandu)

# AUTHOR

Patrick Hochstenbach, `<patrick.hochstenbach at ugent.be>`
