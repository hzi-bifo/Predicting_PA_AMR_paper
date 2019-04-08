This folder includes commands that created the Pseudomonas genomic results using Seq2Geno.
```
DNA_READS_LIST='./dna_reads_no_ref'
DNA_READS_LIST_PLUS='./dna_reads_with_ref'
RNA_READS_LIST='./rna_reads_no_ref'
ADAPTOR_F='adaptor/NEBNext_adapter.fasta'

PHENOTYPE_LIST='./phenotypes.mat'

REF1_FA='reference01/Pseudomonas_aeruginosa_PA14.edit.fasta'
REF1_GFF='reference01/RefCln_UCBPP-PA14.edit.gff'
REF1_GBK='reference01/Pseudomonas_aeruginosa_PA14_ncRNA.edit.gbk'

REF2_FA='reference02/reference.fa'
REF2_GFF='reference02/reference.gff'
REF2_GBK='reference02/Pseudomonas_aeruginosa_PA14_ncRNA.edit.gbk'

####SNPs
seq2geno \
  -s \
  --cores 15 \
  --dna-reads $DNA_READS_LIST \
  --adaptor  $ADAPTOR_F\
  --ref-fa $REF1_FA \
  --ref-gff $REF1_GFF \
  --ref-gbk $REF1_GBK \
  --wd Pseudomonas_snps

####gene presence/absence and indels
# strain list: with ref genomes
# ref: same as those used by snps
seq2geno \
  -d \
  --cores 15 \
  --dna-reads $DNA_READS_LIST_PLUS \
  --adaptor  $ADAPTOR_F\
  --ref-fa REF1_FA \
  --ref-gff REF1_GFF \
  --ref-gbk REF1_GBK \
  --wd Pseudomonas_denovo 

####expression levels
# include deseq2 option
# strain list: without ref genomes
# ref: same as those used by snps
seq2geno \
  -e -de\
  --cores 15 \
  --dna-reads $DNA_READS_LIST \
  --rna-reads $RNA_READS_LIST \
  --adaptor  $ADAPTOR_F\
  --ref-fa REF1_FA \
  --ref-gff REF1_GFF \
  --ref-gbk REF1_GBK \
  --pheno PHENOTYPE_LIST \
  --wd Pseudomonas_expr

####phylogenetic tree
# strain list: with ref genomes
# ref: another
seq2geno \
  -p\
  --cores 15 \
  --dna-reads $DNA_READS_LIST \
  --adaptor  $ADAPTOR_F\
  --ref-fa $REF2_FA \
  --ref-gff $REF2_GFF \
  --ref-gbk $REF2_GBK \
  --wd Pseudomonas_phylo
```
