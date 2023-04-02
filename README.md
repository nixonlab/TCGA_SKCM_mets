# Snakemake workflow

## Title: Extracting HERV Expression in Cutaneous Melanoma Datasets

Bulk RNA-Seq Telescope analysis of TCGA-SKCM cutaneous melanoma samples (restricted access). Input the metadata table that include the accessions needed to download the raw sequencing files, output gene/HERV count matrices.

## Dataset Citations

Watson, I. R., Wu, C. J., Zou, L., Gershenwald, J. E., Chin, L., & Melanoma Analysis Working Group and The Cancer Genome Analysis Research Network. (2015). Genomic classification of cutaneous melanoma. Cancer Research, 75(15_Supplement), 2972-2972.

## Workflow Graphs

### To get DAG:
 
```snakemake --profile profiles/aws  --forceall --dag | dot -Tpdf > dag.pdf```

### To get rule graph:

```snakemake --profile profiles/aws  --forceall --rulegraph | dot -Tpdf > rulegraph.pdf```

### To get file graph:

```snakemake --profile profiles/aws  --forceall --filegraph | dot -Tpdf > filegraph.pdf```

### To run pipeline:

```snakemake --profile profiles/aws/ all```

## To modify pipeline:

Change sample download table and method. This pipeline uses ```curl``` to download files.


## Usage

 If you use this workflow in a paper, don't forget to give credits to the authors by citing the URL of this (original) repository: https://github.com/nixonlab/TCGA_SKCM_mets
