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


for rec in SeqIO.parse(options.inputfile, "fasta"):
	gc = GC(rec.seq)
	print gc
