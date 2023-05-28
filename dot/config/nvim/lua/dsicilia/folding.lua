-----------------------------------------------------------------
--                           Folding
-----------------------------------------------------------------
local M = {}

-----------------------------------------------------------------
--                           Aliases
-----------------------------------------------------------------
local getline = vim.fn.getline
local format = string.format

-----------------------------------------------------------------
--                           Options
-----------------------------------------------------------------
-- Fold based on the syntax of the language in question.
vim.o.foldmethod = 'syntax'
-- Don't initially fold anything.
vim.o.foldlevel = 1000

local MAX_FOLD_LENGTH = 65

function M.fold_text_gen()
  local linetext = getline( vim.v.foldstart )
  local rm_if_last_char = function( char )
    local last_char = linetext:sub( #linetext )
    if last_char ~= char then return end
    linetext = linetext:sub( 1, #linetext - 1 )
  end
  -- If the line ends with a { then strip it off since we'll be
  -- adding one manually in the fold line text below. Then, if
  -- the line ends with a space then strip it off (it might since
  -- we just stripped a curly brace).
  rm_if_last_char( '{' )
  rm_if_last_char( ' ' )
  local num_lines_folded = vim.v.foldend - vim.v.foldstart
  local FMT = '%s { --- %d lines folded --- }'
  -- If necessary, trim some more from the end of linetext so
  -- that the entire formatted fold string fits into our desired
  -- line width.
  do
    local longest = format( FMT, linetext, num_lines_folded )
    local extra_chars = #longest - MAX_FOLD_LENGTH
    if extra_chars > 0 then
      linetext = linetext:sub( 1, #linetext - extra_chars )
    end
  end
  return format( FMT, linetext, num_lines_folded )
end

-- The 'foldtext' option is an option that takes a string con-
-- taining a vimscript expression that is then executed to yield
-- another string that will be the fold line string. So we need a
-- vimscript expression that runs our lua function above each
-- time it is evaluated.
vim.o.foldtext =
    [[luaeval( 'require( "dsicilia.folding" ).fold_text_gen()' )]]

return M