-----------------------------------------------------------------
-- Status Bar.
-----------------------------------------------------------------
local M = {}

-----------------------------------------------------------------
-- Imports.
-----------------------------------------------------------------
local lsp = require( 'dsicilia.lsp' )
local uri = require( 'vim.uri' )

-----------------------------------------------------------------
-- Aliases.
-----------------------------------------------------------------
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-----------------------------------------------------------------
-- Options.
-----------------------------------------------------------------
vim.o.laststatus = 2

-----------------------------------------------------------------
-- Status bar creation.
-----------------------------------------------------------------
-- Vim allows one to put function calls inline in the status bar
-- text so that they will be called whenever the status bar is
-- updated. However, we don't want to do that since the status
-- bar gets re-evaluated and redrawn each time the cursor moves.
-- So we will do any expensive calculations in this function and
-- just put the results into the status bar, and then set things
-- up so that this method will be called whenever the contents
-- need to be updated.
local function build_impl( contents )
  contents = contents or {}

  local function diagnostics()
    if contents.is_compiling then
      return '%#WarningMsg#compiling'
    end
    local diagnostics = lsp.diagnostics_for_buffer( contents.buf )
    -- TODO: need to store whether any updates have yet been re-
    -- ceived for the buffer.
    if diagnostics == nil then return 'no errors' end
    if diagnostics.errors > 0 then
      return '%#ErrorMsg#errors: ' .. diagnostics.errors
    elseif diagnostics.warnings > 0 then
      return '%#SyntasticWarningSign#' ..
             'warnings: ' .. diagnostics.warnings
    end
  end

  -- This is to test if we only have a single window open, in
  -- which case we make the status bar background color to be
  -- darker since it looks better.
  local n_wins = contents.num_windows or vim.fn.winnr( '$' )
  local bg = (n_wins == 1) and '%#LineNr#' or '%#StatusLineNC#'
  return {
    bg,

    -- Left side.
    ' %f',         -- file name.
    ' [',          -- open LSP.
    diagnostics,   -- errors/warnings.
    bg .. '] ',    -- close LSP.
    '%m',          -- modified flag.

    -- Right side.
    '%=',
    ' %y',         -- file type.
    ' %p%%',       -- cursor position % through document.
    ' %l:%2c',     -- line:column of cursor.
    ' ',
  }
end

local function build( contents )
  local list = build_impl( contents )
  for i, v in ipairs( list ) do
    if type( v ) == 'function' then
      list[i] = v()
    end
  end
  return table.concat( list )
end

local function redraw_all_status_bars()
  -- vim.schedule( function()
  --   vim.cmd.redrawstatus( { bang=true } )
  -- end )
  vim.cmd.redrawstatus( { bang=true } )
end

local function rebuild_from_event( opts )
  -- statusline is a window-level option, but we can't use vim.wo
  -- because that would give us the current window; we need to
  -- set it for the window(s) associated with the given buffer.
  -- That way, the status bar for windows other than the current
  -- one can e.g. update its status in response to events.
  local windows = {}
  for winnr = 1, vim.fn.winnr( '$' ) do
    local winbuf = vim.fn.winbufnr( winnr )
    if winbuf == opts.buf then
      local win_id = vim.fn.win_getid( winnr )
      vim.wo[win_id].statusline = build( opts )
    end
  end
  -- TODO: do we need this?
  redraw_all_status_bars()
end

-----------------------------------------------------------------
-- Clangd file status.
-----------------------------------------------------------------
local function clangd_file_status_handler( result, ctx, _ )
  local opts = {}
  -- The code in vim.lsp.handlers would seem to suggest that the
  -- buffer number should be accessible via ctx.bufnr, but that
  -- does not seem to be populated here. So instead we get the
  -- buffer number from the URI of the file in question.
  opts.buf = assert( uri.uri_to_bufnr( result.uri ) )
  opts.is_compiling = (result.state ~= 'idle')
  rebuild_from_event( opts )
end

-- This is a non-standard LSP API extension provided by clangd
-- that allows receiving realtime state on the compilation status
-- of an individual file.
vim.lsp.handlers["textDocument/clangd.fileStatus"]
    = lsp.with_error_handler( clangd_file_status_handler )

-----------------------------------------------------------------
-- Auto-commands.
-----------------------------------------------------------------
-- We need this because when the second-to-last window closes we
-- need to update the status bar of the remaining window because
-- when there is only one window left the status bar background
-- color changes.
autocmd( 'WinEnter', { callback = rebuild_from_event } )

-- This is needed so that if an error appears in a window on tab
-- Y while editing in tab X, then when we switch to tab Y we will
-- see the diagnostics updated in tab Y's status bar.
-- TODO: may need to iterate over all buffers in the tab and
-- call rebuild_from_event.
--autocmd( 'TabEnter', { callback = redraw_all_status_bars } )

-- This is because the LSP is always working in the background,
-- and we want the status bar to be updated whenever it has new
-- results.
autocmd( 'DiagnosticChanged', { callback = rebuild_from_event } )

-- Set the status bar immediately for the first buffer, otherwise
-- it won't get updated until on of the above autocmd actions
-- happens.
rebuild_from_event{ buf=1 }

-----------------------------------------------------------------
-- User auto-commands.
-----------------------------------------------------------------
local function user_autocmd( event, callback )
  -- This is a "user auto-command" which means that it is exe-
  -- cuted manually, and the "pattern" holds the event name.
  autocmd( 'User', {
    pattern = event,
    group = augroup( 'StatusBarUpdate', {} ),
    callback = callback
  } )
end

local function on_progress()
  local messages = vim.lsp.util.get_progress_messages()
  local f = io.open( 'progress.log', 'a' )
  f:write( 'progress: ' .. vim.inspect( messages ) .. '\n' )
  f:close()
end

user_autocmd( 'LspProgressUpdate', on_progress )
-- user_autocmd( 'LspRequest', on_progress )

-----------------------------------------------------------------
-- Finished.
-----------------------------------------------------------------
return M
