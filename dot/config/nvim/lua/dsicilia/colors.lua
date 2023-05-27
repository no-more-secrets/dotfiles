-----------------------------------------------------------------
-- Miscellaneous color-relating things.
-----------------------------------------------------------------
local M = {}

-----------------------------------------------------------------
-- Aliases.
-----------------------------------------------------------------
local autocmd = vim.api.nvim_create_autocmd

-- Takes a highlight group and clones it but makes the foreground
-- text bright bold white.
function M.clone_hl( template, new_hl, modifier_fn )
  local existing = vim.api.nvim_get_hl( 0, { name=template } )
  if modifier_fn then modifier_fn( existing ) end
  vim.api.nvim_set_hl( 0, new_hl, existing )
end

local function make_comments_italic()
  M.clone_hl( 'Comment', 'Comment', function( opts )
    opts.italic = true
  end )
end

autocmd( 'ColorScheme', { callback = make_comments_italic } )

-----------------------------------------------------------------
-- Finished.
-----------------------------------------------------------------
return M
