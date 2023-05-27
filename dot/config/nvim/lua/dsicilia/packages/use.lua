-----------------------------------------------------------------
-- packer.nvim package setup.
-----------------------------------------------------------------

-----------------------------------------------------------------
-- Bootstrap.
-----------------------------------------------------------------
-- Bootstrapping needs to go before packer.nvim startup.
local bootstrap = require( 'dsicilia.packages.bootstrap' )
local bootstrapping = bootstrap.ensure_packer()

-----------------------------------------------------------------
-- Setup.
-----------------------------------------------------------------
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

  -- Auto-commenter plugin.
  use {
    'numToStr/Comment.nvim',
    config = function()
      require( 'dsicilia.packages.comments' )
    end
  }

  -- Improved lua syntax highlighting.
  use 'tbastos/vim-lua'

  -- Modern C++ syntax highlighting. Note that this won't really
  -- be used when clangd or tree-sitter are providing semantic
  -- highlighting. It's mainly for when we are viewing a cpp file
  -- and don't have clangd running.
  use {
    'bfrg/vim-cpp-modern',
    config = function()
      require( 'dsicilia.packages.vim-cpp-modern' )
    end
  }

  --if vim.fn.executable( 'tree-sitter' ) == 1 then
  use {
    'nvim-treesitter/nvim-treesitter',
    config = function()
      require( 'dsicilia.packages.tree-sitter' )
    end
  }
  --end

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

  -- fuzzy searching.
  -- use 'junegunn/fzf'

  -- vim plugin for fzf.
  -- use 'junegunn/fzf.vim'

  ------------------------------------
  -- Needed?

  -- Should go last.
  if bootstrapping then require( 'packer' ).sync() end
end )
