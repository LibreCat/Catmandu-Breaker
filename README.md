# NAME

Catmandu::Breaker - Package that exports OAI-PMH DC in a Breaker format

# SYNOPSIS

    # From the command line
    $ catmandu convert OAI --url http://biblio.ugent.be/oai to Breaker

    # Using a MARCXML breaker
    $ catmandu convert OAI --url http://lib.ugent.be/oai --metadataPrefix marcxml to Breaker --handler marcxml

    # Parser the Breaker format
    $ catmandu convert Breaker < data.breaker

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

[Catmandu::OAI](https://metacpan.org/pod/Catmandu::OAI)

# AUTHOR

Patrick Hochstenbach, `<patrick.hochstenbach at ugent.be>`
