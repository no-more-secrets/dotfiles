-----------------------------------------------------------------
-- Language Servers.
-----------------------------------------------------------------
local M = {}

-----------------------------------------------------------------
-- Imports.
-----------------------------------------------------------------
local protocol = require( 'vim.lsp.protocol' )
local colors = require( 'dsicilia.colors' )
local win = require( 'dsicilia.win' )
local messages = require( 'dsicilia.messages' )

-----------------------------------------------------------------
-- Aliases.
-----------------------------------------------------------------
local format = string.format

local ErrorCodes = protocol.ErrorCodes

local sign_define = vim.fn.sign_define
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-----------------------------------------------------------------
-- Constants.
-----------------------------------------------------------------
local LSP_SEMANTIC_HIGHLIGHTING = true

-----------------------------------------------------------------
-- Logging.
-----------------------------------------------------------------
-- If you need to debug an issue with the neovim LSP then enable
-- logging by changing this to "DEBUG". That will then generate a
-- log file that can be seen by running :LspInfo, typically in
-- ~/.local/state/nvim/lsp.log. We don't leave it on all the time
-- because otherwise it seems to grow indefinitely.
vim.lsp.set_log_level( 'OFF' )

-----------------------------------------------------------------
-- Gutter signs.
-----------------------------------------------------------------
sign_define( 'DiagnosticSignError',
             { text='ER', texthl='DiagnosticError' } )
sign_define( 'DiagnosticSignWarn',
             { text='WN', texthl='DiagnosticWarn' } )
sign_define( 'DiagnosticSignHint',
             { text='HN', texthl='DiagnosticHint' } )
sign_define( 'DiagnosticSignInfo',
             { text='IN', texthl='DiagnosticInfo' } )

-----------------------------------------------------------------
-- Colors
-----------------------------------------------------------------
local RED = '#fb4934' -- gruvbox "bright_red".
local YLW = '#fabd2f' -- gruvbox "bright_yellow".
local BLK = '#1d2021' -- gruvbox "dark0_hard".
local WHT = '#fbf1c7' -- gruvbox "light0".

colors.hl_setter( 'LspDiag', function( hi )
  hi.DiagnosticVirtualTextError = { fg=RED }
  hi.DiagnosticFloatingError = { fg=RED }
  hi.DiagnosticVirtualTextWarn = { fg=YLW }
  hi.DiagnosticFloatingWarn = { fg=YLW }
  hi.DiagnosticVirtualTextHint = { fg=WHT }
  hi.DiagnosticFloatingHint = { fg=WHT }
  hi.DiagnosticVirtualTextInfo = { fg=WHT }
  hi.DiagnosticFloatingInfo = { fg=WHT }
  hi.DiagnosticError = { fg=BLK, bg=RED }
  hi.DiagnosticWarn = { fg=BLK, bg=YLW }
  hi.DiagnosticHint = { fg=BLK, bg=WHT }
  hi.DiagnosticInfo = { fg=BLK, bg=WHT }
end )

-----------------------------------------------------------------
-- Hover window.
-----------------------------------------------------------------
-- This allows us to open and close the hover window with the
-- same key binding. Otherwise we'd have to close it by pressing
-- one of the motion keys which moves the cursor.
local function toggle_hover()
  local n_closed = win.close_all_floating_windows()
  if n_closed > 0 then return end
  vim.lsp.buf.hover()
end

-----------------------------------------------------------------
-- Keyboard mappings.
-----------------------------------------------------------------
-- Performs actions only after the language server attaches to
-- the current buffer. These actions will apply to all language
-- servers, so should be generic.
local function on_lsp_attach( args )
  local telescope = require( 'telescope.builtin' )
  local lsp_comp = require( 'dsicilia.lsp-completion' )
  local bufnr = args.buf
  local client = vim.lsp.get_client_by_id( args.data.client_id )

  local clangd
  if client.name == 'clangd' then
    clangd = require( 'dsicilia.lsp-servers.clangd' )
  end

  if LSP_SEMANTIC_HIGHLIGHTING == false then
    -- Turn off the highlighting from the LSP and fall back to
    -- whatever else if highlighting (probably treesitter).
    client.server_capabilities.semanticTokensProvider = nil
  end

  -- Buffer local mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local mappers =
      require( 'dsicilia.mappers' ).for_buffer( bufnr )
  local nmap, vmap = mappers.nmap, mappers.vmap
  local buf = vim.lsp.buf

  -- These actions cause the cursor/view to go somewhere.
  nmap['gp'] = vim.diagnostic.goto_prev
  nmap['gn'] = vim.diagnostic.goto_next
  nmap['gD'] = buf.declaration
  nmap['gd'] = buf.definition
  nmap['gi'] = buf.implementation
  nmap['gt'] = buf.type_definition
  if clangd then nmap['gS'] = vim.cmd.ClangdSwitchSourceHeader end

  -- These actions can cause a box to open with info somewhere.
  nmap['K'] = toggle_hover
  nmap['gr'] = telescope.lsp_references
  nmap['<leader>ee'] = vim.diagnostic.open_float
  nmap['<leader>eq'] = telescope.diagnostics
  nmap['<leader>es'] = buf.signature_help

  -- These are special actions where we manually call the LSP to
  -- get info and either display it in the message box or insert
  -- a snippet.
  if clangd then
    nmap['<leader>et'] = clangd.GetType
    local wrap = messages.wrap_with_errors_to_messages
    nmap['<leader>le'] = wrap( lsp_comp.expand_enum_switch )
    nmap['<leader>lv'] = wrap( lsp_comp.expand_variant_switch )
  end

  -- These perform actions on the code.
  nmap['<leader>er'] = buf.rename
  nmap['<leader>ca'] = buf.code_action
  vmap['<leader>ca'] = buf.code_action

  -- NOTE: auto-formatting (via buf.format and otherwise) is han-
  -- dled in a separate module.
end

-----------------------------------------------------------------
-- Auto-commands.
-----------------------------------------------------------------
autocmd( 'LspAttach', {
  group=augroup( 'UserLspConfig', { clear=true } ),
  callback=on_lsp_attach,
} )

-----------------------------------------------------------------
-- Diagnostics.
-----------------------------------------------------------------
function M.diagnostics_for_buffer( buf )
  assert( buf )
  local LEVELS = {
    errors=vim.diagnostic.severity.ERROR,
    warnings=vim.diagnostic.severity.WARN,
    infos=vim.diagnostic.severity.INFO,
    hints=vim.diagnostic.severity.HINT,
  }
  local res = {}
  for name, level in pairs( LEVELS ) do
    res[name] = #vim.diagnostic.get( buf, { severity=level } )
  end
  return res
end

vim.diagnostic.config{
  virtual_text=true,
  underline=true,
  signs=true,
  -- Set this to true to have the LSP work in realtime while in-
  -- serting text in insert mode.
  update_in_insert=false,
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
