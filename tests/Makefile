

PLAT= none

default : $(PLAT)

all : test array.so

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

array_gen.c : array.pkg
	../bin/tolua -o array_gen.c array.pkg

array_gen.o : array_gen.c
	gcc $(cflags) -fPIC -I../lua-5.3.2 -I../include -o $@ $^

array.so : array_gen.o
	gcc -shared -o $@ $<

clean :
	rm -f *.o
	rm -f test
	rm -f array.so array_gen.c array_gen.o

