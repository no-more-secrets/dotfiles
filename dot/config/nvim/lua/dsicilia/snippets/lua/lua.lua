-----------------------------------------------------------------
-- Lua snippets.
-----------------------------------------------------------------
local assembler = require( 'dsicilia.snippets.assemble' )
local S = {}

-----------------------------------------------------------------
-- Snippets.
-----------------------------------------------------------------
-- Sample lua snippet. Trigger by typing =zzz.
S.zzz =
[[local function $1( $2 )
  $0
end

]]

-----------------------------------------------------------------
-- Assemble and parse snippets.
-----------------------------------------------------------------
return assembler.assemble( S )
