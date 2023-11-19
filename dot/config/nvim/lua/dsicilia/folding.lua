-----------------------------------------------------------------
--                           Folding
-----------------------------------------------------------------
-- TODO
local M = {}

-----------------------------------------------------------------
-- Imports
-----------------------------------------------------------------
local mappers = require( 'dsicilia.mappers' )
local colors = require( 'dsicilia.colors' )

-----------------------------------------------------------------
-- Aliases
-----------------------------------------------------------------
local nmap = mappers.nmap

-----------------------------------------------------------------
--                           Aliases
-----------------------------------------------------------------
local getline = vim.fn.getline
local getfsize = vim.fn.getfsize
local format = string.format

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local buf_get_name = vim.api.nvim_buf_get_name

-----------------------------------------------------------------
-- Constants.
-----------------------------------------------------------------
local MAX_FOLD_LENGTH = 65

-----------------------------------------------------------------
--                           Options
-----------------------------------------------------------------
vim.o.foldenable = true

-----------------------------------------------------------------
--                       Autocommands
-----------------------------------------------------------------
-- This is to prevent treesitter-based folding on large files
-- since it causes massive slowdowns in buffer load time.
autocmd( 'BufReadPre', {
  group=augroup( 'EnableFolding', { clear=true } ),
  callback=function( ev )
    local fname = assert( buf_get_name( assert( ev.buf ) ) )
    local size = assert( getfsize( fname ) )
    if size > 1024 * 1024 then
      -- Simpler (non-treesitter) folding method if file is too
      -- big. Treesitter folding is way to slow on large files
      -- and makes startup time balloon to minutes.
      vim.wo.foldmethod = 'indent'
      -- Don't initially fold anything.
      vim.wo.foldlevel = 99
      print( 'folding disabled for large file.' )
    else
      -- Fold based on the syntax of the language in question.
      vim.wo.foldmethod = 'expr'
      -- Don't initially fold anything.
      vim.wo.foldlevel = 99
      vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    end
  end,
} )

-- Update folds so that it will be possible to immediately start
-- folding text without having to edit. This could potentially be
-- due to a bug in nvim-treesitter, which we're using as a
-- folding mechanism. See:
--
--   https://github.com/nvim-treesitter/nvim-treesitter/issues/1337
--
autocmd( 'BufWinEnter', {
  group=augroup( 'FixFolds', { clear=true } ),
  callback=function() vim.cmd[[normal! zx]] end,
} )

-----------------------------------------------------------------
-- Key bindings.
-----------------------------------------------------------------
-- Toggle fold under cursor.
nmap['Z'] = 'za'

-- Close all folds except those minimal set that are needed to
-- reveal the current line. This works by setting a mark, closing
-- all folds, then returning to that mark, then putting it at the
-- center of the screen. This replaces the normal zv which seems
-- to do something similar but is not quite what we want since it
-- doesn't close all the other folds.
nmap['zv'] = 'mzzMzv`zz.'

-----------------------------------------------------------------
-- Colors.
-----------------------------------------------------------------
colors.hl_setter( 'Folding', function( hi )
  -- Must be require'd after plugins are loaded.
  local C =
      require( 'gruvbox.palette' ).get_base_colors( 'dark' )
  -- This is so that we don't see an ugly horizontal bar when
  -- code is folded.
  hi.Folded = { fg=C.fg4, bg=C.bg0 }
end )

-----------------------------------------------------------------
-- Foldtext.
-----------------------------------------------------------------
-- The 'foldtext' option is an option that takes a string con-
-- taining a vimscript expression that is then executed to yield
-- another string that will be the fold line string. So we need a
-- vimscript expression that runs our lua function above each
-- time it is evaluated.
vim.o.foldtext = [[
  luaeval( 'require( "dsicilia.folding" ).fold_text_gen()' )
]]

function M.fold_text_gen()
  local linetext = getline( vim.v.foldstart )
  local rm_if_last_char = function( char )
    local last_char = linetext:sub( #linetext )
    if last_char ~= char then return end
    linetext = linetext:sub( 1, #linetext - 1 )
  end
  -- If the line ends with a { then strip it off since we'll be
  -- adding one manually in the fold line text below. Then, if
  -- the line ends with a space then strip it off (it might since
  -- we just stripped a curly brace).
  rm_if_last_char( '{' )
  rm_if_last_char( ' ' )
  local num_lines_folded = vim.v.foldend - vim.v.foldstart
  local FMT = '%s { --- %d lines folded --- }'
  -- If necessary, trim some more from the end of linetext so
  -- that the entire formatted fold string fits into our desired
  -- line width.
  do
    local longest = format( FMT, linetext, num_lines_folded )
    local extra_chars = #longest - MAX_FOLD_LENGTH
    if extra_chars > 0 then
      linetext = linetext:sub( 1, #linetext - extra_chars )
    end
  end
  return format( FMT, linetext, num_lines_folded )
end

-----------------------------------------------------------------
-- Finished.
-----------------------------------------------------------------
return M
