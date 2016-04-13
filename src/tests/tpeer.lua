local mt = {
  __index = function (self,key)
    if key == 1 then
      return self._obj:X()
    elseif key == 2 then
      return self._obj:Y()
    elseif key == "Sum" then
      return function (self) return self:X() + self:Y() end
    else
      return nil
    end
  end
}
local p = Point:new(2,3)
local t = tolua.getpeertable(p)
t._obj = p
setmetatable(t,mt)
assert(p[1]+p[2] == p:Sum())

local x, y = p:gets()
assert(x==p[1] and y==p[2])

print("Peer test OK")
