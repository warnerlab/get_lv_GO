#! /usr/bin/env python

# a script to grab GOterms for SPUIDs

#
# usage
# python infile.txt id_mapfile.txt
#

import sys

#read in file
infile = open(sys.argv[1],'r')
#set_up_output
outfile = open('GO_mappings.txt', 'w')

#this is where the SPU IDs are in master_annotations.txt
spu_id_field = 61

# method 1
outfile.write('SPU_ID\tGO_codes\tGO_terms\tGO_descriptions\n')
for i in infile:
    i = i.rstrip()
    cols_i = i.split('\t')
    spu_id_i = cols_i[spu_id_field]
    # we want to clear this for each ID
    #I'm making these strings so that we can use our own separators
    go_code_list = ""
    go_terms_list = ""
    go_descriptions_list = ""
    with open(sys.argv[2],'r') as idfile:
        for j in idfile:
            j = j.rstrip()
            cols_j = j.split('\t')
            spu_id_j = cols_j[0]
            if spu_id_i == spu_id_j:
                go_code_list+=cols_j[1]+';'
                go_terms_list+=cols_j[2]+';'
                go_descriptions_list+=cols_j[3]+';'
            else:
                continue
    #remove trailing semicolon
    go_code_list = go_code_list[:-1]
    go_terms_list = go_terms_list[:-1]
    go_descriptions_list = go_descriptions_list[:-1]
    #write them out
    outfile.write(spu_id_i+'\t'+go_code_list+'\t'+go_terms_list+'\t'+go_descriptions_list+'\n')

outfile.close()