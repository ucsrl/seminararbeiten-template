# not POSIX make compatible (only because of the shell expansions below).
# use gmake on BSDs & others.
TARGET:=seminar-paper
ROOT_DIR:=.
BUILD_DIR:=$(ROOT_DIR)/build
MAIN:=$(ROOT_DIR)/$(TARGET).tex

DEPENDENCIES:=$(shell find $(ROOT_DIR)/images -type f)
DEPENDENCIES += $(shell find $(ROOT_DIR) -type f -name '*.tex')
DEPENDENCIES += $(shell find $(ROOT_DIR) -type f -name '*.cls')
DEPENDENCIES += $(shell find $(ROOT_DIR) -type f -name '*.csv')
DEPENDENCIES += $(shell find $(ROOT_DIR) -type f -name '*.sty')
DEPENDENCIES += $(shell find $(ROOT_DIR) -type f -name '*.bib')

PDFTEX_FLAGS = -synctex=1 -halt-on-error -file-line-error -output-format=pdf \
			   -output-directory=$(BUILD_DIR) -interaction nonstopmode -shell-escape

all: $(TARGET).pdf

$(TARGET).pdf: $(DEPENDENCIES)
	@mkdir -p $(BUILD_DIR)
	@pdflatex $(PDFTEX_FLAGS) $(MAIN)
	@pdflatex $(PDFTEX_FLAGS) $(MAIN)
	@cp lit.bib $(BUILD_DIR)
	@cd $(BUILD_DIR); bibtex $(TARGET); cd ..
	@pdflatex $(PDFTEX_FLAGS) $(MAIN)
	@pdflatex $(PDFTEX_FLAGS) $(MAIN)
	@cp $(BUILD_DIR)/$(TARGET).pdf $(ROOT_DIR)/$(TARGET).pdf

flags:
	@echo "PDFTEX_FLAGS = $(PDFTEX_FLAGS)"

clean:
	rm -fr $(BUILD_DIR)

fresh: clean
	rm -f $(TARGET).pdf

.PHONY: all clean fresh flags
