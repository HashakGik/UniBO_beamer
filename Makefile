ifeq ($(OS), Windows_NT)
	remove = del /s
	sep = \\
else
	remove = rm -f
	sep = /
endif

file = unibo-example.tex
out = example
tex_dir = tex

svg_img = $(sort $(wildcard img/*.svg))
imgs    = $(patsubst img/%.svg, img/%, $(svg_img))
pdf_img = $(patsubst img/%, img/%.pdf, $(imgs))


all: presentation

convert_img: $(pdf_img)

img/%.pdf: img/%.svg
	inkscape -D -z --file=$< --export-pdf=$@ --export-latex

presentation: $(file) \
			$(pdf_img)
	latexmk -synctex=1 -bibtex -interaction=nonstopmode -file-line-error -pdf $(basename $(file)) -jobname=$(out)
	$(MAKE) clean


.PHONY: clean
clean:
	$(remove) $(out).blg
	$(remove) $(out).fls
	$(remove) $(out).log
	$(remove) $(out).out
	$(remove) $(out).snm
	$(remove) $(out).synctex.gz


.PHONY: cleanall
cleanall: clean
	@$(remove) $(out).aux
	@$(remove) $(out).fdb_latexmk
	@$(remove) $(out).bbl
	@$(remove) $(out).nav
	@$(remove) $(out).toc
