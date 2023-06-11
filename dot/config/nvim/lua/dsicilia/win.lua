-----------------------------------------------------------------
-- Things related to vim windows.
-----------------------------------------------------------------
local M = {}

function M.close_all_floating_windows()
  local n_closed = 0
  for _, win_id in ipairs( vim.api.nvim_list_wins() ) do
    -- Test if window is floating.
    if vim.api.nvim_win_get_config( win_id ).relative ~= '' then
      -- Force close if called with !
      vim.api.nvim_win_close( win_id, {} )
      n_closed = n_closed + 1
    end
  end
  return n_closed
end

-----------------------------------------------------------------
-- Finished.
-----------------------------------------------------------------
return M
