-- If this fails then that means that this is the first time we
-- are opening neovim in a new environment where the plugins have
-- never been loaded, and so we won't bother proceeding because
-- it will just lead to errors. Instead, we'll return here, at
-- which point packer will install the packages, then we can
-- restart neovim and we will be good to go.
if not pcall( require, 'telescope' ) then return end

-- This configs (typically, calling setup) on each plugin.
require 'dsicilia.packages'

-- In general, most other scripts that we need to run on load
-- require plugins to have been installed, so we launch those
-- from a script in the after/plugin folder.
require'dsicilia.autocmds'
require'dsicilia.colors'
require'dsicilia.dev'
require'dsicilia.folding'
require'dsicilia.format'
require'dsicilia.keymap'
require'dsicilia.lsp'
require'dsicilia.messages'
require'dsicilia.options'
require'dsicilia.resize'
require'dsicilia.rn'
require'dsicilia.search'
require'dsicilia.status-bar'
