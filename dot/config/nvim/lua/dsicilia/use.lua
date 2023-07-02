-----------------------------------------------------------------
-- packer.nvim package setup.
-----------------------------------------------------------------
-----------------------------------------------------------------
-- Aliases.
-----------------------------------------------------------------
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-----------------------------------------------------------------
-- Bootstrap.
-----------------------------------------------------------------
-- Bootstrapping needs to go before packer.nvim startup.
local bootstrap = require( 'dsicilia.packages.bootstrap' )
local bootstrapping = bootstrap.ensure_packer()

-----------------------------------------------------------------
-- Auto-reload.
-----------------------------------------------------------------
-- Run PackerSync each time this file is changed. However, if it
-- is changed via an update from version control then PackerSync
-- will still have to be run manually.
autocmd( 'BufWritePost', {
  pattern='use.lua',
  group=augroup( 'PackerAutoReload', { clear=true } ),
  callback=function()
    vim.cmd.source( vim.fn.expand( '<afile>' ) )
    vim.cmd.PackerSync()
  end,
} )

-----------------------------------------------------------------
-- Setup.
-----------------------------------------------------------------
-- BEWARE: packer precompiles the code inside the config function
-- objects, so they cannot use any upvalues of any kind. They can
-- only reference globals.
return require( 'packer' ).startup( {
  function( use )
    use'wbthomason/packer.nvim'

    -- Undo tree.
    use'mbbill/undotree'

    -- Neovim version of EasyMotion.
    use{ 'phaazon/hop.nvim', branch='v2' }

    -- Color scheme.
    use'ellisonleao/gruvbox.nvim'

    -- Expand selected region.
    use'terryma/vim-expand-region'

    -- Syntax file for OpenGL shaders..
    use'tikhomirov/vim-glsl'

    -- Configs for language servers.
    use'neovim/nvim-lspconfig'

    -- Auto-commenter plugin.
    use'numToStr/Comment.nvim'

    use'nvim-treesitter/nvim-treesitter'

    -- Auto-completion Engine.
    use'hrsh7th/nvim-cmp'

    -- Auto-completion sources.
    use'hrsh7th/cmp-buffer' -- Source from current buffer.
    use'hrsh7th/cmp-path' -- Source for file paths.
    use'hrsh7th/cmp-cmdline' -- Source for vim : commands.
    use'hrsh7th/cmp-nvim-lua' -- Source for nvim lua api functions.
    use'saadparwaiz1/cmp_luasnip' -- Source from list of snippets.
    use'hrsh7th/cmp-nvim-lsp' -- Source from Neovim LSP.

    -- Snippet engine.
    use'L3MON4D3/LuaSnip'

    -- Telescope fuzzy finder.
    use{
      'nvim-telescope/telescope.nvim',
      branch='0.1.x',
      requires={
        { 'nvim-lua/plenary.nvim' },
        { 'nvim-telescope/telescope-fzf-native.nvim', run='make' },
      },
    }

    use'nvim-tree/nvim-tree.lua'

    use'sbdchd/neoformat'

    use'lewis6991/gitsigns.nvim'

    -- Document tree outline in right side bar.
    use'stevearc/aerial.nvim'

    use{
      'kdheepak/lazygit.nvim',
      requires={ 'nvim-lua/plenary.nvim' },
    }

    use{
      'petertriho/nvim-scrollbar',
      requires={ 'kevinhwang91/nvim-hlslens' },
    }

    -- Should go last.
    if bootstrapping then require( 'packer' ).sync() end
  end,
  config={
    display={
      -- Have packer use a floating window when it opens one.
      open_fn=require( 'packer.util' ).float,
    },
  },
} )
