-----------------------------------------------------------------
-- Package: nvim-tree
-----------------------------------------------------------------
local M = {}

-----------------------------------------------------------------
-- Imports.
-----------------------------------------------------------------
local mappers = require( 'dsicilia.mappers' )

-----------------------------------------------------------------
-- Aliases.
-----------------------------------------------------------------
local nmap = mappers.nmap

-----------------------------------------------------------------
-- Setup.
-----------------------------------------------------------------
local function on_attach( bufnr )
  local api = require( 'nvim-tree.api' )

  local function opts( desc )
    return {
      desc='nvim-tree: ' .. desc,
      buffer=bufnr,
      noremap=true,
      silent=true,
      nowait=true,
    }
  end

  -- default mappings
  api.config.mappings.default_on_attach( bufnr )

  -- custom mappings
  vim.keymap.set( 'n', '<leader>w', api.tree.close,
                  opts( 'Close' ) )
end

require( 'nvim-tree' ).setup{
  view={ width=30 },

  renderer={ group_empty=true },

  filters={ dotfiles=true },

  on_attach=on_attach,

  -- Nvim-tree supports an interactive "window picker" which al-
  -- lows the user to select a window relative to which a file
  -- gets opened in e.g. a vertical split or horizontal split,
  -- i.e. in those cases where it would be ambiguous where a file
  -- should be opened. However, we just disable that here which
  -- causes nvim-tree to just use the last window that you were
  -- on before jumping to the tree window as the reference from
  -- which to open new files. Note that this is not relevant when
  -- e.g. opening a file in a new tab, because there is no ambi-
  -- guity there about where the file goes.
  actions={ open_file={ window_picker={ enable=false } } },
}

-----------------------------------------------------------------
-- Keymaps.
-----------------------------------------------------------------
nmap['<leader>w'] = function()
  local api = require( 'nvim-tree.api' )
  if api.tree.is_visible() then
    vim.cmd.NvimTreeFocus()
  else
    vim.cmd.NvimTreeOpen()
  end
end

nmap['<leader>W'] = vim.cmd.NvimTreeFindFile

-----------------------------------------------------------------
-- Finished.
-----------------------------------------------------------------
return M
