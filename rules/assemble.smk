# Runs spades metagenome+assembly module
rule assemble:
    input: 
      pe1 = rules.fastp.output[0],
      pe2 = rules.fastp.output[1]
    output: 
      contigs = "assemble/{sample}/final.contigs.fa"
    params:
      options = "--min-contig-len 500"
    threads: 8
    log: "logs/{sample}_assemble.log"
    wrapper:
      "https://raw.githubusercontent.com/avilab/snakemake-wrappers/master/assembly/megahit"

rule align:
    input: 
      ref = rules.assemble.output.contigs,
      in1 = rules.fastp.output[0],
      in2 = rules.fastp.output[1]
    output:
      out = "align/{sample}/aln.sam.gz",
      path = directory("index/{sample}")
    params:
      options = "kfilter=22 subfilter=15 maxindel=80"
    wrapper:
      "https://raw.githubusercontent.com/avilab/snakemake-wrappers/master/bbmap/bbwrap"

rule coverage:
    input: 
      rules.align.output.out
    output:
      out = "align/{sample}/coverage.txt"
    wrapper:
      "https://raw.githubusercontent.com/avilab/snakemake-wrappers/master/bbmap/pileup"

    
    
