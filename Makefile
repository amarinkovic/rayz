
build:	# build the project
	zig build
b: build

run: # run the project
	zig build run
r: run

.PHONY: build
