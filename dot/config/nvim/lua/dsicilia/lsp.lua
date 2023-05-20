-----------------------------------------------------------------
-- Language Servers.
-----------------------------------------------------------------
local M = {}

-----------------------------------------------------------------
-- Imports.
-----------------------------------------------------------------
local protocol = require( 'vim.lsp.protocol' )

-----------------------------------------------------------------
-- Aliases.
-----------------------------------------------------------------
local format = string.format

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local ErrorCodes = protocol.ErrorCodes

local sign_define = vim.fn.sign_define

-----------------------------------------------------------------
-- Gutter signs.
-----------------------------------------------------------------
sign_define( 'DiagnosticSignError', { text='ER', texthl='DiagnosticError' } )
sign_define( 'DiagnosticSignWarn',  { text='WN', texthl='DiagnosticWarn'  } )
sign_define( 'DiagnosticSignHint',  { text='HN', texthl='DiagnosticHint'  } )
sign_define( 'DiagnosticSignInfo',  { text='IN', texthl='DiagnosticInfo'  } )

-----------------------------------------------------------------
-- Colors
-----------------------------------------------------------------
local RED = '#fb4934' -- gruvbox "bright_red".
local YLW = '#fabd2f' -- gruvbox "bright_yellow".
local BLK = '#1d2021' -- gruvbox "dark0_hard".
local WHT = '#fbf1c7' -- gruvbox "light0".

vim.api.nvim_set_hl( 0, 'DiagnosticVirtualTextError', { fg=RED } )
vim.api.nvim_set_hl( 0, 'DiagnosticFloatingError',    { fg=RED } )
vim.api.nvim_set_hl( 0, 'DiagnosticVirtualTextWarn',  { fg=YLW } )
vim.api.nvim_set_hl( 0, 'DiagnosticFloatingWarn',     { fg=YLW } )
vim.api.nvim_set_hl( 0, 'DiagnosticVirtualTextHint',  { fg=WHT } )
vim.api.nvim_set_hl( 0, 'DiagnosticFloatingHint',     { fg=WHT } )
vim.api.nvim_set_hl( 0, 'DiagnosticVirtualTextInfo',  { fg=WHT } )
vim.api.nvim_set_hl( 0, 'DiagnosticFloatingInfo',     { fg=WHT } )
vim.api.nvim_set_hl( 0, 'DiagnosticError',    { fg=BLK, bg=RED } )
vim.api.nvim_set_hl( 0, 'DiagnosticWarn',     { fg=BLK, bg=YLW } )
vim.api.nvim_set_hl( 0, 'DiagnosticHint',     { fg=BLK, bg=WHT } )
vim.api.nvim_set_hl( 0, 'DiagnosticInfo',     { fg=BLK, bg=WHT } )

-----------------------------------------------------------------
-- Keyboard mappings.
-----------------------------------------------------------------
-- Performs actions only after the language server attaches to
-- the current buffer. These actions will apply to all language
-- servers, so should be generic.
local function on_lsp_attach( ev )
  -- Enable completion triggered by <c-x><c-o>
  vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

  -- Buffer local mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local mappers  = require( 'dsicilia.mappers' )
  local opts = { buffer = ev.buf }
  local nmap = mappers.build_mapper( 'n', opts )
  local vmap = mappers.build_mapper( 'v', opts )
  local buf = vim.lsp.buf

  nmap['<leader>ee'] = vim.diagnostic.open_float
  nmap['<leader>eq'] = vim.diagnostic.setloclist
  nmap['gp']         = vim.diagnostic.goto_prev
  nmap['gn']         = vim.diagnostic.goto_next

  nmap['gD']         = buf.declaration
  nmap['gd']         = buf.definition
  nmap['gi']         = buf.implementation
  nmap['<leader>D']  = buf.type_definition
  nmap['K']          = buf.hover
  nmap['<leader>es'] = buf.signature_help
  nmap['<leader>er'] = buf.rename
  nmap['<leader>ca'] = buf.code_action
  vmap['<leader>ca'] = buf.code_action
  nmap['<leader>R']  = buf.references
  nmap['<C-C>']      = buf.format
  -- This command comes from nvim-lspconfig.
  nmap['<Leader>S']  = vim.cmd.ClangdSwitchSourceHeader
end

-----------------------------------------------------------------
-- Auto-commands.
-----------------------------------------------------------------
autocmd( 'LspAttach', {
  group = augroup( 'UserLspConfig', {} ),
  callback = on_lsp_attach
} )

-----------------------------------------------------------------
-- Diagnostics.
-----------------------------------------------------------------
function M.diagnostics_for_buffer( buf )
  assert( buf )
  local LEVELS = {
    errors = vim.diagnostic.severity.ERROR,
    warnings = vim.diagnostic.severity.WARN,
    infos = vim.diagnostic.severity.INFO,
    hints = vim.diagnostic.severity.HINT,
  }
  local res = {}
  for name, level in pairs( LEVELS ) do
    res[name] = #vim.diagnostic.get( buf, { severity = level } )
  end
  return res
end

vim.diagnostic.config {
  virtual_text = true,
  underline = true,
  signs = true,
  -- Set this to true to have the LSP work in realtime while in-
  -- serting text in insert mode.
  update_in_insert = false,
}

-----------------------------------------------------------------
-- Handler stuff.
-----------------------------------------------------------------
-- Takes a handler function (with the appropriate signature minus
-- the err parameter which will have already been handled) and
-- returns a new function that calls it but with standard handler
-- error checking.
function M.with_error_handler( fn )
  return function( err, result, ctx, config )
    if not err then return fn( result, ctx, config ) end
    -- Per LSP, don't show ContentModified error to the user.
    if err.code == ErrorCodes.ContentModified then return end
    -- See vim.lsp.handlers for a more sophisticated version.
    local msg = format( 'LSP:%s: %s', tostring( err.code ),
                         vim.inspect( err.message ) )
    vim.notify( msg, vim.log.levels.ERROR )
  end
end

-----------------------------------------------------------------
-- Finished.
-----------------------------------------------------------------
return M
