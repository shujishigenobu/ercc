require 'bio'

ercc_fasta = "ERCC92.fa"
DUMMY_INTERVAL = 1000
out_base = "ERCC92_dummy_genome"
out_fasta = out_base + ".fasta"
out_gff = out_base + ".gff"

data = []

Bio::FlatFile.open(Bio::FastaFormat, ercc_fasta).each do |fas|
  data << {'id' => fas.entry_id, 'seq' => fas.seq}
end

###
# generate dummy genome seq
dummy_genome = data.map{|d| d['seq']}.join("n" * DUMMY_INTERVAL)

###
# generate dummy genome annotation in GFF3

erccs_with_intervals = data.map{|d| [d, {'id' => "dummy", 'seq' => "n" * DUMMY_INTERVAL}]}.flatten
erccs_with_intervals.pop

p erccs_with_intervals

p ercc_len = erccs_with_intervals.map{|d| d['seq'].length}

start = 1

coordinates = []
dummy = {:from => 0, :to => 0, :name => "dummy"}
coordinates << dummy

erccs_with_intervals.map.each_with_index do |d, i|
  from = coordinates.last[:to] + 1
  to = from + d['seq'].length - 1
  coordinates << {:from => from, :to => to, :name => d['id']}
end

File.open(out_gff, "w") do |o|

  coordinates.each do |c|
    if c[:name] == "dummy"
      # do nothing
    else
      gff_gene = [
        "ERCC",
        "ERCC",
        "gene",
        c[:from],
        c[:to],
        ".",
        "+",
        ".",
        "ID=#{c[:name]}"
      ]
      gff_mrna = gff_gene.dup
      gff_mrna[2] = 'mRNA'
      gff_mrna[8] = "ID=rna-#{c[:name]};Parent=#{c[:name]}"
      gff_exon = gff_mrna.dup
      gff_exon[2] = 'exon'
      gff_exon[8] = "Parent=rna-#{c[:name]}"

      o.puts gff_gene.join("\t")
      o.puts gff_mrna.join("\t")
      o.puts gff_exon.join("\t")
    end
  end

end


File.open(out_fasta, "w") do |o|
  o.puts ">ERCC ERCC92 RNAs are concatennated with 1k intervals (Ns)."
  o.puts dummy_genome
end