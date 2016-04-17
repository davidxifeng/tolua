
-- 类 继承图（部分）

--  classFeature |
--               |--> classFunction
--               |--> classVerbatim
--               |--> classCode
--               |--> classDeclaration |
--               |                     |-> classVariable
--               |
--               |--> classContainer   |
--               |                     |-> classClass
--               |                     |-> classModule  -|
--               |                     |                 |---> classNamespace
--               |                     |-> classPackage
--



function doit ()
  -- define package name, if not provided
  if not flags.n then
    if flags.f then
      flags.n = gsub(flags.f,"%..*","")
    else
      error("#no package name nor input file provided")
    end
  end

  -- proccess package 解析
  local p = Package(flags.n,flags.f)

  -- only parse
  if flags.p then return end

  -- 打开输出文件
  if flags.o then assert(writeto(flags.o)) end

  p:decltype()
  if flags.P then
    p:print() -- 打印解析结果
  else
    -- tolua的输出分成3个段
    -- preamble: 序言 开场白
    -- 内容：
    --    标准模板 头文件引入 导出函数，tolua库函数原型声明
    --    直译部分
    --    tolua_reg_types(注册模块内的自定义类型)
    p:preamble()

    -- support code
    -- Lua的C函数部分
    p:supcode()

    -- 注册函数
    -- luaopen_模块名 打开模块的Lua C函数
    -- tolua_模块名_open 打开模块的C接口函数（lua_call调用Lua C函数）
    p:register()
  end
  if flags.o then writeto() end -- 关闭输出文件handle

  -- write header file
  -- 额外输出头文件
  if not flags.P and flags.H then
    assert(writeto(flags.H))
    p:header()
    writeto()
  end
end
