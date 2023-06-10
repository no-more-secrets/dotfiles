-----------------------------------------------------------------
-- Terminal resizing.
-----------------------------------------------------------------

-----------------------------------------------------------------
-- Aliases
-----------------------------------------------------------------
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-----------------------------------------------------------------
-- Functions.
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

local function on_resize()
  -- List of things that need to be done when the vim window re-
  -- sizes.
  reproportion_window_splits()
end

-----------------------------------------------------------------
-- Autocommands.
-----------------------------------------------------------------
local group = augroup( 'WindowResizing', { clear=true } )

autocmd( 'VimResized', { group=group, callback=on_resize } )
