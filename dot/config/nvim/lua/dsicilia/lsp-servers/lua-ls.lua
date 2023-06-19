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
        -- NOTE: it is better to put a .luarc.json in the root of
        -- the Lua workspace, that way lua-language-server will
        -- spawn a separate instance for it and inside of it you
        -- can specify the Lua version as well as other settings
        -- such as e.g. diagnostics, path, etc. But if there is
        -- no such file then this will (probably) determine the
        -- version.
        version='5.4',
      },

      -- This section would be ideal if all that we ever edited
      -- was Lua files run by the editor's Lua (LuaJIT). But we
      -- don't want this here because otherwise the language
      -- server will index all of the Neovim Lua files each time
      -- we edit any Lua file, even ones not run by the editor.
      -- But, we still want this in the cases where we are
      -- editing files run by the editor. So instead of dynami-
      -- cally generating the library files, we put some folders
      -- into the .luarc.json files.
      -- workspace={
      --   -- Make the server aware of Neovim runtime files.
      --   library=vim.api.nvim_get_runtime_file( '', true ),
      --   -- Don't try to auto-detect third-party libraries. This
      --   -- suppresses an annoying message.
      --   checkThirdParty=false,
      -- },

      -- Do not send telemetry data containing a randomized but
      -- unique identifier.
      telemetry={ enable=false },
    },
  },
}
