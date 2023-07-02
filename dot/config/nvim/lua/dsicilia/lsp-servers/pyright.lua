-----------------------------------------------------------------
-- Imports.
-----------------------------------------------------------------
local lspconfig = require( 'lspconfig' )

-----------------------------------------------------------------
-- Setup.
-----------------------------------------------------------------
local autocomplete_capabilities =
    require( 'cmp_nvim_lsp' ).default_capabilities()

if vim.fn.executable( 'pyright-langserver' ) == 0 then return end

lspconfig.pyright.setup{
  cmd={ 'pyright-langserver', '--stdio' },
  capabilities=autocomplete_capabilities,
  settings={
    python={
      analysis={
        autoImportCompletions=true,
        autoSearchPaths=true,
        diagnosticMode='workspace',
        typeCheckingMode='basic',
        useLibraryCodeForTypes=true,
      },
    },
  },
}
