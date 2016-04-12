
extern "C" {
#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"
}

#include "tpeer.h"

int main ()
{
  int  tolua_tpeer_open (lua_State*);

  lua_State* L = luaL_newstate();
  luaL_openlibs(L);
  tolua_tpeer_open(L);
  if (luaL_dofile(L,"tpeer.lua")) {
    printf("Error: %s\n",lua_tostring(L,-1));
  }
  lua_close(L);

  return 0;
}

