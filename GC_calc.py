#!/usr/bin/python
from Bio import SeqIO
from Bio.SeqUtils import GC
import sys
import os
from optparse import OptionParser
import numpy

parser = OptionParser()

parser.add_option("-i", "--input", dest="inputfile",
                  help="window size")


(options, args) = parser.parse_args()


rec = open(options.inputfile, 'r')
results = []
for i, line in enumerate(rec):
    if i > 1:
        if not line.lstrip().startswith('>'):
           results.append(line)
A_count = results('A') 
print A_count
