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
local match   = string.match

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-----------------------------------------------------------------
-- Options.
-----------------------------------------------------------------
vim.o.laststatus = 2

-----------------------------------------------------------------
-- Colors.
-----------------------------------------------------------------
-- Takes a highlight group and clones it but makes the foreground
-- text bright bold white.
local function clone_hl( template, new_hl, modifier_fn )
  local existing = vim.api.nvim_get_hl( 0, { name=template } )
  if modifier_fn then modifier_fn( existing ) end
  vim.api.nvim_set_hl( 0, new_hl, existing )
end

-- StatusLineNC is the status line on non-active windows; we use
-- it for all windows when there are multiple windows because it
-- has a non-highlighted color (unlike StatusLine) that looks
-- better and blends with the color of the dividers. For when
-- there is only one window open we use LineNr for the status
-- line so that it will have a transparent background, which
-- tends to look better when there is only one window.
clone_hl( 'LineNr',       'Status1Win' )
clone_hl( 'StatusLineNC', 'StatusNWin' )

-- Takes a highlight group and clones it but makes the foreground
-- text bright bold white.
local function make_bold_fg( template, new_hl, color )
  clone_hl( template, new_hl, function( opts )
    opts.bold = true
    local fb = opts.reverse and 'bg' or 'fg'
    opts[fb] = color
  end )
end

local GRUVBOX_LIGHT0        = '#fbf1c7'
local GRUVBOX_LIGHT2        = '#d5c4a1'
local GRUVBOX_BRIGHT_ORANGE = '#fe8019'

make_bold_fg( 'Status1Win', 'LspIndexingMsg1Win', GRUVBOX_LIGHT2 )
make_bold_fg( 'StatusNWin', 'LspIndexingMsgNWin', GRUVBOX_LIGHT2 )

make_bold_fg( 'Status1Win', 'Compiling1Win', GRUVBOX_BRIGHT_ORANGE )
make_bold_fg( 'StatusNWin', 'CompilingNWin', GRUVBOX_BRIGHT_ORANGE )

make_bold_fg( 'Status1Win', 'HintInfo1Win', GRUVBOX_LIGHT0 )
make_bold_fg( 'StatusNWin', 'HintInfoNWin', GRUVBOX_LIGHT0 )

-----------------------------------------------------------------
-- Global state.
-----------------------------------------------------------------
-- This is a map of buffer numbers that lives for the duration of
-- this vim process that will flag which buffers have received at
-- least one clangd file status update. That way, if a buffer is
-- attached to the LSP but is not in this set then we know that
-- clangd hasn't started compiling it yet. In that case, we can
-- distinguish it from a buffer that has been finished compiling
-- but that has not warnings/errors (we can't do this simply by
-- looking at the diagnostics because the diagnostics are all
-- zero for a buffer that clangd hasn't yet started compiling.
--
-- Note that at the time of writing, the file status update sent
-- by clangd that triggers the population of this set is a non-
-- statndard LSP callback that other language servers probably
-- don't have, at least not under the same name.
--
-- type: bufnr -> table
local buffer_clangd_compilation_begun = {}

-- LSP indexing progress per client name.
local lsp_indexing_progress = {}

-----------------------------------------------------------------
-- Status bar creation.
-----------------------------------------------------------------
local function has_clangd_attached( buf )
  local clients = vim.lsp.get_active_clients{ bufnr=buf }
  for _, client in ipairs( clients ) do
    if client.name == 'clangd' then return true end
  end
  return false
end

-- Vim allows one to put function calls inline in the status bar
-- text so that they will be called whenever the status bar is
-- updated. However, we don't want to do that since the status
-- bar gets re-evaluated and redrawn each time the cursor moves.
-- So we will do any expensive calculations in this function and
-- just put the results into the status bar, and then set things
-- up so that this will be called whenever it needs updating.
local function build_impl( buf )
  -- This is to test if we only have a single window open, in
  -- which case we make the status bar background color to be
  -- darker since it looks better.
  local n_wins = vim.fn.winnr( '$' )
  local bg = (n_wins == 1) and '%#Status1Win#' or '%#StatusNWin#'
  local choose_hi = function( prefix )
    return '%#'..prefix..((n_wins == 1) and '1Win#' or 'NWin#')
  end
  local progress_color  = choose_hi( 'LspIndexingMsg' )
  local compiling_color = choose_hi( 'Compiling' )
  local hint_info_color = choose_hi( 'HintInfo' )

  -- No string.format here as it messes up the inline highlights.
  local function diagnostics()
    if has_clangd_attached( buf ) then
      if not buffer_clangd_compilation_begun[buf] then
        return '---------'
      end
      if buffer_clangd_compilation_begun[buf].compiling then
        return compiling_color .. 'compiling'
      end
    end
    local diags = lsp.diagnostics_for_buffer( buf )
    if diags.errors > 0 then
      return '%#ErrorMsg#errors: ' .. diags.errors
    elseif diags.warnings > 0 then
      return '%#SyntasticWarningSign#' ..
             'warnings: ' .. diags.warnings
    elseif diags.infos > 0 then
      return hint_info_color .. 'infos: ' .. diags.infos
    elseif diags.hints > 0 then
      return hint_info_color .. 'hints: ' .. diags.hints
    end
    return 'no errors'
  end

  -- No string.format here as it messes up the inline highlights.
  local function indexing()
    local clients = vim.lsp.get_active_clients{ bufnr = buf }
    local indexing_lst = {}
    for _, client in ipairs( clients ) do
      local name = client.name
      local msg = lsp_indexing_progress[name]
      if msg and msg.done ~= true and msg.message then
        local indexing_msg = 'indexing: ' .. progress_color ..
                               msg.message .. bg
        table.insert( indexing_lst, indexing_msg )
      end
    end
    local indexing_str = table.concat( indexing_lst, ', ' )
    if indexing_str == '' then return '' end
    return ' [' .. indexing_str .. ']'
  end

  -- No string.format here as it messes up the inline highlights.
  local function lsp_state()
    local clients = vim.lsp.get_active_clients{ bufnr = buf }
    if #clients == 0 then return end
    return ' [' .. diagnostics() .. bg .. ']' .. indexing()
  end

  return
  --                     Status bar layout.
  --  _____________________________A_______________________________
  -- [                             |                               ]
     { bg,' %f',lsp_state,' %m',  '%=',' %y',' %p%%',' %l:%2c',' ' }
end

local function build( buf )
  local list = build_impl( buf )
  for i, v in ipairs( list ) do
    if type( v ) == 'function' then
      list[i] = v() or ''
    end
  end
  return table.concat( list )
end

local function window_ids_in_current_tab()
  return vim.fn.gettabinfo( vim.fn.tabpagenr() )[1].windows
end

local function rebuild_for_buffer( buf )
  assert( type( buf ) == 'number' )
  -- statusline is a window-level option, but we can't use vim.wo
  -- because that would give us the current window; we need to
  -- set it for the window(s) associated with the given buffer.
  -- That way, the status bar for windows other than the current
  -- one can update its status in response to events. For effi-
  -- ciency, we limit the set of possible windows only to those
  -- that are visible in the current tab; if the user changes
  -- tabs then the status bars will be redrawn anyway because we
  -- hook into TabEnter below.
  local win_ids = window_ids_in_current_tab()
  for _, win_id in ipairs( win_ids ) do
    if vim.fn.winbufnr( win_id ) == buf then
      vim.wo[win_id].statusline = build( buf )
    end
  end
end

local function rebuild_from_event( ev )
  rebuild_for_buffer( assert( ev.buf ) )
end

local function rebuild_for_current_tab()
  -- Iterate over all buffers visible in tab.
  for _, bufnr in ipairs( vim.fn.tabpagebuflist() ) do
    rebuild_for_buffer( bufnr )
  end
end

-----------------------------------------------------------------
-- Clangd file status.
-----------------------------------------------------------------
local function clangd_file_status_handler( result, _, _ )
  -- The code in vim.lsp.handlers would seem to suggest that the
  -- buffer number should be accessible via ctx.bufnr, but that
  -- does not seem to be populated here. So instead we get the
  -- buffer number from the URI of the file in question.
  local buf = assert( uri.uri_to_bufnr( result.uri ) )
  local stage = assert( result.state )
  local queued       = match( stage, 'queued' )  ~= nil
  local idle         = match( stage, 'idle' )    ~= nil
  local building_ast = match( stage, 'AST' )     ~= nil
  local parsing      = match( stage, 'parsing' ) ~= nil
  local any = queued or idle or building_ast or parsing
  assert( any )
  local compiling = parsing or building_ast
  if buffer_clangd_compilation_begun[buf] or compiling then
    buffer_clangd_compilation_begun[buf] = {
      compiling=compiling
    }
  end
  rebuild_for_buffer( buf )
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

-- This is needed so that if the status bar changes in a window
-- on tab Y while editing in tab X, then when we switch to tab Y
-- we will see the diagnostics updated in tab Y's status bar.
autocmd( 'TabEnter', { callback = rebuild_for_current_tab  } )

-- This is because the LSP is always working in the background,
-- and we want the status bar to be updated whenever it has new
-- results.
autocmd( 'DiagnosticChanged', { callback = rebuild_from_event } )

-- Set the status bar immediately for the first buffer, otherwise
-- it won't get updated until on of the above autocmd actions
-- happens.
rebuild_for_buffer( 1 )

-----------------------------------------------------------------
-- Progress messages.
-----------------------------------------------------------------
-- A "progress message" is sent by the LSP to communicate the
-- total overall progress that the language server is making in
-- indexing/compiling the entire set of available files. Again,
-- these do not indicate progress on individual files. Not all
-- of the fields are always present. E.g.:
--
--   msg {
--     done       = true,
--     name       = "clangd",
--     percentage = 0,
--     progress   = true,
--     title      = "indexing"
--     message    = "5/123"
--   }
--
local function on_progress()
  local messages = vim.lsp.util.get_progress_messages()
  for _, msg in ipairs( messages ) do
    if msg.name and msg.name ~= '' then
      lsp_indexing_progress[msg.name] = msg
    end
  end
  rebuild_for_current_tab()
end

-- These are "user auto-commands" which means that they are exe-
-- cuted manually, and the "pattern" holds the event name.
local function user_autocmd( event, callback )
  autocmd( 'User', {
    pattern  = event,
    group    = augroup( 'StatusBar' .. event, {} ),
    callback = callback
  } )
end

user_autocmd( 'LspRequest', on_progress )
user_autocmd( 'LspProgressUpdate', on_progress )

-----------------------------------------------------------------
-- Finished.
-----------------------------------------------------------------
return M
