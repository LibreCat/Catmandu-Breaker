# NAME

Catmandu::Breaker - Package that exports data in a Breaker format

# SYNOPSIS

    # From the command line

    # Using the default breaker
    $ catmandu convert JSON to Breaker < data.json

    # Break a OAI-PMH harvest
    $ catmandu convert OAI --url http://biblio.ugent.be/oai to Breaker

    # Using a MARC breaker
    $ catmandu convert MARC to Breaker --handler marc < data.mrc

    # Using an XML breaker plus create a list of unique record fields
    $ catmandu convert XML --path book to Breaker --handler xml --fields data.fields < t/book.xml > data.breaker

    # Find the usage statistics of fields in the XML file above
    $ catmandu breaker data.breaker

    # Use the list of unique fields in the report
    $ catmandu breaker --fields data.fields data.breaker

    # verbose output
    $ catmandu breaker -v data.breaker

    # The breaker commands needs to know the unique fields in the dataset to build statistics.
    # By default it will scan the whole file for fields. This can be a very
    # time consuming process. With --maxscan one can limit the number of lines
    # in the breaker file that can be scanned for unique fields
    $ catmandu breaker -v --maxscan 1000000 data.breaker

    # Alternatively the fields option can be used to specify the unique fields
    $ catmandu breaker -v --fields 245a,022a data.breaker

    $ cat data.breaker | cut -f 2 | sort -u > data.fields
    $ catmandu breaker -v --fields data.fields data.breaker

# DESCRIPTION

Inspired by the article "Metadata Analysis at the Command-Line" by Mark Phillips in
[http://journal.code4lib.org/articles/7818](http://journal.code4lib.org/articles/7818) this exporter breaks metadata records
into the Breaker format which can be analyzed further by command line tools.

# BREAKER FORMAT

When breaking a input using 'catmandu convert {format} to Breaker' each metadata
fields gets transformed into a 'breaker' format:

    <record-identifier><tab><metadata-field><tab><metadata-value><tab><metadatavalue>...

For the default JSON breaker the input format is broken down into JSON-like Paths. E.g.
when give this YAML input:

    ---
    name: John
    colors:
       - black
       - yellow
       - red
    institution:
       name: Acme
       years:
          - 1949
          - 1950
          - 1951
          - 1952

the breaker command 'catmandu convert YAML to Breaker < file.yml' will generate:

    1 colors[]  black
    1 colors[]  yellow
    1 colors[]  red
    1 institution.name  Acme
    1 institution.years[] 1949
    1 institution.years[] 1950
    1 institution.years[] 1951
    1 institution.years[] 1952
    1 name  John

The first column is a counter for each record (or the content of the \_id field when present).
The second column provides a JSON path to the data (with the array-paths translated to \[\]).
The third column is the field value.

One can use this output in combination with Unix tools like `grep`, `sort`, `cut`, etc to
inspect the breaker output:

    $ catmandu convert YAML to Breaker < file.yml | grep 'institution.years'

Some input formats, like MARC, the JSON-path format doesn't provide much information
which fields are present in the MARC because field names are part of the data. It is
then possible to use a special `handler` to create a more verbose breaker
output.

For instance, without a special handler:

    $ catmandu convert MARC to Breaker < t/camel.usmarc
    fol05731351   record[][]  LDR
    fol05731351   record[][]  _
    fol05731351   record[][]  00755cam  22002414a 4500
    fol05731351   record[][]  001
    fol05731351   record[][]  _
    fol05731351   record[][]  fol05731351
    fol05731351   record[][]  082
    fol05731351   record[][]  0
    fol05731351   record[][]  0
    fol05731351   record[][]  a

With the special [marc handler](https://metacpan.org/pod/Catmandu::Exporter::Breaker::Parser::marc):

    $ catmandu convert MARC to Breaker --handler marc < t/camel.usmarc

    fol05731351   LDR 00755cam  22002414a 4500
    fol05731351   001 fol05731351
    fol05731351   003 IMchF
    fol05731351   005 20000613133448.0
    fol05731351   008 000107s2000    nyua          001 0 eng
    fol05731351   010a     00020737
    fol05731351   020a  0471383147 (paper/cd-rom : alk. paper)
    fol05731351   040a  DLC
    fol05731351   040c  DLC
    fol05731351   040d  DLC

For the [Catmandu::PICA](https://metacpan.org/pod/Catmandu::PICA) tools a [pica handler](https://metacpan.org/pod/Catmandu::Exporter::Breaker::Parser::pica) is available.

For the [Catmandu::XML](https://metacpan.org/pod/Catmandu::XML) tools an [xml handler](https://metacpan.org/pod/Catmandu::Exporter::Breaker::Parser::xml) is available:

    $ catmandu convert XML --path book to Breaker --handler xml < t/book.xml

# BREAKER STATISTICS

Statistical information can be calculated from a breaker output using the
'catmandu breaker' command:

    $ catmandu convert MARC to Breaker --handler marc < t/camel.usmarc > data.breaker
    $ catmandu breaker data.breaker

    | name | count | zeros | zeros% | min | max | mean | median | mode   | variance | stdev | uniq%| entropy |
    |------|-------|-------|--------|-----|-----|------|--------|--------|----------|-------|------|---------|
    | 001  | 10    | 0     | 0.0    | 1   | 1   | 1    | 1      | 1      | 0        | 0     | 100  | 3.3/3.3 |
    | 003  | 10    | 0     | 0.0    | 1   | 1   | 1    | 1      | 1      | 0        | 0     | 10   | 0.0/3.3 |
    | 005  | 10    | 0     | 0.0    | 1   | 1   | 1    | 1      | 1      | 0        | 0     | 100  | 3.3/3.3 |
    | 008  | 10    | 0     | 0.0    | 1   | 1   | 1    | 1      | 1      | 0        | 0     | 100  | 3.3/3.3 |
    | 010a | 10    | 0     | 0.0    | 1   | 1   | 1    | 1      | 1      | 0        | 0     | 100  | 3.3/3.3 |
    | 020a | 9     | 1     | 10.0   | 0   | 1   | 0.9  | 1      | 1      | 0.09     | 0.3   | 90   | 3.3/3.3 |
    | 040a | 10    | 0     | 0.0    | 1   | 1   | 1    | 1      | 1      | 0        | 0     | 10   | 0.0/3.3 |
    | 040c | 10    | 0     | 0.0    | 1   | 1   | 1    | 1      | 1      | 0        | 0     | 10   | 0.0/3.3 |
    | 040d | 5     | 5     | 50.0   | 0   | 1   | 0.5  | 0.5    | [0, 1] | 0.25     | 0.5   | 10   | 1.0/3.3 |

The output table provides statistical information on the usage of fields in the
original format. We see that the `001` field was counted 10 times in the data set,
but the `040d` value is only present 5 times. The `020a` is empty in 10% (zeros%)
of the records. The `001` has very unique values (entropy is maximum), but all `040c`
fields contain the same information (entropy is minimum).

See [Catmandu::Exporter::Stat](https://metacpan.org/pod/Catmandu::Exporter::Stat) for more information about the statistical fields.

# MODULES

- [Catmandu::Exporter::Breaker](https://metacpan.org/pod/Catmandu::Exporter::Breaker)
- [Catmandu::Cmd::breaker](https://metacpan.org/pod/Catmandu::Cmd::breaker)

# SEE ALSO

[Catmandu](https://metacpan.org/pod/Catmandu), [Catmandu::MARC](https://metacpan.org/pod/Catmandu::MARC), [Catmandu::XML](https://metacpan.org/pod/Catmandu::XML), [Catmandu::Stat](https://metacpan.org/pod/Catmandu::Stat)

# AUTHOR

Patrick Hochstenbach, `<patrick.hochstenbach at ugent.be>`

# CONTRIBUTORS

Jakob Voss, `nichtich at cpan.org`

Johann Rolschewski, `jorol at cpan.org`
