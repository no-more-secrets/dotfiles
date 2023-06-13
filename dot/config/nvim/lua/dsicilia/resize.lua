-----------------------------------------------------------------
-- Terminal resizing.
-----------------------------------------------------------------
local M = {}

-----------------------------------------------------------------
-- Aliases
-----------------------------------------------------------------
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-----------------------------------------------------------------
-- Window splits.
-----------------------------------------------------------------
-- Re-proportion window splits on all tabs when terminal is re-
-- sized.
local function reproportion_window_splits()
  local old_tab = vim.api.nvim_get_current_tabpage()
  vim.cmd[[tabdo wincmd =]]
  -- The above command will have left us on the last tab page, so
  -- restore the tab that we were on.
  vim.api.nvim_set_current_tabpage( old_tab )
end

-----------------------------------------------------------------
-- NvimTree sizing..
-----------------------------------------------------------------
local function is_terminal_small()
  return vim.o.columns < 300
end

function M.calc_nvim_tree_width()
  if is_terminal_small() then
    return 30
  else
    return 40
  end
end

local function reproportion_nvim_tree_window()
  vim.cmd.NvimTreeResize( M.calc_nvim_tree_width() )
end

-----------------------------------------------------------------
-- Autocommands.
-----------------------------------------------------------------
local function on_resize()
  -- List of things that need to be done when the vim window re-
  -- sizes.
  reproportion_window_splits()
  reproportion_nvim_tree_window()
end

local group = augroup( 'WindowResizing', { clear=true } )

autocmd( 'VimResized', { group=group, callback=on_resize } )

-----------------------------------------------------------------
-- Finished.
-----------------------------------------------------------------
return M
