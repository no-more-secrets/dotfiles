-----------------------------------------------------------------
-- Imports.
-----------------------------------------------------------------
local lspconfig  = require( 'lspconfig' )
local paths      = require( 'dsicilia.paths' )

-----------------------------------------------------------------
-- Aliases.
-----------------------------------------------------------------
local format = string.format

-----------------------------------------------------------------
-- Setup.
-----------------------------------------------------------------
local lua_ls = lspconfig.lua_ls

assert( paths.TOOLS )
local lls = '%s/lua-language-server-current/bin/lua-language-server'
local LLS = format( lls, paths.TOOLS )

lua_ls.setup {
  cmd = { LLS },
  settings = {
    -- See the settings.lua file in the lua-language-server
    -- package for all of the settings.
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're
        -- using (most likely LuaJIT in the case of Neovim).
        version = '5.4.3'
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global.
        globals = { 'vim', 'ROOT', 'log', 'ROOT_TS' },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files.
        library = vim.api.nvim_get_runtime_file( "", true ),
      },
      -- Do not send telemetry data containing a randomized but
      -- unique identifier.
      telemetry = { enable = false },
    },
  },
}
