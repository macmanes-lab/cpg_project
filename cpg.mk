#!/usr/bin/make -rRsf

###########################################
###        -usage 'assembly.mk RUN=run CPU=8 MEM=15 READ1=/location/of/read1.fastq READ2=/location/of/read2.fastq'
###         -RUN= name of run
###
###        -limitations=  must use PE files.. no support for SE...
###
###         -Make sure your Trinity base directory 
###         	is set properly
###         -Make sure barcode file is located with
###           BCODES= tag
###          -Make sure you pull the config.analy file from GIT, or make you own.
############################################


##### No Editing should be necessary below this line  #####

all:tmp $(RUN).clust

IN=input.fa
WINDOW=500
OE=0.65
AUGMENT=10
RUN=run

tmp:$(IN)
	python cpg.py -i $(IN) -a $(AUGMENT) -w $(WINDOW)| awk '$(OE)>$$4{next}1' | tee $(RUN).cpg | awk '{print $$2}' > tmp
$(RUN).clust:tmp
	python clust.py | sort -nk4 > $(RUN).clust
	rm tmp