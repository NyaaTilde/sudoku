VALAC = valac
DIRS  = UI/*.vala *.vala
PKGS  = --pkg gtk+-3.0 --pkg posix --pkg pango --pkg gee-0.8
O     = -o sudoku
ARGS  = -g --Xcc=-O3

.PHONY: all release

all:
	$(VALAC) $(ARGS) $(PKGS) $(O) $(DIRS)

release: all
