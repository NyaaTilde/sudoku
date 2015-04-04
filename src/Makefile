.PHONY: all

all:
	valac \
		-g \
		--pkg gtk+-3.0 \
		--pkg posix \
		-o sudoku \
		`find . -type f | grep -E '.vala'`
