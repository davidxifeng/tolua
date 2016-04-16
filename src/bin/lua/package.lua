--- Package class
-- Represents the whole package being bound.
-- The following fields are stored:
--  {i} = list of objects in the package.
classPackage = { classtype = 'package' }
classPackage.__index = classPackage
setmetatable(classPackage,classContainer)

-- Print method
function classPackage:print ()
  print("Package: "..self.name)
  local i=1
  while self[i] do
    self[i]:print("","")
    i = i+1
  end
end


--- 删除注释 inline public virtual 等不支持（无意义）的关键字
-- 取出嵌入的Lua C 直译代码，预处理完之后再恢复
function classPackage:preprocess ()
  local code = self.code

  -- avoid preprocessing embedded Lua code
  local L = {}
  code = gsub(code,"\n%s*%$%[","\1") -- deal with embedded Lua code
  code = gsub(code,"\n%s*%$%]","\2")
  code = gsub(code,"(%b\1\2)", function (c)
    table.insert(L,c)
    return "\n#[".. #L .."]#"
  end)

  -- avoid preprocessing embedded C code
  local C = {}
  code = gsub(code,"\n%s*%$%<","\3") -- deal with embedded C code
  code = gsub(code,"\n%s*%$%>","\4")
  code = gsub(code,"(%b\3\4)", function (c)
    table.insert(C,c)
    return "\n#<".. #C..">#"
  end)

  -- avoid preprocessing verbatim lines
  local V = {}
  code = gsub(code,"\n(%s*%$[^%[%]][^\n]*)",function (v)
    table.insert(V,v)
    return "\n#".. #V .."#"
  end)

  -- perform global substitution
  code = gsub(code,"(//[^\n]*)","")     -- eliminate C++ comments
  code = gsub(code,"/%*","\1")
  code = gsub(code,"%*/","\2")
  code = gsub(code,"%b\1\2","")
  code = gsub(code,"\1","/%*")
  code = gsub(code,"\2","%*/")
  code = gsub(code,"%s*@%s*","@") -- eliminate spaces beside @
  code = gsub(code,"%s?inline(%s)","%1") -- eliminate 'inline' keyword
  -- capture index %1 -%9
  code = gsub(code,"%s?extern(%s)","%1") -- eliminate 'extern' keyword
  code = gsub(code,"%s?virtual(%s)","%1") -- eliminate 'virtual' keyword
  code = gsub(code,"public%s*:","") -- eliminate 'public:' keyword
  code = gsub(code,"private%s*:","") -- eliminate 'private:' keyword
  code = gsub(code,"protected%s*:","") -- eliminate 'protected:' keyword
  code = gsub(code,"([^%w_])void%s*%*","%1_userdata ") -- substitute 'void*'
  code = gsub(code,"([^%w_])char%s*%*","%1_cstring ")  -- substitute 'char*'
  code = gsub(code,"([^%w_])lua_State%s*%*","%1_lstate ")  -- substitute 'lua_State*'
  -- FIX:
  -- void* 重复的行
  -- public: 支持空白
  -- 增加 private protected，不过这个不删除也不影响后续的处理

  -- restore embedded code
  code = gsub(code,"%#%[(%d+)%]%#",function (n) return L[tonumber(n)] end)
  -- restore embedded code
  code = gsub(code,"%#%<(%d+)%>%#",function (n) return C[tonumber(n)] end)
  -- restore verbatim lines
  code = gsub(code,"%#(%d+)%#",function (n) return V[tonumber(n)] end)

  self.code = code
end

-- translate verbatim
function classPackage:preamble ()
  output('/*\n')
  output('** Lua binding: '..self.name..'\n')

  -- output('** Generated automatically by '..TOLUA_VERSION..' on '..date()..'.\n')

  output('*/\n\n')

  output('#include "tolua.h"\n\n')
  output('#ifndef __cplusplus\n')
  output('#include <stdlib.h>\n')
  output('#endif\n')
  output('#ifdef __cplusplus\n')
  output('extern "C" int tolua_bnd_takeownership (lua_State* L); // from tolua_map.c\n')
  output('#else\n')
  output('int tolua_bnd_takeownership (lua_State* L); /* from tolua_map.c */\n')
  output('#endif\n')
  output('#include <string.h>\n\n')

  if not flags.h then
    output('/* Exported function */')
    output('TOLUA_API int  tolua_'..self.name..'_open (lua_State* tolua_S);')
    output('LUALIB_API int  luaopen_'..self.name..' (lua_State* tolua_S);')
    output('\n')
  end

  local i=1
  while self[i] do
    self[i]:preamble()
    i = i+1
  end

  if self:requirecollection(_collect) then
    output('\n')
    output('/* function to release collected object via destructor */')
    output('#ifdef __cplusplus\n')
    for i,v in pairs(_collect) do
      output('\nstatic int '..v..' (lua_State* tolua_S)')
      output('{')
      output(' '..i..'* self = ('..i..'*) tolua_tousertype(tolua_S,1,0);')
      output(' tolua_release(tolua_S,self);')
      output(' delete self;')
      output(' return 0;')
      output('}')
    end
    output('#endif\n\n')
  end

  output('\n')
  output('/* function to register type */')
  output('static void tolua_reg_types (lua_State* tolua_S)')
  output('{')
  foreach(_usertype,function(n,v) output(' tolua_usertype(tolua_S,"',v,'");') end)
  output('}')
  output('\n')
end

-- register package
-- write package open function
function classPackage:register ()
  push(self)

  output("/* Open lib function */")
  output('LUALIB_API int  luaopen_'..self.name..' (lua_State* tolua_S)')
  output("{")
  output(" tolua_open(tolua_S);")
  output(" tolua_reg_types(tolua_S);")
  output(" tolua_module(tolua_S,NULL,",self:hasvar(),");")
  output(" tolua_beginmodule(tolua_S,NULL);")
  local i=1
  while self[i] do
    self[i]:register()
    i = i+1
  end
  output(" tolua_endmodule(tolua_S);")
  output(" return 1;")
  output("}")

  output("/* Open tolua function */")
  output("TOLUA_API int tolua_"..self.name.."_open (lua_State* tolua_S)")
  output("{")
  output("  lua_pushcfunction(tolua_S, luaopen_"..self.name..");")
  output('  lua_pushstring(tolua_S, "'..self.name..'");')
  output("  lua_call(tolua_S, 1, 0);")
  output("  return 1;")
  output("}")

  pop()
end

-- write header file
function classPackage:header ()
  output('/*\n') output('** Lua binding: '..self.name..'\n')
  output('** Generated automatically by '..TOLUA_VERSION..' on '..date()..'.\n')
  output('*/\n\n')

  if not flags.h then
    output('/* Exported function */')
    output('TOLUA_API int  tolua_'..self.name..'_open (lua_State* tolua_S);')
    output('LUALIB_API int  luaopen_'..self.name..' (lua_State* tolua_S);')
    output('\n')
  end
end

-- Parse C header file with tolua directives
-- *** Thanks to Ariel Manzur for fixing bugs in nested directives ***
function extract_code(fn,s)
  local code = '\n$#include "'..fn..'"\n'
  s = "\n" .. s .. "\n" -- add blank lines as sentinels
  local _,e,c,t = strfind(s, "\n([^\n]-)[Tt][Oo][Ll][Uu][Aa]_([^%s]*)[^\n]*\n")
  while e do
    t = strlower(t)
    if t == "begin" then
      _,e,c = strfind(s,"(.-)\n[^\n]*[Tt][Oo][Ll][Uu][Aa]_[Ee][Nn][Dd][^\n]*\n",e)
      if not e then
        tolua_error("Unbalanced 'tolua_begin' directive in header file")
      end
    end
    code = code .. c .. "\n"
    _,e,c,t = strfind(s, "\n([^\n]-)[Tt][Oo][Ll][Uu][Aa]_([^%s]*)[^\n]*\n",e)
  end
  return code
end

--- parse a package file
-- @string name package name
-- @string[opt] fn input pkg file name, or stdin
function Package (name,fn)
  local ext = "pkg"

  -- open input file, if any
  local input_file
  if fn then
    input_file, msg = io.open(fn, "r")

    if not input_file then
      error('#'..msg)
    end
    ext = fn:match(".*%.(.*)$")
  else
    input_file = io.stdin
  end

  local code = "\n" .. input_file:read('*a')

  if ext == 'h' or ext == 'hpp' then
    code = extract_code(fn,code)
  end

  -- close file
  if input_file then
    input_file:close()
  end

  -- deal with renaming directive
  code = gsub(code,'%s*%$renaming%s*(.-)%s*\n', function (r) appendrenaming(r) return "\n" end)

  -- deal with include directive
  repeat
    local nsubst
    code,nsubst = gsub(code,'\n%s*%$(.)file%s*"(.-)"%s*\n', function (kind,fn)
      local _, _, ext = strfind(fn,".*%.(.*)$")
      local fp,msg = io.open(fn,'r')
      if not fp then
        error('#'..msg..': '..fn)
      end
      local s = fp:read('*a')
      fp:close()
      if kind == 'c' or kind == 'h' then
        return extract_code(fn,s)
      elseif kind == 'p' then
        return "\n\n" .. s
      elseif kind == 'l' then
        return "\n$[\n" .. s .. "\n$]\n"
      else
        error('#Invalid include directive (use $cfile, $pfile or $lfile)')
      end
    end)
  until nsubst==0

  --io.open(name .. 'p_pkg.h', 'wb'):write(code)

  local t = setmetatable(_Container {name=name, code=code}, classPackage)
  push(t)
  t:preprocess() -- package 预处理
  t:parse(t.code) -- container 解析
  pop()
  return t
end

-- vim: tabstop=2 shiftwidth=2 softtabstop=2
