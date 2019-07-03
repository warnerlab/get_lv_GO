#! /usr/bin/env python

# a script to grab GOterms for SPUIDs

import sys

#read in file
infile = open(sys.argv[1],'r')

#set_up_output
outfile = open('GO_mappings.txt', 'w')

#this is where the SPU IDs are in master_annotations.txt
spu_id_field=[61]

#set up the working loop
for line in infile:
	linecount+=1
	#make the header
	if linecount==1:
		outfile.write('SPU_ID\tUniprotID\tGO_terms\tGO_descriptions')
	else:
		line=line.rstrip()
		cols=line.split('\t')
		spu_id = cols[spu_id_field]

####
#### TO DO
####

#1. Read in the ID mapping file
#2. Compare the SPUIDs to that file to get the Uniprot ID, skip IDs that don't have an SPU association
#3. Download flat file of Uniprot
#4. Extract GO terms and descriptions of the flat file
#5. Write it all out



outfile.close()