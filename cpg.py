#!/usr/bin/python
from Bio import SeqIO
from Bio.SeqUtils import GC
import sys
import os
from optparse import OptionParser
import numpy

#usage python cpg.py -i test.fa -a 15 -w 500

parser = OptionParser()

parser.add_option("-w", "--window", dest="winSize", type="int",
                  help="window size", default=500)
parser.add_option("-i", "--input", dest="inputfile",
                  help="window size")
parser.add_option("-a", "--augment", dest="aug", type="int",
                  help="window size", default=15)

(options, args) = parser.parse_args()


for rec in SeqIO.parse(options.inputfile, "fasta"):
    gc = GC(rec.seq)
    results = []
    numOfChunks = ((len(rec.seq) - options.winSize))+1
    for i in range(0,numOfChunks,1):
        sequence = rec.seq[i:i+options.winSize]
        pos = int(i+options.winSize)
        gc_seq = (float (sequence.count("G") + sequence.count("C")) * 100 / options.winSize)
        try:              
            if gc_seq > gc + options.aug :
                results.append(pos)
                print "%s\t %s\t %s\t %s" % (rec.id, pos, GC(sequence), "{0:.2f}".format((sequence.count("CG") / float (sequence.count("G")*sequence.count("C")))*len(sequence)))
        except:
            e = sys.exc_info()[0]



