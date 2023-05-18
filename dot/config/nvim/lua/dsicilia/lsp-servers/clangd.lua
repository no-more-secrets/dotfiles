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
local clangd = lspconfig.clangd

assert( paths.TOOLS )
local CLANGD = format( '%s/llvm-current/bin/clangd', paths.TOOLS )

clangd.setup {
  cmd = { CLANGD },
  init_options = {
    -- Enables a custom LSP API extension provided by clangd that
    -- gives the realtime status on the compilation of each file.
    clangdFileStatus = true
  },
}
