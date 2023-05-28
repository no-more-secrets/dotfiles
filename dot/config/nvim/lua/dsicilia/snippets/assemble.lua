-----------------------------------------------------------------
-- LuaSnip snippet assembler.
-----------------------------------------------------------------
local M = {}

-----------------------------------------------------------------
-- Imports.
-----------------------------------------------------------------
local ls = require( 'luasnip' )
local parse = ls.parser.parse_snippet

-----------------------------------------------------------------
-- Assembler.
-----------------------------------------------------------------
function M.assemble( snippets )
  -- Regular snippets are not automatically selected when the key
  -- word is typed, while auto snippets are.
  local manual_snippets = {}
  local auto_snippets = {}

  for name, text in pairs( snippets ) do
    local key = '=' .. name
    table.insert( auto_snippets, parse( key, text ) )
  end

  return manual_snippets, auto_snippets
end

function M.parse_snippets( snippets )
  local res = {}
  for name, text in pairs( snippets ) do
    local key = '=' .. name
    table.insert( res, parse( key, text ) )
  end
  return res
end

-----------------------------------------------------------------
-- Finished.
-----------------------------------------------------------------
return M
