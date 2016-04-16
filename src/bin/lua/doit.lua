
-- 类 继承图（部分）

--                                                            -> classFeature
--                                           classFunction    |
--
--                                           classVerbatim    |
--
--                                        -> classDeclaration |
--                       classVariable |
--
--                                        -> classContainer   |
--                        classPackage |
--
--                    ->  classModule  |
--    classNamespace  |



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
    p:preamble() -- preamble: 序言 开场白
    p:supcode() -- support code
    p:register() -- 注册函数
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
