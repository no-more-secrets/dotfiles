-----------------------------------------------------------------
-- Things related to quitting nvim.
-----------------------------------------------------------------
local M = {}

-----------------------------------------------------------------
-- Imports.
-----------------------------------------------------------------
local colors = require( 'dsicilia.colors' )
local messages = require( 'dsicilia.messages' )

-----------------------------------------------------------------
-- Aliases.
-----------------------------------------------------------------
local echon_hi = colors.echon_hi
local with_cmdheight = messages.with_cmdheight

-----------------------------------------------------------------
-- Implementation.
-----------------------------------------------------------------
local function print_modified_file_err( file_name )
  vim.cmd.messages( 'clear' )
  -- This first blank echo is needed to work around a strange bug
  -- that happens in cmdheight=0 mode where occassionally, in
  -- this function, the first echo statement prints as all
  -- spaces.
  echon_hi( 'Normal', ' ' )
  echon_hi( 'WarningMsg', 'error' )
  echon_hi( 'Normal', ': file ' )
  echon_hi( 'Directory', file_name )
  echon_hi( 'Normal', ' is modified.' )
end

function M.quit_all()
  local bufs = vim.api.nvim_list_bufs()
  for _, buf in ipairs( bufs ) do
    if vim.api.nvim_buf_is_loaded( buf ) then
      if vim.bo[buf].modified then
        local path = vim.api.nvim_buf_get_name( buf )
        local name = vim.fn.fnamemodify( path, ':t' )
        vim.cmd.buffer( buf )
        with_cmdheight( print_modified_file_err, name )
        return
      end
    end
  end
  vim.cmd{ cmd='qa', bang=true }
end

-----------------------------------------------------------------
-- Finished.
-----------------------------------------------------------------
return M
