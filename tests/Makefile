

all : test

test : main.o
	gcc -O2 -Wl,-E -L../lua-5.3.2 -L../lib  -o $@ $< -ltolua -llua -lm -ldl

main.o : main.c
	gcc -std=gnu99 -c -O2 -I../lua-5.3.2 -I../include -o $@ $^

clean :
	rm -f *.o
	rm -f test
