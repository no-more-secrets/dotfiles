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
    -- See clangd.llvm.org/extensions for a list of protocol
    -- extensions and options.

    -- Enables a custom LSP API extension provided by clangd that
    -- gives the realtime status on the compilation of each file.
    clangdFileStatus = true,

    -- This can be set to the path of a folder in which clangd
    -- should look for the compile commands json file. It will
    -- use this for all files if found, and this will also over-
    -- ride any parent directory searches. That said, if using a
    -- simple .clangd file in the root of the project to do the
    -- same thing suffices, then that is probably preferable.
    --
    --   compilationDatabasePath = '/some/folder'
  },
}
