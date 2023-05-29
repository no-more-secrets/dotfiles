-----------------------------------------------------------------
--                            Tabs
-----------------------------------------------------------------
local M = {}

-- Use Shift-e to close the current tab. By default, if we are
-- closing a tab that is not the first or last, then vim will se-
-- lect the tab to the right after closing, which feels like the
-- wrong default, so we will select the one on the left.
function M.close_current_tab()
  local num_tabs = vim.call( 'tabpagenr', '$' )
  if num_tabs <= 1 then return end
  -- Starts at 1. Need to measure this before closing the tab.
  local old_tab = vim.call( 'tabpagenr' )
  vim.cmd[[tabclose]]
  if old_tab ~= 1 and old_tab ~= num_tabs then vim.cmd[[tabp]] end
end

return M
