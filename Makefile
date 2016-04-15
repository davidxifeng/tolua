# makefile for tolua hierarchy

tolua_src = $(wildcard src/bin/lua/*.lua)

all : tolua doc

.PHONY : doc

doc : doc/build/index.html

doc/build/index.html : $(tolua_src)
	ldoc -c doc/config.ld src/bin/lua

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

