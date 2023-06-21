-----------------------------------------------------------------
-- Miscellaneous auto-commands.
-----------------------------------------------------------------
local M = {}

-----------------------------------------------------------------
-- Imports.
-----------------------------------------------------------------

-----------------------------------------------------------------
-- Aliases.
-----------------------------------------------------------------
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local line = vim.fn.line

-----------------------------------------------------------------
-- Return to last cursor pos.
-----------------------------------------------------------------
-- Return to last edit position when opening files and make that
-- line in the center of the screen.
local function restore_cursor()
  local last_pos = line[['"]]
  if last_pos == 0 or last_pos > line( '$' ) then return end
  vim.schedule( function() vim.cmd[[normal! g`"z.]] end )
end

autocmd( 'BufReadPost', {
  group=augroup( 'RestoreCursor', { clear=true } ),
  callback=restore_cursor,
} )

-----------------------------------------------------------------
-- Finished.
-----------------------------------------------------------------
return M
