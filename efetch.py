#!/usr/bin/python
from Bio import Entrez

Entrez.email = "macmanes@gmail.com"     # Always tell NCBI who you are
handle = Entrez.efetch(db="nucleotide", id="568815339", rettype="fasta", retmode="text")
print(handle.read())
