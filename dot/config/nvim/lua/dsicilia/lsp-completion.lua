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

local function set_line( row, what )
  nvim_buf_set_lines( 0, row - 1, row, false, { what } )
end

local function type_of_current_line( modifier )
  modifier = modifier or function( x ) return x end
  local row = assert( nvim_win_get_cursor( 0 )[1] )

  local indent = cur_line():match( '^([%s]*)' ) or ''

  -- Get expression and apply modifier.
  local expr = modifier( trim( cur_line() ) )

  -- Generate `auto _ = <expr>;` and put the cursor on the _ to
  -- get the type.
  set_line( row, indent .. 'auto _ = ' .. expr .. ';' )
  local underscore = #indent + 5
  nvim_win_set_cursor( 0, { row, underscore } )

  -- Get type of expression.
  local clangd = require( 'dsicilia.lsp-servers.clangd' )
  return clangd.type_under_cursor()
end

local function completion_at_cursor()
  local at_cursor = make_position_params()
  local clients = buf_request_sync( 0, 'textDocument/completion',
                                    at_cursor )
  if not clients or #clients == 0 then
    error( 'textDocument/completion: no LSP clients responded.' )
  end
  local client = assert( clients[1] )
  local result = client.result
  if not result then
    error( 'textDocument/completion: no result returned.' )
  end
  return to_complete_items( result, '' )
end

local function clear_line( row, indent )
  nvim_buf_set_lines( 0, row - 1, row, false, { indent .. ' ' } )
end

-----------------------------------------------------------------
-- C/C++ enum expansion.
-----------------------------------------------------------------
function M.expand_enum_switch()
  local row = assert( nvim_win_get_cursor( 0 )[1] )
  local indent = cur_line():match( '^([%s]*)' )
  local expr = trim( cur_line() )

  local type = type_of_current_line()

  -- Add an extra space so that, when in normal mode, our cursor
  -- can sit to the right of the '::'.
  set_line( row, indent .. type .. ':: ' )
  nvim_win_set_cursor( 0, { row, #cur_line() } )
  local items = completion_at_cursor()
  if #items > 60 then error( 'too many items:', #items ) end

  clear_line( row, indent )
  local lines = {}
  local function L( ... ) table.insert( lines, format( ... ) ) end
  L( 'switch( %s ) {', expr )
  for i, item in ipairs( items ) do
    L( '  case %s::%s: {', type, item.word )
    L( '    // TODO', i )
    L( '    break;' )
    L( '  }' )
  end
  L( '}' )
  luasnip.lsp_expand( table.concat( lines, '\n' ) )
end

-----------------------------------------------------------------
-- Rds variant switch expansion.
-----------------------------------------------------------------
function M.expand_variant_switch()
  local row = assert( nvim_win_get_cursor( 0 )[1] )
  local indent = cur_line():match( '^([%s]*)' )
  local expr = trim( cur_line() )

  -- LuaFormatter off
  local type = type_of_current_line( function( line )
    return line .. '.to_enum()'
  end )
  -- LuaFormatter on

  -- "Enum (aka rn::unit_orders::e)" ==> "rn::unit_orders"
  type = type:gsub( [[.*%(aka (.+)::e%)$]], '%1' )
  if not type then error( 'failed to parse type info.' ) end
  type = trim( type )
  if #type == 0 then error( 'empty type after parsing.' ) end

  -- Add an extra space so that, when in normal mode, our cursor
  -- can sit to the right of the '::'.
  set_line( row, indent .. type .. '::e:: ' )
  nvim_win_set_cursor( 0, { row, #cur_line() } )
  local items = completion_at_cursor()
  if #items > 60 then error( 'too many items:', #items ) end

  clear_line( row, indent )
  local lines = {}
  local function L( ... ) table.insert( lines, format( ... ) ) end
  L( 'SWITCH( %s ) {', expr )
  for i, item in ipairs( items ) do
    L( '  CASE( %s ) {', item.word )
    L( '    // TODO', i )
    L( '    break;' )
    L( '  }' )
  end
  L( '}' )
  luasnip.lsp_expand( table.concat( lines, '\n' ) )
end

-----------------------------------------------------------------
-- Finished.
-----------------------------------------------------------------
return M
