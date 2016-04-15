project          = 'tolua'
description      = 'tolua binding code generator'
full_description = 'doc for code reading'
title            = 'Documentation'
dir              = 'doc/build' -- output dir
style            = '!fixed'

-- 专题文档
--topics           = 'manual'


-- luarocks install lua-discount
--format           = 'discount'
format           = 'markdown'

sort_modules     = true

--package          = 'pl'

-- file在命令行参数中指定
-- file             = '../service'

--
--examples         = {'../examples','../tests/test-data.lua'}

use_markdown_titles = true

kind_names = {
    topic  = 'Manual',
    module = 'Module'
}

alias('ret',{
    'return',
    modifiers = {type = "$1"}
})

-- define custom tag:
--custom_tags = { { 'service', hidden = false } }
--custom_display_name_handler = function(item, default_handler)
  --if item.type == 'function' and item.tags.callback then
    --return item.name .. ' [service]'
  --end
  --return default_handler(item)
--end

-- vim: ft=lua
