--- Module class
-- Represents module.
-- The following fields are stored:
--    {i} = list of objects in the module.
classModule = {
  classtype = 'module'
}
classModule.__index = classModule
setmetatable(classModule,classContainer)

-- register module
function classModule:register ()
  push(self)
  output(' tolua_module(tolua_S,"'..self.name..'",',self:hasvar(),');')
  output(' tolua_beginmodule(tolua_S,"'..self.name..'");')
  local i=1
  while self[i] do
    self[i]:register()
    i = i+1
  end
  output(' tolua_endmodule(tolua_S);')
  pop()
end

-- Print method
function classModule:print (ident,close)
  print(ident.."Module{")
  print(ident.." name = '"..self.name.."';")
  local i=1
  while self[i] do
    self[i]:print(ident.." ",",")
    i = i+1
  end
  print(ident.."}"..close)
end

-- Constructor
-- Expects two string representing the module name and body.
function Module (n,b)
  local t = setmetatable(_Container{name=n}, classModule)
  append(t)

  push(t)
  t:parse(strsub(b,2,strlen(b)-1)) -- eliminate braces
  pop()
  return t
end

-- vim: tabstop=2 shiftwidth=2 softtabstop=2
