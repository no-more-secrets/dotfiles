-----------------------------------------------------------------
-- Package: lazygit.nvim.
-----------------------------------------------------------------
local M = {}

-----------------------------------------------------------------
-- Imports.
-----------------------------------------------------------------
local mappers = require( 'dsicilia.mappers' )

-----------------------------------------------------------------
-- Aliases.
-----------------------------------------------------------------
local nmap = mappers.nmap

-----------------------------------------------------------------
-- Implementation.
-----------------------------------------------------------------
-- Start a floating window with lazygit in the project root of
-- the current file.
nmap['glg'] = vim.cmd.LazyGitCurrentFile
-- Start a floating window with lazygit in the current working
-- directory.
nmap['glG'] = vim.cmd.LazyGit

-- Open project commits with lazygit directly from vim in
-- floating window.
nmap['glc'] = vim.cmd.LazyGitFilter
-- Open buffer commits with lazygit directly from vim in floating
-- window. FIXME: does not seem to work.
nmap['glC'] = vim.cmd.LazyGitFilterCurrentFile

vim.g.lazygit_floating_window_use_plenary = 0

-----------------------------------------------------------------
-- Finished.
-----------------------------------------------------------------
return M
