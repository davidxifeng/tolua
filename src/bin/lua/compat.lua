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

-------------------------------------------------------------------
-- string library
local string = string
strbyte   = string.byte
strchar   = string.char
strfind   = string.find
format    = string.format
gsub      = string.gsub
strlen    = string.len
strlower  = string.lower
strrep    = string.rep
strsub    = string.sub
strupper  = string.upper

-------------------------------------------------------------------
-- os library
date   = os.date
remove = os.remove
rename = os.rename
time   = os.time


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
  if type(arg[1]) == 'userdata' then
    f = tab.remove(arg, 1)
  end
  return f:write(table.unpack(arg))
end

