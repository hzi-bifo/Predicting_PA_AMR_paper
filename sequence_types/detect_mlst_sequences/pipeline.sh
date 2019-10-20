REF=Pseudomonas_aeruginosa_PA14.fasta
ISOLATE=ZG5048010
BAM=ZG5048010.bam 
CONSENSUS=ZG5048010.consensus.fastq
MLST_SEQ=ZG5048010.MLST.fasta
GENES=gene_list

samtools mpileup -uf $REF $BAM|\
  bcftools view -cg - | \
  vcfutils.pl vcf2fq > $CONSENSUS
#extracting MLST gene sequences (pearl script just uses via dictionary imported locus information to extract relevant genes)
fastq_consensus_extract.pl -p $ISOLATE -r $GENES $CONSENSUS > $MLST_SEQ &
# merge sequences of every strain
merge_fasta_dec10.pl -s -f -p NNANN -i *.MLST.fasta
