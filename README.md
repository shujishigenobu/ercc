# ercc

Utilities to work with ERCC Spike-In mixes in RNA-seq analyses.

## References

ERCC ExFold RNA Speki-InMexes is the product of ThermoFisher Scientific.

* https://www.thermofisher.com/order/catalog/product/4456739#/4456739

## Tools

### build_dummy_ERCC92_genome.rb

build_dummy_ERCC92_genome.rb generates a single dummy chromosome on which all ERCC transcripts are concatenated with fixed lengths of Ns intervals (default lengths is 1kb). Associated gff3 file is also generated.

  * input: ERCC92.fa (downloaded from ThermoFisher website)
  * outputs: ERCC92_dummy_genome.fasta, ERCC92_dummy_genome.gff (sotred in data/ dir in this repo)
 

