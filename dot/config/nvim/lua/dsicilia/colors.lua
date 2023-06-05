-----------------------------------------------------------------
-- Miscellaneous color-relating things.
-----------------------------------------------------------------
local M = {}

-----------------------------------------------------------------
-- Aliases.
-----------------------------------------------------------------
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local nvim_get_hl = vim.api.nvim_get_hl
local nvim_set_hl = vim.api.nvim_set_hl

-----------------------------------------------------------------
-- Message box in color.
-----------------------------------------------------------------
-- This will print a fragment (no newline) to the message box
-- with a highlight color, e.g. echo_hi( 'Comment', 'hello' ).
function M.echon_hi( hi, msg )
  vim.cmd.echohl( hi )
  msg = msg:gsub( '"', [[\"]] )
  vim.cmd.echon( '"' .. msg .. '"' ) -- echo w/ no newline.
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

-- Fill in any nil fields, which will implicitly take on their
-- default values, which can be obtained from the 'Normal' group.
-- This makes it easier for people since they can e.g. check the
-- .fg field and assume that it always has a value.
local function populate_hl_defaults( g )
  local normal = nvim_get_hl( 0, { name='Normal' } )
  for k, v in pairs( normal ) do if not g[k] then g[k] = v end end
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
  -- making them the same color as the background.
  M.modify_hl( 'EndOfBuffer', function( g )
    -- This is so that g.bg won't be nil.
    populate_hl_defaults( g )
    g.fg = g.bg
  end )
end )

-----------------------------------------------------------------
-- Finished.
-----------------------------------------------------------------
return M
