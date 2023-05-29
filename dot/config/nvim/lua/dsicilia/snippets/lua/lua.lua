-----------------------------------------------------------------
-- Lua snippets.
-----------------------------------------------------------------
local ls = require( "luasnip" )
local s = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require( "luasnip.extras.fmt" ).fmt

local up = 'unpack'; local unpack = _G[up] -- fool the linter.

local S = {} -- Will hold result.

local function add_s( tbl )
  table.insert( S, s( unpack( tbl ) ) )
end

-----------------------------------------------------------------
-- Snippets.
-----------------------------------------------------------------
local function center_offset( nodes )
  local node = nodes[1]
  local text = node[1]
  local len = #text
  local preamble_len = 3 -- "-- "
  -- We could get the 65 from vim.o.textwidth, but that's prob-
  -- ably fancier than we need here.
  local max_len = 65 - preamble_len
  if len >= max_len then return '' end
  len = math.floor( (max_len-len)/2 )
  return string.rep( ' ', math.max( 0, len-preamble_len ) )
end

-- This is a section header where the text entered will be cen-
-- tered in real time as the user types.
add_s {
  '=csection',
  fmt(
    [[
      -----------------------------------------------------------------
      -- {}{}
      -----------------------------------------------------------------
      {}
    ]],
    {
      f( center_offset, { 1 } ),
      i( 1 ),
      i( 0 ),
    }
  )
}

-----------------------------------------------------------------
-- Finished
-----------------------------------------------------------------
return {}, S
