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

all:$(RUN).cpg $(RUN).clust format

IN=input.fa
WINDOW=500
OE=0.65
AUGMENT=15
RUN=run
THREADS=24

$(RUN).cpg:$(IN)
	@echo '\n\n'BEGIN: `date +'%a %d%b%Y  %H:%M:%S'`
	@echo Results will be in a file named $(RUN).clust
	@echo The format of this file is 'Contig name   CpG Start Position   CpG Length   %GC   Obs/Exp'
	@echo Settings used: Window size:$(WINDOW) Obs/Exp=$(OE) %GC=Background + $(AUGMENT)%
	python cpg.py -i $(IN) -a $(AUGMENT) -w $(WINDOW)| awk '$(OE)>$$4{next}1' > $(RUN).cpg
$(RUN).clust:$(RUN).cpg
	sh clust.sh -t $THREADS
	cat tmp4 | awk '{print $$4}' > tmp1
	grep -wf tmp1 $(RUN).cpg > tmp2
	paste tmp4 tmp2 | awk '{print $$5 "\t" $$3 $$4 "\t" $$2 "\t" $$7 "\t" $$8}' > $(RUN).clust
	#rm tmp tmp2 tmp4 tmp1
format:$(RUN).clust
	@echo '***'
	@echo Number of CpG Islands = $(shell wc -l $(RUN).clust | awk '{print $$1}')
	@echo '***'
	@echo END: `date +'%a %d%b%Y  %H:%M:%S'`'\n\n'
