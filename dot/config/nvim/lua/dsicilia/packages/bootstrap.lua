-----------------------------------------------------------------
-- Bootstrap Neovim package manager plugin.
-----------------------------------------------------------------
-- This is for first-time use of neovim in a new environment.
local M = {}

-----------------------------------------------------------------
-- Imports.
-----------------------------------------------------------------
local system = require 'dsicilia.system'

-----------------------------------------------------------------
-- Aliases.
-----------------------------------------------------------------
local github_clone = system.github_clone
local glob = vim.fn.glob
local empty = vim.fn.empty

-----------------------------------------------------------------
-- Constants.
-----------------------------------------------------------------
local INSTALL_PATH = vim.fn.stdpath( 'data' ) ..
    '/site/pack/packer/start/packer.nvim'

-----------------------------------------------------------------
-- Functions.
-----------------------------------------------------------------
function M.ensure_packer()
  -- Is it already installed?
  if empty( glob( INSTALL_PATH ) ) == 0 then return false end
  github_clone( 'wbthomason', 'packer.nvim', INSTALL_PATH,
                '--depth=1' )
  vim.cmd.packadd( 'packer.nvim' )
  return true
end

-----------------------------------------------------------------
-- Finished.
-----------------------------------------------------------------
return M
