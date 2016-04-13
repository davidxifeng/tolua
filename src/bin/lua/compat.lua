-------------------------------------------------------------------
-- Real globals
-- _ALERT
-- _ERRORMESSAGE
-- _VERSION
-- _G
-- assert
-- error
-- metatable
-- next
-- print
-- require
-- tonumber
-- tostring
-- type

-------------------------------------------------------------------
-- collectgarbage
-- gcinfo

-- globals

-- call   -> protect(f, err)

-- rawget
-- rawset

-- getargs = Main.getargs ??

rawtype = type

function do_ (f, err)
  if not f then print(err); return end
  local a,b = pcall(f)
  if not a then print(b); return nil
  else return b or true
  end
end

function dostring(s) return do_(load(s)) end

-------------------------------------------------------------------
-- Table library
local tab = table
foreach = function(t,f)
  for k,v in pairs(t) do
    f(k,v)
  end
end
foreachi = function(t,f)
  for i,v in ipairs(t) do
    f(i,v)
  end
end
getn = function(t)
  return #t
end
tinsert = tab.insert
tremove = tab.remove
sort = tab.sort

-------------------------------------------------------------------
-- Debug library
local dbg = debug
getinfo = dbg.getinfo
getlocal = dbg.getlocal
setcallhook = function () error"`setcallhook' is deprecated" end
setlinehook = function () error"`setlinehook' is deprecated" end
setlocal = dbg.setlocal

-------------------------------------------------------------------
-- math library
local math = math
abs = math.abs
acos = function (x) return math.deg(math.acos(x)) end
asin = function (x) return math.deg(math.asin(x)) end
atan = function (x) return math.deg(math.atan(x)) end
atan2 = function (x,y) return math.deg(math.atan2(x,y)) end
ceil = math.ceil
cos = function (x) return math.cos(math.rad(x)) end
deg = math.deg
exp = math.exp
floor = math.floor
frexp = math.frexp
ldexp = math.ldexp
log = math.log
log10 = math.log10
max = math.max
min = math.min
mod = math.mod
PI = math.pi
--??? pow = math.pow  
rad = math.rad
random = math.random
randomseed = math.randomseed
sin = function (x) return math.sin(math.rad(x)) end
sqrt = math.sqrt
tan = function (x) return math.tan(math.rad(x)) end

-------------------------------------------------------------------
-- string library
local str = string
strbyte = str.byte
strchar = str.char
strfind = str.find
format = str.format
gsub = str.gsub
strlen = str.len
strlower = str.lower
strrep = str.rep
strsub = str.sub
strupper = str.upper

-------------------------------------------------------------------
-- os library
clock = os.clock
date = os.date
difftime = os.difftime
execute = os.execute --?
exit = os.exit
getenv = os.getenv
remove = os.remove
rename = os.rename
setlocale = os.setlocale
time = os.time
tmpname = os.tmpname


-------------------------------------------------------------------

local io, tab = io, table

-- IO library (files)
_STDERR = io.stderr
_OUTPUT = io.stdout

function writeto (name)
  if name == nil then
    local f, err, cod = io.close(_OUTPUT)
    _OUTPUT = io.stdout
    return f, err, cod
  else
    local f, err, cod = io.open(name, "w")
    _OUTPUT = f or _OUTPUT
    return f, err, cod
  end
end

function appendto (name)
  local f, err, cod = io.open(name, "a")
  _OUTPUT = f or _OUTPUT
  return f, err, cod
end

function write (...)
  local f = _OUTPUT
  local arg = {...}
  if rawtype(arg[1]) == 'userdata' then
    f = tab.remove(arg, 1)
  end
  return f:write(table.unpack(arg))
end

