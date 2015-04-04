VALAC = valac
DIRS  = *.vala
PKGS  = --pkg gtk+-3.0 --pkg posix
O     = -o sudoku
ARGS  = -g

.PHONY: all

all:
	$(VALAC) $(ARGS) $(PKGS) $(O) $(DIRS)

release: all
