-----------------------------------------------------------------
--                         Basic Keymaps
-----------------------------------------------------------------

-----------------------------------------------------------------
-- Imports
-----------------------------------------------------------------
local mappers = require( 'dsicilia.mappers' )
local tabs = require( 'dsicilia.tabs' )

-----------------------------------------------------------------
-- Aliases
-----------------------------------------------------------------
local nmap, imap, vmap = mappers.nmap, mappers.imap, mappers.vmap

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
vmap['<Leader>f'] = ':!sfmt 65<CR>'

-----------------------------------------------------------------
-- Editing
-----------------------------------------------------------------
nmap['\\'] = 'i <ESC>l'
nmap['('] = 'O<ESC>j'
nmap['<SPACE>'] = 'r l'

-----------------------------------------------------------------
-- Searching
-----------------------------------------------------------------
-- Two <CR>s to keep <CR> working with the quickfix list.
nmap['<CR>'] = ':noh<CR><CR>'

-- Type & to highlight all instances of word under cursor.
nmap['&'] = function()
  -- Basically does this:
  --   :let @/ = '\V\<some_keyword\>'
  --   :set hls
  -- Use :h \V for info on what \V means.
  local prefix = [[let @/ = '\V\<]]
  local search = vim.fn.expand( '<cword>' )
  local suffix = [[\>']]
  local highlight_cmd = prefix .. search .. suffix
  vim.cmd( highlight_cmd )
  vim.cmd( 'set hls' )
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
