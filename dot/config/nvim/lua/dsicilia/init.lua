-- Speeds up loading time by enabling the experimental Lua module
-- loader which removes the default Neovim loader and uses the
-- byte-compilation cache.
vim.loader.enable()

-- Should go first.
require'dsicilia.packages'

require'dsicilia.folding'
require'dsicilia.keymap'
require'dsicilia.lsp'
require'dsicilia.options'
require'dsicilia.rn'
require'dsicilia.status-bar'
require'dsicilia.colors'
require'dsicilia.format'
require'dsicilia.dev'
require'dsicilia.resize'

-- Temporary until migration is complete.
vim.cmd[[source ~/.vimrc]]
