DIR := src
NAME := minimalist-resume
TEXMFHOME := $(shell kpsewhich -var-value=TEXMFHOME)
INSTALL_DIR := $(TEXMFHOME)/tex/latex/local

TEX := pdflatex
BIB := bibtex
FILE := example
FILE_PATH := $(DIR)/$(FILE)
LINK := https://marcfranquesa.github.io/minimalist-resume/$(FILE).pdf

.PHONY: all
all: pdf image install clean

.PHONY: pdf
pdf: $(FILE_PATH).tex $(DIR)/$(NAME).cls
	cd $(DIR) && $(TEX) $(FILE)

.PHONY: image
image: $(FILE_PATH).pdf
	@magick -quality 100 -density 200 -colorspace sRGB "$(FILE_PATH).pdf" -flatten docs/$(FILE).jpg

.PHONY: install
install: $(DIR)/$(NAME).cls
	@mkdir -p $(INSTALL_DIR)
	cp $(DIR)/$(NAME).cls $(INSTALL_DIR)/$(NAME).cls

.PHONY: index
index:
	@touch index.html
	@echo "<!DOCTYPE html>" > index.html
	@echo "<html lang=\"en\">" >> index.html
	@echo "<head><meta charset="UTF-8"/>" >> index.html
	@echo "<meta http-equiv=\"refresh\" content=0; url=\"$(LINK)\" />" >> index.html
	@echo "<script type=\"text/javascript\"> window.location.href = \"$(LINK)\"; </script>" >> index.html
	@echo "</head>" >> index.html
	@echo "<body>" >> index.html
	@echo "If you are not redirected automatically, follow this <a href=\"$(LINK)\" aria-label=\"Redirect to example\">link</a>." >> index.html
	@echo "</body>" >> index.html
	@echo "</html>" >> index.html

.PHONY: build
build: pdf index clean
	@mkdir build
	@cp $(FILE_PATH).pdf build/$(FILE).pdf
	@mv index.html build

.PHONY: clean
clean:
	@rm -rf $(DIR)/*.aux $(DIR)/*.fls $(DIR)/*.fdb_latexmk $(DIR)/*.fls $(DIR)/*.log $(DIR)/*.out $(DIR)/*.toc $(DIR)/*.bbl $(DIR)/*.bcf $(DIR)/*.xml $(DIR)/*.gz $(DIR)/*blx.bib $(DIR)/*blg
	@rm -rf build
