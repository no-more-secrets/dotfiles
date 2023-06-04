-----------------------------------------------------------------
-- Package: hop.
-----------------------------------------------------------------
local hop = require( 'hop' )
local mappers = require( 'dsicilia.mappers' )

-----------------------------------------------------------------
-- Aliases.
-----------------------------------------------------------------
local nmap = mappers.nmap

-----------------------------------------------------------------
-- Setup.
-----------------------------------------------------------------
hop.setup{
  keys='etovpdygflhckisuran', --
}

local directions = require( 'hop.hint' ).HintDirection

-----------------------------------------------------------------
-- Keymaps.
-----------------------------------------------------------------
nmap[';'] = vim.cmd.HopWord

vim.keymap.set( '', 'f', function()
  hop.hint_char1( {
    direction=directions.AFTER_CURSOR,
    current_line_only=true,
  } )
end, { remap=true } )

vim.keymap.set( '', 'F', function()
  hop.hint_char1( {
    direction=directions.BEFORE_CURSOR,
    current_line_only=true,
  } )
end, { remap=true } )
