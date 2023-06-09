-----------------------------------------------------------------
-- Utils for working with LSP completion results.
-----------------------------------------------------------------
local M = {}

-----------------------------------------------------------------
-- Imports.
-----------------------------------------------------------------
local luasnip = require( 'luasnip' )

-----------------------------------------------------------------
-- Aliases.
-----------------------------------------------------------------
local format = string.format

local make_position_params = vim.lsp.util.make_position_params
local buf_request_sync = vim.lsp.buf_request_sync
local to_complete_items = vim.lsp.util
                              .text_document_completion_list_to_complete_items

local nvim_win_get_cursor = vim.api.nvim_win_get_cursor
local nvim_win_set_cursor = vim.api.nvim_win_set_cursor
local nvim_buf_set_lines = vim.api.nvim_buf_set_lines
local cur_line = vim.api.nvim_get_current_line

local trim = vim.fn.trim

-----------------------------------------------------------------
-- C/C++ enum expansion.
-----------------------------------------------------------------
function M.expand_enum_switch()
  local row = assert( nvim_win_get_cursor( 0 )[1] )

  local function set_line( what )
    nvim_buf_set_lines( 0, row - 1, row, false, { what } )
  end

  local indent = cur_line():match( '^([%s]*)' )

  -- Get expression.
  local expr = trim( cur_line() )

  -- Generate `auto _ = <expr>;` and put the cursor on the _ to
  -- get the type.
  set_line( indent .. 'auto _ = ' .. expr .. ';' )
  local underscore = #indent + 5
  nvim_win_set_cursor( 0, { row, underscore } )

  -- Get type of expression.
  local clangd = require( 'dsicilia.lsp-servers.clangd' )
  local success, type = pcall( clangd.type_under_cursor )
  if not success then
    print( type )
    return
  end
  -- Add an extra space so that, when in normal mode, our cursor
  -- can sit to the right of the '::'.
  set_line( indent .. type .. ':: ' )
  nvim_win_set_cursor( 0, { row, #cur_line() } )

  -- Get enum values.
  local at_cursor = make_position_params()
  local clients = buf_request_sync( 0, 'textDocument/completion',
                                    at_cursor )
  if not clients or #clients == 0 then
    print( 'textDocument/completion: no LSP clients responded.' )
    return
  end
  local client = assert( clients[1] )
  local result = client.result
  if not result then
    print( 'textDocument/completion: no result returned.' )
    return
  end
  local items = to_complete_items( result, '' )

  nvim_buf_set_lines( 0, row - 1, row, false, { indent .. ' ' } )
  local lines = {}
  if #items > 60 then
    print( 'too many items:', #items )
    return
  end
  local function L( ... ) table.insert( lines, format( ... ) ) end
  L( 'switch( %s ) {', expr )
  for i, item in ipairs( items ) do
    L( '  case %s::%s: {', type, item.word )
    L( '    $%d// TODO.', i )
    L( '    break;' )
    L( '  }' )
  end
  L( '}' )
  local snip = table.concat( lines, '\n' )
  luasnip.lsp_expand( snip )
end

-----------------------------------------------------------------
-- Finished.
-----------------------------------------------------------------
return M
