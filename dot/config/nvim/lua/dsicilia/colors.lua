-----------------------------------------------------------------
-- Miscellaneous color-relating things.
-----------------------------------------------------------------
local M = {}

-----------------------------------------------------------------
-- Aliases.
-----------------------------------------------------------------
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-----------------------------------------------------------------
-- Highlight group manipulation.
-----------------------------------------------------------------
local hi = setmetatable( {}, {
  __newindex=function( _, hi_name, value )
    vim.api.nvim_set_hl( 0, hi_name, value )
  end,
} )

-- This captures a common pattern that frequently arises when we
-- are setting highlight groups: given a function that does the
-- job, we want to call it, and then schedule it to be called
-- whenever the colorscheme changes.
function M.hl_setter( label, setter )
  assert( label )
  assert( setter )
  setter( hi )
  autocmd( 'ColorScheme', {
    group=augroup( label .. 'ColorScheme', { clear=true } ),
    callback=function() setter( hi ) end,
  } )
end

-----------------------------------------------------------------
-- Italic comments.
-----------------------------------------------------------------
-- Takes a highlight group and clones it but makes the foreground
-- text bright bold white.
function M.clone_hl( template, new_hl, modifier_fn )
  local existing = vim.api.nvim_get_hl( 0, { name=template } )
  if modifier_fn then modifier_fn( existing ) end
  vim.api.nvim_set_hl( 0, new_hl, existing )
end

M.hl_setter( 'CommentsItalic', function( _ )
  M.clone_hl( 'Comment', 'Comment',
              function( opts ) opts.italic = true end )
end )

-----------------------------------------------------------------
-- Finished.
-----------------------------------------------------------------
return M
