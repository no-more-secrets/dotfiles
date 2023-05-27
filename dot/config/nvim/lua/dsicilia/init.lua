-- Should go first.
require 'dsicilia.packages'

require 'dsicilia.folding'
require 'dsicilia.keymap'
require 'dsicilia.lsp'
require 'dsicilia.options'
require 'dsicilia.rn'
require 'dsicilia.status-bar'

-- Temporary until migration is complete.
vim.cmd[[source ~/.vimrc]]
