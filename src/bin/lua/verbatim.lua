--- Verbatim class
-- Represents a line translated directed to the binding file.
-- The following filds are stored:
--   line = line text
classVerbatim = {
  line = '',
  cond = nil,    -- condition: where to generate the code (s=suport, r=register)
}
classVerbatim.__index = classVerbatim
setmetatable(classVerbatim,classFeature)

-- preamble verbatim
function classVerbatim:preamble ()
  if self.cond == '' then
    write(self.line)
  end
end

-- support code
function classVerbatim:supcode ()
  if strfind(self.cond,'s') then
    write(self.line)
    write('\n')
  end
end

-- register code
function classVerbatim:register ()
  if strfind(self.cond,'r') then
    write(self.line)
  end
end


-- Print method
function classVerbatim:print (ident,close)
  print(ident.."Verbatim{")
  print(ident.." line = '"..self.line.."',")
  print(ident.."}"..close)
end

-- Constructor
-- Expects a string representing the text line
function Verbatim (l,cond)
  if l:sub(1,1) == '$' then
    cond = 'sr'       -- generates in both suport and register fragments
    l = l:sub(2)
  end
  local t = setmetatable({ line = l, cond = cond or '', }, classVerbatim)
  append(t)
  return t
end


