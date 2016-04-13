# makefile for tolua hierarchy

tolua: bin lib
	cd src/lib; make all
	cd src/bin; make all

bin:
	mkdir -p bin

lib:
	mkdir -p lib

tests:
	cd src/tests; make all

all clean klean:
	cd src/lib; make $@
	cd src/bin; make $@
	cd src/tests; make $@

debug:
	cd src/bin; make debug

