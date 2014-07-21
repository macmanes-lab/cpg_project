#!/usr/bin/make -rRsf

###########################################
###        -usage 'assembly.mk RUN=run CPU=8 MEM=15 READ1=/location/of/read1.fastq READ2=/location/of/read2.fastq'
###         -RUN= name of run
###
############################################


all:$(RUN).cpg $(RUN).clust format

IN=input.fa
WINDOW=500
OE=0.65
AUGMENT=15
RUN=run

$(RUN).cpg:$(IN)
	@echo '\n\n'BEGIN CpG DETECTION: `date +'%a %d%b%Y  %H:%M:%S'`
	@echo Results will be in a file named $(RUN).clust
	@echo The format of this file is 'Contig name   CpG Start Position   CpG Length   %GC   Obs/Exp'
	@echo Settings used: Window size:$(WINDOW) Obs/Exp=$(OE) %GC=Background + $(AUGMENT)%
	python cpg.py -i $(IN) -a $(AUGMENT) -w $(WINDOW)| awk '$(OE)>$$4{next}1' | awk 'NR%20==0' > $(RUN).cpg
$(RUN).clust $(RUN).cpg.clusters:$(RUN).cpg
	@echo '\n\n'BEGIN CLUSTERING: `date +'%a %d%b%Y  %H:%M:%S'`
	./for.sh -i $(RUN).cpg | sed '1 i\1223' | paste $(RUN).cpg - | awk '500>$$5 && 0<$$5 {next}1' > $(RUN).clust
format:$(RUN).clust
	@echo '***'
	@echo Number of CpG Islands = $(shell wc -l $(RUN).clust | awk '{print $$1}')
	@echo '***'
	@echo END: `date +'%a %d%b%Y  %H:%M:%S'`'\n\n'
