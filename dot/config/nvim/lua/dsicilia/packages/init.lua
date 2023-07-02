require 'dsicilia.packages.aerial-nvim'
require 'dsicilia.packages.comments'
require 'dsicilia.packages.gitsigns-nvim'
require 'dsicilia.packages.gruvbox-nvim'
require 'dsicilia.packages.hop'
require 'dsicilia.packages.lazygit'
require 'dsicilia.packages.lua-snip'
require 'dsicilia.packages.nvim-cmp'
require 'dsicilia.packages.nvim-hlslens'
require 'dsicilia.packages.nvim-lspconfig'
require 'dsicilia.packages.nvim-scrollbar'
require 'dsicilia.packages.nvim-tree'
require 'dsicilia.packages.nvim-treesitter'
require 'dsicilia.packages.telescope'
require 'dsicilia.packages.undotree'

-- Note that we don't require the individual package config mod-
-- ules here; we do that after the plugins are loaded via a com-
-- mand in the after/plugin folder. This is because some of the
-- config modules require either other plugins to already be con-
-- figured or require library modules that depend on other plug-
-- ins.
