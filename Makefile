
.PHONY: slides
slides:
	cd src/slides && Rscript ../build.R && cp slides.html ../../
	open slides.html
	cp src/slides/vignette.html vignette

all: 
	make slides

.PHONY: models
models:
	cp ${DEVMODELS}/rifampicin/rifampicin.cpp model
	cp ${DEVMODELS}/rifampicin/rifampicin_midazolam.cpp model
	cp ${DEVMODELS}/opg/opg.cpp model
	cp ${DEVMODELS}/gcsf/gcsf.cpp model
	cp ${DEVMODELS}/ddi/yoshikado.cpp model
	cp ${DEVMODELS}/cipro/cipro.cpp model
	cp ${DEVMODELS}/cipro/cipro_conc.cpp model
	cp ${DEVMODELS}/cipro/cipro_pop.cpp model
	cp ${DEVMODELS}/epo/epo.cpp model
	cp ${DEVMODELS}/ddi/csa.cpp model
	cp ${DEVMODELS}/azithro/azithro.cpp model
	cp ${DEVMODELS}/secukinumab/secukinumab.cpp model
	cp ${DEVMODELS}/moxi/moxi.cpp model
	cp ${DEVMODELS}/cipro/cipro_post.RDS data
	cp ${DEVMODELS}/cipro/cipro_post.csv data
