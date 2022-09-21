#! /usr/bin/env python
# -*- coding: utf-8 -*-

#given a sample file, return the list of samples
def file_to_list(input_file,sep = "\t"):
    sample_file = pd.read_csv(input_file, sep = sep, header = 0)
    return(sample_file['Sample ID'])

sample_id = file_to_list("../test_table.tsv", sep = "\t")

samples = pd.read_csv("../test_table.tsv", sep = "\t", header = 0).set_index('Sample ID', inplace = True, replace = False)


