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

#cpg ?= $(shell which 'cpg.py')

##### No Editing should be necessary below this line  #####

all:$(RUN).cpg $(RUN).clust format

IN=input.fa
WINDOW=500
OE=0.65
AUGMENT=15
RUN=run
THREADS=24
nline=$(shell wc -l $(RUN).cpg | awk '{print $$1}')

$(RUN).cpg:$(IN)
	@echo '\n\n'BEGIN CpG DETECTION: `date +'%a %d%b%Y  %H:%M:%S'`
	@echo Results will be in a file named $(RUN).clust
	@echo The format of this file is 'Contig name   CpG Start Position   CpG Length   %GC   Obs/Exp'
	@echo Settings used: Window size:$(WINDOW) Obs/Exp=$(OE) %GC=Background + $(AUGMENT)%
	python cpg.py -i $(IN) -a $(AUGMENT) -w $(WINDOW)| awk '$(OE)>$$4{next}1' | awk 'NR%10==0' > $(RUN).cpg
$(RUN).clust:$(RUN).cpg
	@echo '\n\n'BEGIN CLUSTERING: `date +'%a %d%b%Y  %H:%M:%S'`
	##TEST
	for i in `seq 1 $$nline`; do \
		echo `expr $$(awk 'NR == '$$i'+1 {print $$2}' $(RUN).cpg) - $$(awk 'NR == '$$i' {print $$2}' $(RUN).cpg)` | tee -a $(RUN).cpg.clusters; \
	done
	cat $(RUN).cpg.clusters | sed '1 i\1223' | paste $(RUN).cpg - | awk '200>$$5{next}1' > $(RUN).clust
		#cat $(RUN).cpg | awk '{print $$1}' | uniq > $(RUN).list
		#for e in `cat $(RUN).list`; do grep -w $$e $(RUN).cpg > $(RUN).$$e.lists; done
		#for i in `ls $(RUN).*lists`; do awk '{print $$2}' $$i > $$i.input; done
		#for g in `ls $(RUN).*input`; do F=`basename $$g .input`; python clust.py $$g | sort -nk4 | tee -a $(RUN).tmp4 | awk '{print $$4}' | grep -wf - $$F >> $(RUN).tmp2; done
		#paste $(RUN).tmp4 $(RUN).tmp2 | awk '{print $$5 "\t" $$3 $$4 "\t" $$2 "\t" $$7 "\t" $$8}' > $(RUN).clust
	#rm $(RUN).cpg.clusters
format:$(RUN).clust
	@echo '***'
	@echo Number of CpG Islands = $(shell wc -l $(RUN).clust | awk '{print $$1}')
	@echo '***'
	@echo END: `date +'%a %d%b%Y  %H:%M:%S'`'\n\n'
