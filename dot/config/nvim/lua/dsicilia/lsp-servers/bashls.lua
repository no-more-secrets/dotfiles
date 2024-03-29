-----------------------------------------------------------------
-- Imports.
-----------------------------------------------------------------
local lspconfig = require( 'lspconfig' )

-----------------------------------------------------------------
-- Setup.
-----------------------------------------------------------------
local autocomplete_capabilities =
    require( 'cmp_nvim_lsp' ).default_capabilities()

if vim.fn.executable( 'bash-language-server' ) == 0 then return end
-- Shellcheck is needed to get diagnostics.
if vim.fn.executable( 'shellcheck' ) == 0 then return end

lspconfig.bashls.setup{ capabilities=autocomplete_capabilities }
