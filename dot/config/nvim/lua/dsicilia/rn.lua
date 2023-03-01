-- This module ensures that when we are in the rn folder struc-
-- ture that we autoload any .vimrc files that we find there,
-- which are trusted. Specifically, any time we open neovim in a
-- subfolder of the "revolution-now" folder, it will load the
-- .vimrc from the root folder.
--
-- Background: Compared with Vim, Neovim uses the safer default
-- of not auto-loading a .vimrc in the current folder. This is
-- good as a general rule and we want to keep it. However, there
-- is an exception which is fairly safe.
local format = string.format

local cwd = vim.fn.getcwd()
local rn_start, rn_end = cwd:find( '.*revolution%-now' )
if rn_start then
  local rn = cwd:sub( rn_start, rn_end )
  vim.cmd( format( 'source %s/.vimrc', rn ) )
end