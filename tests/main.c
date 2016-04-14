#include <stdio.h>

#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"

#include "tolua.h"

int main(int argc, char const* argv[])
{
  lua_State * L = luaL_newstate();
  luaL_openlibs(L);

  tolua_open(L);

  if (luaL_dofile(L, argc > 1 ? argv[1] : "main.lua")) {
    printf("run lua error!\n");
  }

  lua_close(L);
  return 0;
}
