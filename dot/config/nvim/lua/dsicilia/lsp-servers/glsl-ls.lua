-----------------------------------------------------------------
-- Imports.
-----------------------------------------------------------------
local lspconfig  = require( 'lspconfig' )

-----------------------------------------------------------------
-- Setup.
-----------------------------------------------------------------
local autocomplete_capabilities =
    require( 'cmp_nvim_lsp' ).default_capabilities()

if vim.fn.executable( 'glslls' ) == 0 then
  return
end

lspconfig.glslls.setup{
  cmd = { 'glslls', '--stdin', '--target-env=opengl' },
  capabilities = autocomplete_capabilities,
}
