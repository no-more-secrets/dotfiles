-----------------------------------------------------------------
-- packer.nvim package setup.
-----------------------------------------------------------------
-- Bootstrapping needs to go first.
local bootstrap = require( 'dsicilia.packages.bootstrap' )

local bootstrapping = bootstrap.ensure_packer()

return require( 'packer' ).startup( function( use )
  use 'wbthomason/packer.nvim'

  -- Undo tree.
  use {
    'mbbill/undotree',
    config = function()
      require( 'dsicilia.packages.undotree' )
    end
  }

  -- Color scheme.
  use {
    'morhetz/gruvbox',
    config = function()
      vim.cmd[[set background=dark]]
      vim.cmd.colorscheme( 'gruvbox' )
    end
  }

  -- Expand selected region.
  use 'terryma/vim-expand-region'

  -- File templates with placeholders.
  use 'tibabit/vim-templates'

  -- Syntax file for OpenGL shaders..
  use 'tikhomirov/vim-glsl'

  -- Configs for language servers..
  use {
    'neovim/nvim-lspconfig',
    config = function()
      require( 'dsicilia.packages.nvim-lspconfig' )
      require( 'dsicilia.lsp-servers' )
    end
  }

  -- Auto-completion Engine.
  use {
    'hrsh7th/nvim-cmp',
    requires = { 'L3MON4D3/LuaSnip' },
    config = function()
      require( 'dsicilia.packages.nvim-cmp' )
    end
  }

  -- Auto-completion sources.
  use 'hrsh7th/cmp-buffer'       -- Source from current buffer.
  use 'hrsh7th/cmp-path'         -- Source for file paths.
  use 'hrsh7th/cmp-cmdline'      -- Source for vim : commands.
  use 'hrsh7th/cmp-nvim-lua'     -- Source for nvim lua api functions.
  use 'saadparwaiz1/cmp_luasnip' -- Source from list of snippets.
  use 'hrsh7th/cmp-nvim-lsp'     -- Source from Neovim LSP.

  -- Snippet engine.
  use 'L3MON4D3/LuaSnip'

  ------------------------------------
  -- To be replaced:

  -- Web-browser-like navigation overlays.
  -- use 'easymotion/vim-easymotion'

  -- Auto comment manipulation.
  -- use 'scrooloose/nerdcommenter'

  -- fuzzy searching.
  -- use 'junegunn/fzf'

  -- vim plugin for fzf.
  -- use 'junegunn/fzf.vim'

  ------------------------------------
  -- Needed?

  -- Improved lua syntax highlighting.
  use 'tbastos/vim-lua'

  -- Modern C++ syntax highlighting.
  -- use 'bfrg/vim-cpp-modern'

  -- Should go last.
  if bootstrapping then require( 'packer' ).sync() end
end )
