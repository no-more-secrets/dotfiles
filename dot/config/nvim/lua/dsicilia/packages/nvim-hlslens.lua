-----------------------------------------------------------------
-- Package: nvim-hlslens.
-----------------------------------------------------------------
-- This plugin does some things on its own which are not very
-- useful, but we're keeping it because it is needed to support
-- the search highlight feature of nvim-scrollbar.
-----------------------------------------------------------------
-- Imports.
-----------------------------------------------------------------
local hlslens = require( 'hlslens' )
local mappers = require( 'dsicilia.mappers' )
local keymap = require( 'dsicilia.keymap' )

-----------------------------------------------------------------
-- Aliases.
-----------------------------------------------------------------
local nmap = mappers.nmap
local max = math.max
local cmd = vim.cmd

-----------------------------------------------------------------
-- Setup.
-----------------------------------------------------------------
hlslens.setup{
  auto_enable=true,
  nearest_only=true,
  nearest_float_when='never',
  -- This is so that the virtual text will take priority over
  -- other virtual text such as git-blame and diagnostics.
  virt_priority=10,
  build_position_cb=function( plist, _, _, _ )
    local search = require( 'scrollbar.handlers.search' )
    search.handler.show( plist.start_pos )
  end,
}

-----------------------------------------------------------------
-- Key bindings.
-----------------------------------------------------------------
local function norm_cmd_then_start( c )
  nmap[c] = function()
    -- This lets us do e.g. 5n to repeat the command 5 times. If
    -- no number precedes the command then it will be 0.
    local n = max( vim.v.count, 1 )
    pcall( function()
      cmd{ cmd='normal', args={ tostring( n ) .. c }, bang=true }
    end )
    hlslens.start()
  end
end

norm_cmd_then_start( 'n' )
norm_cmd_then_start( 'N' )
norm_cmd_then_start( '*' )
norm_cmd_then_start( '#' )

nmap['&'] = function()
  keymap.ampersand()
  hlslens.start()
end
