-----------------------------------------------------------------
-- Package: leap
-----------------------------------------------------------------
-- This is a quick navigation plugin.

-----------------------------------------------------------------
-- Imports.
-----------------------------------------------------------------
local mappers = require( 'dsicilia.mappers' )

-----------------------------------------------------------------
-- Aliases.
-----------------------------------------------------------------
local nmap = mappers.nmap

-----------------------------------------------------------------
-- Keymaps.
-----------------------------------------------------------------
nmap['s'] = '<Plug>(leap-forward-to)'
nmap['S'] = '<Plug>(leap-backward-to)'

-- Bidirectional. Uncomment this is the directional keys above
-- don't work out; this has a disadvantage that it won't auto
-- jump to the closest match, like the directional versions will,
-- since it doesn't know which direction you want to go.
-- nmap[';'] = function ()
--   local current_window = vim.fn.win_getid()
--   require( 'leap' ).leap{ target_windows={ current_window } }
-- end
