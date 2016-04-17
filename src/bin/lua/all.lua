
check_type = false
show_log = true

local ANSI_COLOR_RED    = '\x1b[31m'
local ANSI_COLOR_GREEN  = '\x1b[32m'
local ANSI_COLOR_YELLOW = '\x1b[33m'
local ANSI_COLOR_BLUE   = '\x1b[34m'
local ANSI_COLOR_RESET  = '\x1b[0m'

function log (...)
  if show_log then
    print(ANSI_COLOR_YELLOW, ..., ANSI_COLOR_RESET)
  end
end

function info (...)
  if show_log then
    print(ANSI_COLOR_GREEN, ..., ANSI_COLOR_RESET)
  end
end

function fatal (...)
  if show_log then
    print(ANSI_COLOR_RED, ..., ANSI_COLOR_RESET)
  end
end

dofile(path.."inspect.lua")

dofile(path.."compat.lua")
dofile(path.."basic.lua")
dofile(path.."feature.lua")
dofile(path.."verbatim.lua")
dofile(path.."code.lua")
dofile(path.."typedef.lua")
dofile(path.."container.lua")
dofile(path.."package.lua")
dofile(path.."module.lua")
dofile(path.."namespace.lua")
dofile(path.."define.lua")
dofile(path.."enumerate.lua")
dofile(path.."declaration.lua")
dofile(path.."variable.lua")
dofile(path.."array.lua")
dofile(path.."function.lua")
dofile(path.."operator.lua")
dofile(path.."class.lua")
dofile(path.."clean.lua")
dofile(path.."doit.lua")

local err,msg = pcall(doit)
if not err then
  local _,_,label,msg = strfind(msg,"(.-:.-:%s*)(.*)")
  tolua_error(msg,label)
end
