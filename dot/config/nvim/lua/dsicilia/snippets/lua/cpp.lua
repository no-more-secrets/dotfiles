-----------------------------------------------------------------
-- C++ snippets.
-----------------------------------------------------------------
local assembler = require( 'dsicilia.snippets.assemble' )
local S = {}

-----------------------------------------------------------------
-- Snippets.
-----------------------------------------------------------------
-- Sample lua snippet: parameter label. This theoretically is
-- supposed to work in all languages, but it doesn't seem to work
-- in Lua.
S.plabel = '$BLOCK_COMMENT_START$1=$BLOCK_COMMENT_END$0'

-----------------------------------------------------------------
-- Assemble and parse snippets.
-----------------------------------------------------------------
return assembler.assemble( S )
