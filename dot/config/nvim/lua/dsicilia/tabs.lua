-----------------------------------------------------------------
--                            Tabs
-----------------------------------------------------------------
local M = {}

-----------------------------------------------------------------
-- Aliases.
-----------------------------------------------------------------
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-----------------------------------------------------------------
-- Methods.
-----------------------------------------------------------------
-- Use Shift-e to close the current tab if it is not the last.
-- Note that this should cause our TabClosed autocmd to run below
-- which will take care of moving to the desired tab after the
-- current one is closed.
function M.close_current_tab()
  local num_tabs = vim.fn.tabpagenr( '$' )
  if num_tabs <= 1 then return end
  vim.cmd.tabclose()
end

local function try_change_to_tab_left( state )
  -- Strangely, there is a field in the argument called "file"
  -- that holds the 1-based location index of the tab page being
  -- closed in string form. There does not seem to be any other
  -- API for getting this number that gives the correct result
  -- while this function is running.
  local tabpagenr_being_closed = tonumber( state.file )
  if tabpagenr_being_closed == 1 then return end
  local n_tabs_after_close = #vim.api.nvim_list_tabpages()
  if tabpagenr_being_closed > n_tabs_after_close then return end
  vim.cmd.tabp()
end

-----------------------------------------------------------------
-- Autocommands.
-----------------------------------------------------------------
-- This should ensure that when a tab is closed through any means
-- that we end up on the desired tab afterwards. Vim's default,
-- which is not desirable, is to move to the tab to the right; we
-- want to move to the tab to the left, unless we are in the
-- first tab.
autocmd( 'TabClosed', {
  group=augroup( 'Tabs', { clear=true } ),
  callback=try_change_to_tab_left,
} )

return M
