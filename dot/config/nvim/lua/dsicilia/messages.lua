-----------------------------------------------------------------
-- Message box stuff.
-----------------------------------------------------------------
local M = {}

-----------------------------------------------------------------
-- Aliases.
-----------------------------------------------------------------
local timer_start = vim.fn.timer_start
local timer_stop = vim.fn.timer_stop

-----------------------------------------------------------------
-- Constants.
-----------------------------------------------------------------
local DELAY_MS = 10000 -- milliseconds.

-----------------------------------------------------------------
-- cmdheight management.
-----------------------------------------------------------------
local last_cmdheight_timer

-- This is a print function that runs an action but knows how to
-- temporarily adjust the cmdheight if necessary.
function M.with_cmdheight( func, ... )
  local function reset()
    last_cmdheight_timer = nil
    vim.o.cmdheight = 0
  end
  if last_cmdheight_timer then
    -- There is already a timer running, so stop this one before
    -- proceeding.
    timer_stop( last_cmdheight_timer )
    reset()
  end
  if vim.o.cmdheight == 0 then
    vim.o.cmdheight = 1
    last_cmdheight_timer = timer_start( DELAY_MS, reset )
  end
  func( ... )
end

-----------------------------------------------------------------
-- Finished.
-----------------------------------------------------------------
return M
