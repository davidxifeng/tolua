# makefile for tolua executable

TOLUA=../..

include $(TOLUA)/config

OBJS_D = tolua.o

T= $(TOLUA)/bin/tolua

all: $(T)

$(T): $(OBJS_D)
	$(CC) -o $@ $(OBJS_D) $(LIB) -ltolua -llua -lm

tolua.o: tolua.c
	$(CC) -c $(INC) -o $@ $<

clean:
	rm -f $(OBJS_D) $(T)
