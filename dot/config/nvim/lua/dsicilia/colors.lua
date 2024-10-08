-----------------------------------------------------------------
-- Miscellaneous color-relating things.
-----------------------------------------------------------------
local M = {}

-----------------------------------------------------------------
-- Imports.
-----------------------------------------------------------------
local table_util = require( 'dsicilia.table-util' )

-----------------------------------------------------------------
-- Aliases.
-----------------------------------------------------------------
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local nvim_get_hl = vim.api.nvim_get_hl
local nvim_set_hl = vim.api.nvim_set_hl
local format = string.format

-----------------------------------------------------------------
-- Message box in color.
-----------------------------------------------------------------
-- This will print a fragment (no newline) to the message box
-- with a highlight color, e.g. echo_hi( 'Comment', 'hello' ).
local function echon_hi( hi, msg )
  vim.cmd.echohl( hi )
  msg = msg:gsub( '"', [[\"]] )
  vim.cmd.echon( '"' .. msg .. '"' ) -- echo w/ no newline.
end

-- Find the last instance of `divider` and return all the text
-- before and after it.
local function either_side( str, l, r )
  return str:match( format( '(.*)%s(.*)%s(.*)', l, r ) )
end

local function parse_color_msg( msg )
  local res = {}
  local function add( hi, txt )
    table.insert( res, { hi=hi, txt=txt } )
  end
  while true do
    local pre, hi, txt = either_side( msg, '{{', '}}' )
    if not pre then
      if #msg > 0 then add( 'Normal', msg ) end
      return table_util.reversed( res )
    end
    add( hi, txt )
    msg = pre
  end
end

-- Example:
--
--    color_message( 'Hello, {{ErrorMsg}}%s{{Normal}}!!!', name )
--
function M.color_message( ... )
  local msg = format( ... )
  -- FIXME: this first blank echo is needed to work around a
  -- strange bug that happens in cmdheight=0 mode where occasion-
  -- ally, in this function, the first echo statement prints as
  -- all spaces.
  msg = '{{Normal}} ' .. msg
  -- This is so that we don't leave the message box in a colored
  -- state.
  msg = msg .. '{{Normal}}'
  local tbl = parse_color_msg( msg )
  for _, segment in ipairs( tbl ) do
    echon_hi( segment.hi, segment.txt )
  end
end

-----------------------------------------------------------------
-- Highlight group manipulation.
-----------------------------------------------------------------
-- This captures a common pattern that frequently arises when we
-- are setting highlight groups: given a function that does the
-- job, we want to call it, and then schedule it to be called
-- whenever the colorscheme changes.
function M.hl_setter( label, setter )
  assert( label )
  assert( setter )
  local hi = setmetatable( {}, {
    __newindex=function( _, hi_name, value )
      nvim_set_hl( 0, hi_name, value )
    end,
  } )
  -- We need to run the function here once just in case the col-
  -- orscheme has already been set by the time this code runs, in
  -- which case the auto command below won't trigger.
  setter( hi )
  autocmd( 'ColorScheme', {
    group=augroup( label .. 'ColorScheme', { clear=true } ),
    callback=function() setter( hi ) end,
  } )
end

-- Resolves links in highlight groups.
local function get_resolved_hl( name )
  local hl = nvim_get_hl( 0, { name=name } )
  while hl.link do hl = nvim_get_hl( 0, { name=hl.link } ) end
  return hl
end

-- Takes a highlight group and clones it and optionally allows
-- for a function to modify the new version.
function M.clone_hl( template, new_hl, modifier_fn )
  local existing = get_resolved_hl( template )
  if modifier_fn then modifier_fn( existing ) end
  nvim_set_hl( 0, new_hl, existing )
end

function M.modify_hl( name, modifier_fn )
  M.clone_hl( name, name, assert( modifier_fn ) )
end

-----------------------------------------------------------------
-- Setter.
-----------------------------------------------------------------
M.hl_setter( 'ColorsGeneral', function( _ )
  -- Prevents ~ (tildes) from appearing on post-buffer lines by
  -- making them the same color as the background. The string
  -- value 'bg', when given to the function nvim_set_hl, acts as
  -- alias for the background color of the normal group.
  M.modify_hl( 'EndOfBuffer', function( g ) g.fg = 'bg' end )
end )

-----------------------------------------------------------------
-- Finished.
-----------------------------------------------------------------
return M
