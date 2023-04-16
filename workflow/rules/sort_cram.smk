#! /usr/bin/env python
# -*- coding: utf-8 -*-

rule samtools_sort_cram:
    input:
        cram = "results/align_multi/{sample_id}/Aligned.out.cram",
        ref = config['genome_fasta']        
    output:
        "results/align_multi/{sample_id}/Aligned.sortedByCoord.out.bam",
        "results/align_multi/{sample_id}/Aligned.sortedByCoord.out.cram",
        "results/align_multi/{sample_id}/Aligned.sortedByCoord.out.cram.crai"
    params:
        bam = "results/align_multi/{sample_id}/Aligned.out.bam"
    conda:
        "../envs/utils.yaml"
    threads: 8
    shell:
        '''
tdir=$(mktemp -d {config[tmpdir]}/{rule}.{wildcards.sample_id}.XXXXXX)        
samtools view -b -T {input.ref} -o {params.bam} {input.cram} 
samtools sort -u -@ {threads} -T $tdir -o {output[0]} {params.bam} 
samtools view -C -T {input.ref} -o {output[1]} {output[0]}
samtools index {output[0]}
rm {params.bam}
        '''
