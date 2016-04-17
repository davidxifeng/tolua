--- Code class
-- Represents Lua code to be compiled and included
-- in the initialization function.
-- The following fields are stored:
--   text = text code
classCode = { text = '' }
classCode.__index = classCode
setmetatable(classCode,classFeature)

--- register code
function classCode:register ()
  -- clean Lua code
  local s = clean(self.text)
  if not s then
    error("parser error in embedded code")
  end

  -- convert to C
  output('\n { /* begin embedded lua code */\n')
  output('  static unsigned char B[] = {\n   ')
  local t={n=0}
  local b = gsub(s,'(.)',function (c)
    local e = ''
    t.n=t.n+1
    if t.n==15 then
      t.n=0 e='\n   '
    end
    return format('%3u,%s',strbyte(c),e)
  end)
  output(b..strbyte(" "))
  output('\n  };\n')
  output('  if (luaL_loadbuffer(tolua_S,(char*)B,sizeof(B),"tolua: embedded Lua code") == LUA_OK)\n')
  output('    lua_pcall(tolua_S,0,LUA_MULTRET,0);')
  output(' } /* end of embedded lua code */\n\n')
end


--- Print method
function classCode:print (ident,close)
  print(ident.."Code{")
  print(ident.." text = [["..self.text.."]],")
  print(ident.."}"..close)
end

--- Constructor
-- Expects a string representing the code text
function Code (l)
  local t = setmetatable({ text = l },classCode)
  append(t)
  return t
end
