-----------------------------------------------------------------
-- clangd.
-----------------------------------------------------------------
local M = {}

-----------------------------------------------------------------
-- Imports.
-----------------------------------------------------------------
local lspconfig = require( 'lspconfig' )
local paths = require( 'dsicilia.paths' )
local colors = require( 'dsicilia.colors' )
local messages = require( 'dsicilia.messages' )
local gruvbox = require( 'gruvbox' )
local palette = require( 'gruvbox.palette' )

-----------------------------------------------------------------
-- Aliases.
-----------------------------------------------------------------
local format = string.format
local split = vim.fn.split
local join = vim.fn.join
local make_position_params = vim.lsp.util.make_position_params
local buf_request_sync = vim.lsp.buf_request_sync
local color_message = colors.color_message
local with_cmdheight = messages.with_cmdheight
local trim = vim.fn.trim
local with_errors_to_messages = messages.with_errors_to_messages
local BOLD = gruvbox.config.bold

-----------------------------------------------------------------
-- Setup.
-----------------------------------------------------------------
local clangd = lspconfig.clangd

assert( paths.TOOLS )
local CLANGD =
    format( '%s/llvm-current/bin/clangd', paths.TOOLS )

local autocomplete_capabilities =
    require( 'cmp_nvim_lsp' ).default_capabilities()

clangd.setup{
  cmd={ CLANGD },
  capabilities=autocomplete_capabilities,
  init_options={
    -- See clangd.llvm.org/extensions for a list of protocol
    -- extensions and options.

    -- Enables a custom LSP API extension provided by clangd that
    -- gives the realtime status on the compilation of each file.
    clangdFileStatus=true,

    -- This can be set to the path of a folder in which clangd
    -- should look for the compile commands json file. It will
    -- use this for all files if found, and this will also over-
    -- ride any parent directory searches. That said, if using a
    -- simple .clangd file in the root of the project to do the
    -- same thing suffices, then that is probably preferable.
    --
    --   compilationDatabasePath = '/some/folder'
  },
}

-----------------------------------------------------------------
-- YCM-style "GetType".
-----------------------------------------------------------------
-- This attempts to simulate YCM's "get type" behavior; it uses a
-- similar approach to parsing the markdown from a hover() LSP
-- call to obtain a one-line representation of the type. Other-
-- wise, in order to get the type we'd always have to pop open
-- one of those hover windows which contain a lot of visual noise
-- and are not easy ot read.
--
-- The markdown that clangd returns (and that we have to parse)
-- seems to have one of the following forms:
--
--   1. A multi-line cpp block:
--   ==========================================================
--
--     stuff
--     ```cpp
--     // In namespace xyz.
--     private: std::vector<int> some_var
--     ```
--
--     We want to turn tha into:
--
--       "std::vector<int> some_var; // In namespace xyz."
--
--   1.a A multi-line cpp block with multi-line comment:
--   ==========================================================
--
--     stuff
--     ```cpp
--     std::vector<int> some_var // comment 1
--                               // comment 2
--     ```
--
--     We want to turn tha into:
--
--       "std::vector<int> some_var; // comment 1 comment 2."
--
--   2. Single-line cpp block:
--   ==========================================================
--
--     <stuff>Type: `std::vector<int>`<stuff>
--     <stuff>
--     --------------------
--     // Comment
--     <stuff>
--
--     We want to turn tha into:
--
--       "std::vector<int>; // Comment."
--
-- Sometimes more than one will parse, e.g. both a single-line
-- and multi-line parse works. In that case, we prefer to take
-- the type from the single-line one because it seems more con-
-- cise.
--
-- This is a mess, but that's because we're trying to parse some
-- arbitrary markdown that clangd returns, which can come in mul-
-- tiple different formats, and in each case we're trying to get
-- all of the useful info contained therein.
--
local function get_type_under_cursor()
  local type = '?'
  local comment
  local at_cursor = make_position_params()
  local clients = buf_request_sync( 0, 'textDocument/hover',
                                    at_cursor )
  if not clients or #clients == 0 then
    error( 'No LSP clients responded' )
  end
  local client = clients[1]
  if not client.result then error( 'Type not available' ) end
  local markdown = assert( client.result.contents.value )
  if #markdown:gsub( '%s+', '' ) == 0 then
    error( 'Markdown not available' )
  end
  local multiline = markdown:match( '```cpp\n(.*)```' )
  local singleline = markdown:match( 'Type: `([^`]+)`' )
  if singleline then
    type = singleline
    -- Now find the comment down below.
    local lines = split( multiline, '\n' )
    assert( #lines > 0 )
    for _, line in ipairs( lines ) do
      if line:match( '^// In' ) then
        comment = line
        break
      end
    end
  elseif multiline then
    local lines = split( multiline, '\n' )
    assert( #lines > 0 )
    if lines[1]:match( '^// In' ) then
      comment = lines[1]
      table.remove( lines, 1 )
    end
    type = join( lines, ' ' )
    type = type:gsub( '^private: ', '' )
    type = type:gsub( '^protected: ', '' )
    type = type:gsub( '^public: ', '' )
  else
    comment = 'failed to parse markdown: ' .. markdown
  end
  type = type:gsub( '%s+', ' ' )
  if type:match( '//' ) then
    comment = type:match( '[^/]*//(.*)' )
    type = type:match( '([^/]*)//.*' )
  end
  if comment then
    comment = comment:gsub( '//', '' )
    comment = comment:gsub( '%s+', ' ' )
    comment = trim( comment )
  end
  type = trim( type )
  return type, comment
end

colors.hl_setter( 'ClangdLspExtColors', function( hi )
  local P = palette.colors
  hi.ClangdLspType = { fg=P.neutral_aqua, bold=BOLD }
end )

local function print_colored_type( type, comment )
  local msg = '{{ClangdLspType}}type{{Operator}}: {{Normal}}'
  msg = msg .. type
  if comment then
    msg = msg .. format( '{{Comment}}; // %s.', comment )
  end
  color_message( msg )
end

-----------------------------------------------------------------
-- GetType
-----------------------------------------------------------------
function M.GetType()
  with_errors_to_messages( function()
    with_cmdheight( print_colored_type, get_type_under_cursor() )
  end )
end

function M.type_under_cursor() return get_type_under_cursor() end

-----------------------------------------------------------------
-- Finished.
-----------------------------------------------------------------
return M
