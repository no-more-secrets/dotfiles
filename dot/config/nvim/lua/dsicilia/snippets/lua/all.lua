-----------------------------------------------------------------
-- Snippets for all occasions and filetypes.
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
-- Doesn't seem to do what one would expect in all environments;
-- in some cases it just pastes what is in the + register.
add_p {
  '=paste',
  '$CLIPBOARD$0'
}

-----------------------------------------------------------------
-- Finished
-----------------------------------------------------------------
return {}, S
