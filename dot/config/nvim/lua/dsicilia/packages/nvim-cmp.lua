-----------------------------------------------------------------
-- Configuration for the nvim-cmp plugin.
-----------------------------------------------------------------
-- This plugin provides auto-completion, but needs to be provided
-- with sources.
local cmp     = require( 'cmp' )
local luasnip = require( 'luasnip' )

local select_opts = { behavior=cmp.SelectBehavior.Insert }

local function is_prev_char_a_space_or_nothing()
  local col = vim.fn.col( '.' ) - 1
  if col == 0 then return true end
  local char_before_cursor = vim.fn.getline( '.' ):sub( col, col )
  return char_before_cursor:match( '%s' )
end

local DEFAULT_CMP_LENGTH = 1

cmp.setup( {
  -- A snippet engine is required by nvim-cmp; some investigation
  -- into this suggests that sometimes (always?) completion re-
  -- sults are delivered as snippets that then require a snippet
  -- engine to deal with, but not 100% sure.
  snippet = {
    expand = function( args ) luasnip.lsp_expand( args.body ) end
  },

  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },

  experimental = {
    ghost_text = true
  },

  sources = cmp.config.sources(
    { -- Priority 1.
      { -- from cmp-path.
        name = 'path',
        keyword_length=DEFAULT_CMP_LENGTH,
      },
    },
    { -- Priority 2.
      { -- from cmp-nvim-lsp.
        name = 'nvim_lsp',
        keyword_length=DEFAULT_CMP_LENGTH,
      },
      { -- from cmp-nvim-lua.
        name = 'nvim_lua',
        keyword_length=DEFAULT_CMP_LENGTH,
      },
      -- We technically don't need this at the moment because we
      -- are not really creating snippets, and this populates
      -- auto-complete with snippet names that we've created, but
      -- it doesn't hurt to keep it enabled in case we do decide
      -- to create some in the future.
      { -- from cmp_luasnip.
        name = 'luasnip',
        keyword_length=DEFAULT_CMP_LENGTH,
      },
    },
    { -- Priority 3.
      { -- from cmp-buffer.
        name = 'buffer',
        keyword_length=DEFAULT_CMP_LENGTH,
      },
    }
  ),

  mapping = {
    ['<Up>']   = cmp.mapping.select_prev_item( select_opts ),
    ['<Down>'] = cmp.mapping.select_next_item( select_opts ),
    ['<C-u>']  = cmp.mapping.scroll_docs( -4 ),
    ['<C-d>']  = cmp.mapping.scroll_docs(  4 ),
    ['<CR>']   = cmp.mapping.confirm{ select = false },
    ['<C-e>']  = cmp.mapping.abort(),

    ['<Tab>'] = cmp.mapping( function( fallback )
      if cmp.visible() then
        cmp.select_next_item( select_opts )
        if #cmp.get_entries() == 1 then
          cmp.confirm{ select = true }
        end
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif is_prev_char_a_space_or_nothing() then
        -- Don't open the auto-complete menu because there is
        -- nothing to the left of the cursor to auto-complete. In
        -- that case, just do whatever the tab key normally does
        -- for the user.
        fallback()
      else
        cmp.complete()
      end
    end, {'i', 's'} ),

    ['<S-Tab>'] = cmp.mapping( function( fallback )
      if cmp.visible() then
        cmp.select_prev_item( select_opts )
      elseif luasnip.jumpable( -1 ) then
        luasnip.jump( -1 )
      else
        fallback()
      end
    end, {'i', 's'} ),
  },
} )

-- Use buffer source for `/` and `?`.
cmp.setup.cmdline( { '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' },
  }
} )

-- Use cmdline & path source for ':'.
cmp.setup.cmdline( ':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources(
    { -- Priority 1.
      {
        name = 'path',
        keyword_length=2
      }
    },
    { -- Priority 2.
      {
        name = 'cmdline',
        keyword_length=2
      }
    }
  )
} )
