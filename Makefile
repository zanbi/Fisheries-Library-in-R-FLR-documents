SOURCES := $(wildcard *.Rmd)
FILES = $(SOURCES:%.Rmd=docs/%_files) $(SOURCES:%.Rmd=docs/pdf/%_files)
CACHE = $(SOURCES:%.Rmd=%_cache) $(SOURCES:%.Rmd=%_files)
HTMLS = $(SOURCES:%.Rmd=docs/%.html) 
RS = $(SOURCES:%.Rmd=docs/R/%.R)
PDFS = $(SOURCES:%.Rmd=docs/pdf/%.pdf)

.PHONY: all clean

all: main clean

main: $(HTMLS) $(RS) $(PDFS)

docs/%.html: %.Rmd
	@echo "$< -> $@"
	@R -e "rmarkdown::render_site('$<', envir=new.env())"

docs/pdf/%.pdf: %.Rmd
	@echo "$< -> $@"
	@R -e "rmarkdown::render('$<', output_format='tufte::tufte_handout', output_file='$@', clean=TRUE)"

docs/R/%.R: %.Rmd
	@echo "$< -> $@"
	@R -e "knitr::purl('$<', output='$@')"

clean:
	rm -f *.html
	rm -rf $(CACHE)
	rm -f docs/README docs/index.md docs/Makefile

cleanall: clean
	rm -rf $(FILES) $(HTMLS) $(RS) $(PDFS)
