-----------------------------------------------------------------
-- Imports.
-----------------------------------------------------------------
local lspconfig = require( 'lspconfig' )

-----------------------------------------------------------------
-- Setup.
-----------------------------------------------------------------
local autocomplete_capabilities =
    require( 'cmp_nvim_lsp' ).default_capabilities()

if vim.fn.executable( 'lua-language-server' ) == 0 then return end

lspconfig.lua_ls.setup{
  cmd={ 'lua-language-server' },
  capabilities=autocomplete_capabilities,
  settings={
    -- See the settings.lua file in the lua-language-server
    -- package for all of the settings.
    Lua={
      runtime={
        -- Tell the language server which version of Lua you're
        -- using (most likely LuaJIT in the case of Neovim).
        version='5.4.3',
      },
      diagnostics={
        -- Get the language server to recognize the `vim` global.
        globals={ 'vim' },
      },
      workspace={
        -- Make the server aware of Neovim runtime files.
        library=vim.api.nvim_get_runtime_file( '', true ),
        -- Don't try to auto-detect third-party libraries. This
        -- suppresses an annoying message.
        checkThirdParty=false,
      },
      -- Do not send telemetry data containing a randomized but
      -- unique identifier.
      telemetry={ enable=false },
    },
  },
}
