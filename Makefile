.POSIX:

TARGET:=seminar-paper
ROOT_DIR:=.
BUILD_DIR:=$(ROOT_DIR)/build

IMAGES:= $(ROOT_DIR)/images/fly.pdf
IMAGES+= $(ROOT_DIR)/images/flies.pdf
IMAGES+= $(ROOT_DIR)/images/rosette.pdf
# XXX: add or delete new images as dependencies

.PHONY: all

all: $(TARGET).pdf

$(TARGET).pdf: $(TARGET).tex lit.bib acmart.cls $(IMAGES)
	@mkdir -p $(BUILD_DIR)
	@pdflatex -synctex=1 -halt-on-error -output-directory=$(BUILD_DIR) -shell-escape $(TARGET).tex
	@pdflatex -synctex=1 -halt-on-error -output-directory=$(BUILD_DIR) -shell-escape $(TARGET).tex
	@cp lit.bib $(BUILD_DIR); 
	@cd $(BUILD_DIR); bibtex $(TARGET)
	@pdflatex -synctex=1 -halt-on-error -output-directory=$(BUILD_DIR) -shell-escape $(TARGET).tex
	@pdflatex -synctex=1 -halt-on-error -output-directory=$(BUILD_DIR) -shell-escape $(TARGET).tex
	@mv $(BUILD_DIR)/$(TARGET).pdf $(ROOT_DIR)/$(TARGET).pdf

clean:
	rm -fr $(BUILD_DIR)

fresh: clean
	rm -f $(TARGET).pdf

.PHONY: clean fresh
