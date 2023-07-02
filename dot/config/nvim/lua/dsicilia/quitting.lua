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
local with_cmdheight = messages.with_cmdheight
local color_message = colors.color_message

-----------------------------------------------------------------
-- Implementation.
-----------------------------------------------------------------
local function print_modified_file_err( file_name )
  vim.cmd.messages( 'clear' )
  color_message( '{{WarningMsg}}error{{Normal}}:' ..
                     ' file {{Directory}}%s{{Normal}} is modified.',
                 file_name )
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
