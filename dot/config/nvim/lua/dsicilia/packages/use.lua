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
    use{
      'mbbill/undotree',
      config=function()
        require( 'dsicilia.packages.undotree' )
      end,
    }

    -- Neovim version of EasyMotion.
    use{
      'phaazon/hop.nvim',
      branch='v2',
      config=function() require( 'dsicilia.packages.hop' ) end,
    }

    -- Color scheme.
    use{
      'ellisonleao/gruvbox.nvim',
      -- TODO: update to latest version which breaks us.
      commit='df149bccb19a02c5c2b9fa6ec0716f0c0487feb0',
      config=function()
        require( 'dsicilia.packages.gruvbox-nvim' )
      end,
    }

    -- Expand selected region.
    use'terryma/vim-expand-region'

    -- Syntax file for OpenGL shaders..
    use'tikhomirov/vim-glsl'

    -- Configs for language servers.
    use{
      'neovim/nvim-lspconfig',
      config=function()
        require( 'dsicilia.packages.nvim-lspconfig' )
      end,
    }

    -- Auto-commenter plugin.
    use{
      'numToStr/Comment.nvim',
      config=function()
        require( 'dsicilia.packages.comments' )
      end,
    }

    use{
      'nvim-treesitter/nvim-treesitter',
      config=function()
        require( 'dsicilia.packages.nvim-treesitter' )
      end,
    }

    use{
      'nvim-treesitter/playground',
      config=function()
        require( 'dsicilia.packages.ts-playground' )
      end,
    }

    -- Auto-completion Engine.
    use{
      'hrsh7th/nvim-cmp',
      config=function()
        require( 'dsicilia.packages.nvim-cmp' )
      end,
      requires={ 'L3MON4D3/LuaSnip' },
    }

    -- Auto-completion sources.
    use'hrsh7th/cmp-buffer' -- Source from current buffer.
    use'hrsh7th/cmp-path' -- Source for file paths.
    use'hrsh7th/cmp-cmdline' -- Source for vim : commands.
    use'hrsh7th/cmp-nvim-lua' -- Source for nvim lua api functions.
    use'saadparwaiz1/cmp_luasnip' -- Source from list of snippets.
    use'hrsh7th/cmp-nvim-lsp' -- Source from Neovim LSP.

    -- Snippet engine.
    use{
      'L3MON4D3/LuaSnip',
      config=function()
        require( 'dsicilia.packages.lua-snip' )
      end,
    }

    -- Telescope fuzzy finder.
    use{
      'nvim-telescope/telescope.nvim',
      branch='0.1.x',
      config=function()
        require( 'dsicilia.packages.telescope' )
      end,
      requires={
        { 'nvim-lua/plenary.nvim' },
        { 'nvim-telescope/telescope-fzf-native.nvim', run='make' },
      },
    }

    use{
      'nvim-tree/nvim-tree.lua',
      config=function()
        require( 'dsicilia.packages.nvim-tree' )
      end,
    }

    use'sbdchd/neoformat'

    use{
      'lewis6991/gitsigns.nvim',
      config=function()
        require( 'dsicilia.packages.gitsigns-nvim' )
      end,
    }

    -- Document tree outline in right side bar.
    use{
      'stevearc/aerial.nvim',
      config=function()
        require( 'dsicilia.packages.aerial-nvim' )
      end,
    }

    use{
      'kdheepak/lazygit.nvim',
      config=function()
        require( 'dsicilia.packages.lazygit' )
      end,
      requires={ 'nvim-lua/plenary.nvim' },
    }

    use{
      'petertriho/nvim-scrollbar',
      config=function()
        require( 'dsicilia.packages.nvim-scrollbar' )
      end,
      requires={
        {
          'kevinhwang91/nvim-hlslens',
          config=function()
            require( 'dsicilia.packages.nvim-hlslens' )
          end,
        },
      },
    }

    -- Upon opening a new buffer, guess-indent looks at the first
    -- few hundred lines and uses them to determine how the
    -- buffer should be indented. It then automatically updates
    -- the buffer options so that they match the opened file.
    use{
      'NMAC427/guess-indent.nvim',
      config=function() require( 'guess-indent' ).setup{} end,
    }

    -- Auto-detects binary files and opens them in "hex mode"
    -- using xxd. Supports reading/editing/writing, though sub-
    -- ject to the limitations of `xxd -r`.
    use{
      'RaafatTurki/hex.nvim',
      config=function()
        require( 'dsicilia.packages.hex-nvim' )
      end,
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
