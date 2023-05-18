-----------------------------------------------------------------
-- Language Servers.
-----------------------------------------------------------------
local M = {}

-----------------------------------------------------------------
-- Imports.
-----------------------------------------------------------------
local protocol = require( 'vim.lsp.protocol' )
local mappers  = require( 'dsicilia.mappers' )

-----------------------------------------------------------------
-- Aliases.
-----------------------------------------------------------------
local nmap, imap, vmap = mappers.nmap, mappers.imap, mappers.vmap

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local ErrorCodes = protocol.ErrorCodes

-----------------------------------------------------------------
-- Colors
-----------------------------------------------------------------
vim.api.nvim_set_hl( 0, 'DiagnosticError',            { fg='black', bg='red'    } )
vim.api.nvim_set_hl( 0, 'DiagnosticVirtualTextError', { fg='red'                } )
vim.api.nvim_set_hl( 0, 'DiagnosticFloatingError',    { fg='red'                } )
vim.api.nvim_set_hl( 0, 'DiagnosticWarn',             { fg='black', bg='yellow' } )
vim.api.nvim_set_hl( 0, 'DiagnosticVirtualTextWarn',  { fg='yellow'             } )
vim.api.nvim_set_hl( 0, 'DiagnosticFloatingWarn',     { fg='yellow'             } )

-----------------------------------------------------------------
-- Keyboard mappings.
-----------------------------------------------------------------
-- Global mappings.
nmap['<Leader>es'] = vim.diagnostic.open_float
nmap['<Leader>eq'] = vim.diagnostic.setloclist
nmap['g[']         = vim.diagnostic.goto_prev
nmap['g]']         = vim.diagnostic.goto_next

-- Performs actions only after the language server attaches to
-- the current buffer. These actions will apply to all language
-- servers, so should be generic.
local function on_lsp_attach( ev )
  -- Enable completion triggered by <c-x><c-o>
  vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

  -- Buffer local mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local opts = { buffer = ev.buf }
  local nmap = mappers.build_mapper( 'n', opts )
  local vmap = mappers.build_mapper( 'v', opts )
  local buf = vim.lsp.buf

  nmap['gD']         = buf.declaration
  nmap['gd']         = buf.definition
  nmap['gi']         = buf.implementation
  nmap['<Leader>D']  = buf.type_definition
  nmap['<Leader>et'] = buf.hover
  nmap['<C-k>']      = buf.signature_help
  nmap['<Leader>er'] = buf.rename
  nmap['<Leader>ca'] = buf.code_action
  vmap['<Leader>ca'] = buf.code_action
  nmap['<Leader>R']  = buf.references
  nmap['<C-C>']      = buf.format
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
    info = vim.diagnostic.severity.INFO,
    hints = vim.diagnostic.severity.HINT,
  }
  local result = {}
  local total = 0
  for name, level in pairs( LEVELS ) do
    result[name] = #vim.diagnostic.get( buf, { severity = level } )
    total = total + result[name]
  end
  if total == 0 then return nil end
  return result
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
-- Specific language servers.
-----------------------------------------------------------------
require( 'dsicilia.lsp-servers.clangd' )

-----------------------------------------------------------------
-- Finished.
-----------------------------------------------------------------
return M
