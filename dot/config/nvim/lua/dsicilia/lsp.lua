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

local ErrorCodes = protocol.ErrorCodes

local sign_define = vim.fn.sign_define
local autocmd = vim.api.nvim_create_autocmd

-----------------------------------------------------------------
-- Logging.
-----------------------------------------------------------------
-- If you need to debug an issue with the neovim LSP then enable
-- logging by changing this to "DEBUG". That will then generate a
-- log file that can be seen by running :LspInfo, typically in
-- ~/.local/state/nvim/lsp.log. We don't leave it on all the time
-- because otherwise it seems to grow indefinitely.
vim.lsp.set_log_level( "OFF" )

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

local function recompute_diagnostic_colors()
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
end

recompute_diagnostic_colors()

-- When we set the colorscheme we need to update these. This is
-- so that after we e.g. load the gruvbox plugin (which sets our
-- colorscheme) the status bar colors will be recomputed, so that
-- way we don't have to worry about importing this module in any
-- order with respect to loading that plugin.
autocmd( 'ColorScheme', { callback = recompute_diagnostic_colors } )

-- This can optionally be used to turn off semantic highlighting.
-- But once it is off, it cannot be turned back on without
-- restarting the editor. Also, this will have to be re-called if
-- the colorscheme is changed.
function M.disable_semantic_highlighting()
  local highlight_groups =
      vim.fn.getcompletion( "@lsp", "highlight" )
  for _, group in ipairs( highlight_groups ) do
    vim.api.nvim_set_hl( 0, group, {} )
  end
end

-----------------------------------------------------------------
-- Hover window.
-----------------------------------------------------------------
local function close_all_floating_windows()
  local n_closed = 0
  for _, win_id in ipairs( vim.api.nvim_list_wins() ) do
    -- Test if window is floating.
    if vim.api.nvim_win_get_config( win_id ).relative ~= '' then
      -- Force close if called with !
      vim.api.nvim_win_close( win_id, {} )
      n_closed = n_closed + 1
    end
  end
  return n_closed
end

-- This allows us to open and close the hover window with the
-- same key binding. Otherwise we'd have to close it by pressing
-- one of the motion keys which moves the cursor.
local function toggle_hover()
  local n_closed = close_all_floating_windows()
  if n_closed > 0 then return end
  vim.lsp.buf.hover()
end

-----------------------------------------------------------------
-- Keyboard mappings.
-----------------------------------------------------------------
-- Performs actions only after the language server attaches to
-- the current buffer. These actions will apply to all language
-- servers, so should be generic.
function M.on_lsp_attach( args )
  local bufnr = args.buf
  local client = vim.lsp.get_client_by_id( args.data.client_id )

  -- Buffer local mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local mappers  = require( 'dsicilia.mappers' )
  local opts = { buffer = bufnr }
  local nmap = mappers.build_mapper( 'n', opts )
  local vmap = mappers.build_mapper( 'v', opts )
  local buf = vim.lsp.buf

  -- These actions cause the cursor/view to go somewhere.
  nmap['gp']         = vim.diagnostic.goto_prev
  nmap['gn']         = vim.diagnostic.goto_next
  nmap['gD']         = buf.declaration
  nmap['gd']         = buf.definition
  nmap['gi']         = buf.implementation
  nmap['gt']         = buf.type_definition
  if client.name == 'clangd' then
    nmap['gS']  = vim.cmd.ClangdSwitchSourceHeader
  end

  -- These actions cause a box to open with info somewhere.
  nmap['K']          = toggle_hover
  -- TODO: make the list of references open in an fzf or tele-
  -- scope window.
  nmap['<leader>r']  = buf.references
  nmap['<leader>ee'] = vim.diagnostic.open_float
  nmap['<leader>eq'] = vim.diagnostic.setloclist
  nmap['<leader>es'] = buf.signature_help

  -- These perform actions on the code.
  nmap['<leader>er'] = buf.rename
  nmap['<leader>ca'] = buf.code_action
  vmap['<leader>ca'] = buf.code_action
  nmap['<C-C>']      = buf.format
end

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
