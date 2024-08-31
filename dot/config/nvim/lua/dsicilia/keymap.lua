-----------------------------------------------------------------
--                      Keys & Keymaps
-----------------------------------------------------------------
local M = {}

-----------------------------------------------------------------
-- Imports
-----------------------------------------------------------------
local mappers = require( 'dsicilia.mappers' )
local tabs = require( 'dsicilia.tabs' )
local quitting = require( 'dsicilia.quitting' )

-----------------------------------------------------------------
-- Aliases
-----------------------------------------------------------------
local cmd = vim.cmd
local expand = vim.fn.expand
local floor = math.floor
local format = string.format
local line = vim.fn.line
local nvim_feedkeys = vim.api.nvim_feedkeys
local nvim_replace_termcodes = vim.api.nvim_replace_termcodes
local reltimefloat = vim.fn.reltimefloat
local reltime = vim.fn.reltime
local quit_all = quitting.quit_all
local nmap, imap, vmap, tmap = mappers.nmap, mappers.imap,
                               mappers.vmap, mappers.tmap

-----------------------------------------------------------------
-- The Leader
-----------------------------------------------------------------
vim.g.mapleader = ','

-----------------------------------------------------------------
-- Navigation
-----------------------------------------------------------------
nmap['<C-H>'] = '<C-W>h'
nmap['<C-L>'] = '<C-W>l'
imap['<C-H>'] = '<ESC><C-W>h'
imap['<C-L>'] = '<ESC><C-W>l'
nmap['<C-J>'] = '<C-W>j'
nmap['<C-K>'] = '<C-W>k'
imap['<C-J>'] = '<ESC><C-W>j'
imap['<C-K>'] = '<ESC><C-W>k'

nmap['Q'] = quit_all

nmap['}'] = '$'
nmap['{'] = '^'

-- These are `back` and `forward` actions, analogous to web
-- browsing. However we swap them because <C-I> "should" repre-
-- sent `back` because it is to the left of the 'O' key and the
-- `back` button is always positioned to the left of the `for-
-- ward` button in a web browser.
nmap['<SPACE>9'] = '<C-O>'
nmap['<SPACE>0'] = '<C-I>'

-- These are now available.
nmap['<C-I>'] = '^'
nmap['<C-O>'] = '$'

-- Use Shift-t to open the current buffer in a new tab.
nmap['T'] = ':tabnew %<CR>'

nmap['E'] = tabs.close_current_tab

-- Moving tabs.
nmap['<C-f>'] = ':tabp<CR>'
nmap['<C-g>'] = ':tabn<CR>'
imap['<C-f>'] = '<ESC>:tabp<CR>i'
imap['<C-g>'] = '<ESC>:tabn<CR>i'

-----------------------------------------------------------------
-- Auto formatting.
-----------------------------------------------------------------
-- The double <CR> is to deal with the 'Press enter to continue'
-- prompt.
vmap['<Leader>f'] = ':!sfmt 65<CR><CR>'

-----------------------------------------------------------------
-- Editing
-----------------------------------------------------------------
nmap['\\'] = 'i <ESC>l'
nmap['('] = 'O<ESC>j'
nmap['<SPACE>'] = 'r l'

-----------------------------------------------------------------
-- Feeding keys.
-----------------------------------------------------------------
function M.replace_termcodes( keys )
  return nvim_replace_termcodes( keys, true, false, true )
end

function M.feedkeys( keys )
  nvim_feedkeys( M.replace_termcodes( keys ), 'n', true )
end

-----------------------------------------------------------------
-- Scrolling.
-----------------------------------------------------------------
-- This function changes the standard `z.` so that if it is
-- pressed multiple times within one second then the first time
-- it is pressed it will move the current line to the center of
-- the screen as usual, but the second time it will move the cur-
-- rent line up half way to the top, then half way again, expo-
-- nentially approaching the top. However, a press of z. more
-- than one seconds after the last one still perform the standard
-- behavior of moving to the center line.
local zee_dot_info = {
  last_hit=nil,
  frac=nil,

  reset=function( self )
    self.last_hit = reltime()
    self.frac = 2
  end,
}

zee_dot_info:reset()

local function zee_dot()
  local z = zee_dot_info
  -- This gets the time since the value of zee_dot_timer in some
  -- kind of strange internal vim representation that we can't
  -- really work with directly until we convert it to a float.
  local time_since_last = reltime( z.last_hit )
  -- This will be e.g. 1.23 for 1.23 seconds.
  local seconds = reltimefloat( time_since_last )
  z.last_hit = reltime()
  if seconds > 1.0 then z:reset() end
  local target = floor( (line( 'w$' ) - line( 'w0' )) / z.frac )
  z.frac = z.frac * 2
  local curr = line( '.' ) - line( 'w0' )
  if curr == target then return end
  local keys
  if curr > target then
    keys = format( '%d<c-e>', curr - target )
  else
    keys = format( '%d<c-y>', target - curr )
  end
  M.feedkeys( keys )
end

nmap['z.'] = zee_dot

-----------------------------------------------------------------
-- Searching/Replacing.
-----------------------------------------------------------------
-- This is non-trivial because we want the enter key to do dif-
-- ferent things depending on whether we are editing a normal
-- file (in which case it removes search highlights without
-- moving the cursor), or if we're in e.g. the quickfix window
-- (in which case we want it to select the thing under the
-- curosr).
nmap['<CR>'] = function()
  local wintype = vim.fn.win_gettype()
  -- wintype will be empty if we are editing a normal buffer.
  if #wintype == 0 then
    vim.cmd[[noh]]
    return
  end
  -- We are e.g. in the quickfix window, in which case we just
  -- want to actually hit enter to select the item under the cur-
  -- sor. This was surprisingly tricky to get right.
  vim.cmd.execute( [["normal! \<CR>"]] )
end

-- Highlight all instances of word under cursor but without auto-
-- matically jumping to the next instance.
function M.highlight_no_move()
  -- Basically does this:
  --   :let @/ = '\V\<some_keyword\>'
  --   :set hls
  -- Use :h \V for info on what \V means.
  local prefix = [[let @/ = '\V\<]]
  local search = expand( '<cword>' )
  local suffix = [[\>']]
  local highlight_cmd = prefix .. search .. suffix
  cmd( highlight_cmd )
  cmd( 'set hls' )
end

-- These are actually overridden with values in nvim-hlslens.lua.
nmap['*'] = function()
  M.highlight_no_move()
  vim.v.searchforward = 1
end

nmap['#'] = function()
  M.highlight_no_move()
  vim.v.searchforward = 0
end

-- Saves a bit of time by pre-populating the command used to re-
-- place the word under the cursor.
nmap['<leader>r'] = function()
  local w = expand( '<cword>' )
  if not w or w == '' then return end
  local keys = M.replace_termcodes(
                   ':%s/' .. w .. '//g' .. [[<Left><Left>]] )
  M.feedkeys( keys )
end

-----------------------------------------------------------------
-- Embedded terminal.
-----------------------------------------------------------------
-- This puts us back into normal mode in the terminal, which we
-- normally (no pun intended) can't get to from insert mode be-
-- cause all of the keys are sent to the terminal, even ESC.
tmap[ [[<C-space>]] ] = [[<C-\><C-N>]]

-----------------------------------------------------------------
-- Copy/Paste
-----------------------------------------------------------------
nmap['Y'] = 'y$'

-- When we either don't have clipboard support or vim can't ac-
-- cess the system clipboard then we will use these bindings to
-- simulate it using a temporary file. Note we don't support
-- deleting here, and also these only support entire lines as op-
-- posed to selections within a line.
--
-- Normally, when we do have clipboard access, the options module
-- will set the clipboard option to a value such that all normal
-- vim yanks/pastes/deletes will go to the clipboard. This then
-- allows copy/pasting not only across terminals, but across
-- servers, and thus the .vimbuf file is not needed. But, all
-- servers being used need to be logged into using -XY.
if vim.fn.has( 'clipboard' ) == 0 then
  -- Standard paste below cursor
  nmap['<Leader>p'] = ':r ~/.vimbuf<CR>'
  -- Standard paste above cursor
  nmap['<Leader>P'] = ':.-1r ~/.vimbuf<CR>'
  -- Yank into tmp file (will yank entire line always).
  vmap['<Leader>y'] = ':w! ~/.vimbuf<CR>'
end

-----------------------------------------------------------------
-- Finished.
-----------------------------------------------------------------
return M
