-----------------------------------------------------------------
-- Search related things.
-----------------------------------------------------------------
local mappers = require( 'dsicilia.mappers' )

-----------------------------------------------------------------
-- Aliases.
-----------------------------------------------------------------
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local cmd = vim.cmd
local getreg, setreg = vim.fn.getreg, vim.fn.setreg
local nmap = mappers.nmap

-----------------------------------------------------------------
-- Implementation.
-----------------------------------------------------------------
-- "Press" the unmapped version of a key in normal mode.
local function norm_unmapped( c )
  return cmd{ cmd='norm', args={ c }, bang=true }
end

-- This monstrosity manually recreates the behavior of the de-
-- fault / search command, with regard to incremental highlight-
-- ing, cursor placement, and behavior upon cancelling out of the
-- search before hitting enter, while at the same time trying to
-- get the hlslens plugin to do the right thing. It does this all
-- for the purpose of avoiding the error message that normally
-- results when the search yields no results, which doesn't work
-- well with cmdheight=0.
local function search_cmd_with_manual_incsearch_highlight()
  local function set_search( what )
    what = what or ''
    setreg( '/', what )
    setreg( '/', what )
    vim.o.hls = true
    require( 'hlslens.render' ):refresh( true )
    vim.cmd[[redraw!]]
  end
  local GROUP = 'ManualIncSearch'
  local old_search = getreg( '/' )
  local old_v_hlsearch = vim.v.hlsearch
  autocmd( 'CmdlineChanged', {
    group=augroup( GROUP, { clear=true } ),
    callback=function()
      set_search( vim.fn.getcmdline() )
    end,
  } )
  local input = vim.fn.input( '/' )
  vim.api.nvim_del_augroup_by_name( GROUP )
  if #input > 0 then
    set_search( input )
    vim.cmd.normal( 'n' )
    return
  end
  -- The search was cancelled, so try to restore the state to
  -- what it was previously, both with regard to the search
  -- phrase and whether highlighting was visible or not.
  setreg( '/', old_search )
  if old_v_hlsearch == 0 then
    vim.cmd.nohlsearch()
    require( 'hlslens' ).stop()
  else
    vim.o.hls = true
    require( 'hlslens' ).start()
    require( 'hlslens.render' ):refresh()
  end
  vim.cmd[[redraw!]]
end

-----------------------------------------------------------------
-- Key bindings.
-----------------------------------------------------------------
-- When searching for something that yields no results, vim nor-
-- mally sends an error message to the message box, which causes
-- issues when cmdheight=0, since then it asks to press enter.
-- These will effectively silence that until the issue has a
-- better workaround.
--
-- The / command is particularly difficult because the / key in-
-- vokes input on the command line. So we need to replicate that
-- in a way that allows input, suppresses errors, but also re-
-- tains highlighting of incremental search results (which would
-- not happen if we simply replaced / with :silent! /. FIXME:
-- this seems to work at the moment, but is way too complicated;
-- try to get rid of it when the associated issue is resolved:
--
--   See: github.com/neovim/neovim/issues/24059
--
nmap['/'] = search_cmd_with_manual_incsearch_highlight
nmap['n'] = function() pcall( norm_unmapped, 'n' ) end
nmap['N'] = function() pcall( norm_unmapped, 'N' ) end
