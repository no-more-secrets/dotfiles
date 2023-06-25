-----------------------------------------------------------------
--                      Keys & Keymaps
-----------------------------------------------------------------
local M = {}

-----------------------------------------------------------------
-- Imports
-----------------------------------------------------------------
local mappers = require( 'dsicilia.mappers' )
local tabs = require( 'dsicilia.tabs' )

-----------------------------------------------------------------
-- Aliases
-----------------------------------------------------------------
local nmap, imap, vmap = mappers.nmap, mappers.imap, mappers.vmap
local expand = vim.fn.expand
local nvim_replace_termcodes = vim.api.nvim_replace_termcodes
local nvim_feedkeys = vim.api.nvim_feedkeys
local reltime = vim.fn.reltime
local reltimefloat = vim.fn.reltimefloat
local line = vim.fn.line
local format = string.format
local floor = math.floor

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

nmap['Q'] = ':qa<CR>'

nmap['}'] = '$'
nmap['{'] = '^'

-- "Press" the unmapped version of a key in normal mode.
local function norm_unmapped( c )
  return vim.cmd{ cmd='norm', args={ c }, bang=true }
end

-- When searching for something that yields no results, vim nor-
-- mally sends an error message to the message box, which causes
-- issues when cmdheight=0, since then it asks to press enter.
-- These will effectively silence that until the issue has a
-- better workaround. See: github.com/neovim/neovim/issues/24059
nmap['n'] = function() pcall( norm_unmapped, 'n' ) end
nmap['N'] = function() pcall( norm_unmapped, 'N' ) end
-- FIXME: technically we also need this, but this has the disad-
-- vantage that we no longer get Neovim's live highlighting as we
-- type the search characters.
-- vim.cmd[[nnoremap / :silent! /]]

-- These are `back` and `forward` actions, analogous to web
-- browsing. However we swap them because <C-I> "should" repre-
-- sent `back` because it is to the left of the 'O' key and the
-- `back` button is always positioned to the left of the `for-
-- ward` button in a web browser.
nmap['<SPACE>9'] = '<C-O>'
nmap['<SPACE>0'] = '<C-I>'

-- These are now available.
-- nmap['<C-I>'] = ???
-- nmap['<C-O>'] = ???

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
-- Two <CR>s to keep <CR> working with the quickfix list.
nmap['<CR>'] = ':noh<CR><CR>'

-- Type & to highlight all instances of word under cursor.
function M.ampersand()
  -- Basically does this:
  --   :let @/ = '\V\<some_keyword\>'
  --   :set hls
  -- Use :h \V for info on what \V means.
  local prefix = [[let @/ = '\V\<]]
  local search = expand( '<cword>' )
  local suffix = [[\>']]
  local highlight_cmd = prefix .. search .. suffix
  vim.cmd( highlight_cmd )
  vim.cmd( 'set hls' )
end

nmap['&'] = M.ampersand

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
-- Copy/Paste
-----------------------------------------------------------------
nmap['Y'] = 'y$'

-- When we either don't have clipboard support or vim can't ac-
-- cess the system clipboard then we will use these bindings to
-- simulate it using a temporary file. Note we don't support
-- deleting here, and also these only support entire lines as op-
-- posed to selections within a line.

-- Standard paste below cursor
nmap['<Leader>p'] = ':r ~/.vimbuf<CR>'
-- Standard paste above cursor
nmap['<Leader>P'] = ':.-1r ~/.vimbuf<CR>'
-- Yank into tmp file (will yank entire line always).
vmap['<Leader>y'] = ':w! ~/.vimbuf<CR>'
nmap['<Leader>yy'] = 'V<Leader>y'

-----------------------------------------------------------------
-- Finished.
-----------------------------------------------------------------
return M
