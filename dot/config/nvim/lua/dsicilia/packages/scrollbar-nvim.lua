-----------------------------------------------------------------
-- Package: scrollbar.nvim
-----------------------------------------------------------------
local M = {}

-----------------------------------------------------------------
-- Imports.
-----------------------------------------------------------------
local sb = require( 'scrollbar' )
local colors = require( 'dsicilia.colors' )
local palette = require( 'gruvbox.palette' )

-----------------------------------------------------------------
-- Aliases.
-----------------------------------------------------------------
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-----------------------------------------------------------------
-- Colors.
-----------------------------------------------------------------
colors.hl_setter( 'ScrollbarColors', function( hi )
  local P = palette.colors
  hi.ScrollbarHead = { fg=P.faded_blue }
  hi.ScrollbarBody = { fg=P.neutral_blue }
  hi.ScrollbarTail = { fg=P.faded_blue }
end )

vim.g.scrollbar_highlight = {
  head='ScrollbarHead',
  body='ScrollbarBody',
  tail='ScrollbarTail',
}

-----------------------------------------------------------------
-- Auto-commands.
-----------------------------------------------------------------
local show_events = {
  'WinEnter', 'BufEnter', 'FocusGained', 'WinScrolled',
  'VimResized', 'QuitPre',
}

local hide_events = {
  'WinLeave', 'BufLeave', 'BufWinLeave', 'FocusLost',
}

autocmd( show_events, {
  group=augroup( 'ScrollbarShow', { clear=true } ),
  -- Need to wrap in function because show takes default params.
  callback=function() sb.show() end,
} )

autocmd( hide_events, {
  group=augroup( 'ScrollbarClear', { clear=true } ),
  -- Need to wrap in function because show takes default params.
  callback=function() sb.clear() end,
} )

-----------------------------------------------------------------
-- Finished.
-----------------------------------------------------------------
return M
