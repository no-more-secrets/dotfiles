-----------------------------------------------------------------
-- Snippets for all file types.
-----------------------------------------------------------------
local assembler = require( 'dsicilia.snippets.assemble' )
local S = {}

-----------------------------------------------------------------
-- Snippets.
-----------------------------------------------------------------
-- Doesn't seem to work in all environments.
S.clip = '$CLIPBOARD$0'

-----------------------------------------------------------------
-- Assemble and parse snippets.
-----------------------------------------------------------------
return assembler.assemble( S )