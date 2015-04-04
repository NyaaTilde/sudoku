VALAC = valac
DIRS  = UI/*.vala *.vala
PKGS  = --pkg gtk+-3.0 --pkg posix
O     = -o sudoku
ARGS  = -g

.PHONY: all release

all:
	$(VALAC) $(ARGS) $(PKGS) $(O) $(DIRS)

release: all
