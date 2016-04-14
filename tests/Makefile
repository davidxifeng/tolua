

PLAT= none

default : $(PLAT)

all : test

none :
	@echo 'make linux or macosx'

linux :
	make all cflags="-std=gnu99 -c -O2" export="-Wl,-E" libs="-lm -ldl"

macosx :
	make all cflags="-std=gnu99 -c -O2" export="" libs=""

test : main.o
	gcc $(export) -L../lua-5.3.2 -L../lib  -o $@ $< -ltolua -llua $(libs)

main.o : main.c
	gcc $(cflags) -I../lua-5.3.2 -I../include -o $@ $^

clean :
	rm -f *.o
	rm -f test
