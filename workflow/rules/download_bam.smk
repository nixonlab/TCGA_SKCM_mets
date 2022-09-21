#!/usr/bin/env python
# -*- coding: utf-8 -*-

#given a sample_id, return the filecode
def find_column(sample_file_path,col_name,sep = "\t", header = 0):
    sample_file = pd.read_csv(sample_file_path, sep = sep, header = header)
    return(sample_file.columns.get_loc(col_name)

rule download_bam_gtex:
    input:
        table_file = "/athena/nixonlab/scratch/tof4003/test_gdc.txt"
        token = "/home/tof4003/gdc_token_092022.txt"
    output:
        temp('../results/original_bam/{sample_id}.bam')
    params:
        id_col = find_column("{input.table_file}","File ID")
        sample_col = find_column("{input.table_file}","Sample ID")
    config:
        "../envs/gdc.yaml"
    shell:
        '''
        while read line; do
        echo "Started"
        sample=$(awk -F "\t" '{print ${params.sample_col}}' <<< $line)
        fid=$(awk -F "\t" '{print ${params.id_col}}' <<< $line)
        gdc-client download $fid \
        --latest \
        -t "{input.token}" 
        mv $fid/$fid.rna_seq.transcriptome.gdc_realn.bam ../results/original_bam/$sample.bam
        rm -r $fid < {input.table_file}
        '''

#def original_bam_from_sample_id(wc):
    #row = samples.loc[wc.sample_id]
    #return os.path.join('results', 'original_bam', row['sample ID'],)


# Default SAM attributes cleared by RevertSam
attr_revertsam = ['NM', 'UQ', 'PG', 'MD', 'MQ', 'SA', 'MC', 'AS']
# SAM attributes output by STAR
attr_add = ['nM', 'NH', 'ch', 'XS', 'HI', 'uT', ]
# {'NM', 'nM', 'AS', 'NH', 'ch', 'RG', 'XS', 'HI', 'uT', 'SA'}
# {'NM', 'nM', 'AS', 'NH', 'ch', 'RG', 'XS', 'HI', 'uT', 'SA'}

# Additional attributes to clear
ALN_ATTRIBUTES = list(set(attr_add) - set(attr_revertsam))


rule original_bam_to_ubam:
    input:
        '../results/original_bam/{sample_id}.bam'
    output:
        '../results/ubam/{sample_id}.bam'
    log:
        "logs/revert_bam.{sample_id}.log",
        "logs/mark_adapters.{sample_id}.log",
        "logs/mark_adapters.{sample_id}.metrics"
    conda:
        "../envs/picard.yaml"
    params:
        attr_to_clear = expand("--ATTRIBUTE_TO_CLEAR {a}", a=ALN_ATTRIBUTES)
    shell:
       '''
picard RevertSam\
  -I {input[0]}\
  -O /dev/stdout\
  --SANITIZE true\
  --COMPRESSION_LEVEL 0\
  --VALIDATION_STRINGENCY SILENT\
  --TMP_DIR {config[tmpdir]}\
  {params.attr_to_clear}\
  2> {log[0]} | \
picard MarkIlluminaAdapters\
  -I /dev/stdin\
  -O {output[0]}\
  -M {log[2]}\
  --COMPRESSION_LEVEL 5\
  --TMP_DIR {config[tmpdir]}\
  2> {log[1]}

chmod 660 {output[0]}
        '''

rule archive_ubam:
    input:
        "results/ubam/{sample_id}.bam"
    output:
        "efs_results/{sample_id}/unaligned.bam"
    shell:
        '''
mv {input} {output}
        '''
