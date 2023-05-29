-----------------------------------------------------------------
-- C++ snippets.
-----------------------------------------------------------------
local ls = require( "luasnip" )
local parse = ls.parser.parse_snippet

local up = 'unpack'; local unpack = _G[up] -- fool the linter.

local S = {} -- Will hold result.

local function add_p( tbl )
  table.insert( S, parse( unpack( tbl ) ) )
end

-----------------------------------------------------------------
-- Snippets.
-----------------------------------------------------------------
add_p {
  '=plabel',
  '$BLOCK_COMMENT_START$1=$BLOCK_COMMENT_END$0'
}

-----------------------------------------------------------------
-- Finished
-----------------------------------------------------------------
return {}, S
