-----------------------------------------------------------------
-- Package: comment.nvim
-----------------------------------------------------------------
-----------------------------------------------------------------
-- Imports.
-----------------------------------------------------------------
local mappers = require( 'dsicilia.mappers' )

-----------------------------------------------------------------
-- Aliases.
-----------------------------------------------------------------
local nmap, vmap = mappers.nmap, mappers.vmap

-----------------------------------------------------------------
-- Setup.
-----------------------------------------------------------------
require( 'Comment' ).setup{
  -- Add a space b/w comment and the line
  padding=true,

  -- Whether the cursor should stay at its position
  sticky=true,

  -- LHS of toggle mappings in NORMAL mode.
  toggler={
    -- Overrides the <leader>cl mapping in `oploader` for
    -- normal mode.
    line='<leader>cl', -- Line-comment toggle keymap.
    -- We don't enable this here, since then this would over-
    -- ride the <leader>cs mapping in normal mode (overriding
    -- the same one that we have in `opleader`), but it doesn't
    -- really make sense to toggle a block comment without
    -- specifying a region, so we just let <leader>cs handle
    -- the `opleader` case, which will either have a region (in
    -- visual mode) or will ask for a region.
    -- block = '',
  },

  -- Operator-pending mappings in NORMAL and VISUAL mode. When
  -- in normal mode they will wait for a motion command to de-
  -- fine the region. When in visual mode they will just use
  -- the selected region. are the ones that require some motion
  -- after them to define the region of commenting. The 'm'
  -- stands for 'motion'.
  opleader={
    -- This is the same mapping as in the `toggler` section, so
    -- it will only be used in visual mode.
    line='<leader>cl',
    -- In visual mode will block-comment the selected region,
    -- otherwise will wait for a motion key.
    block='<leader>cs',
  },

  -- Extra mappings.
  extra={
    above='<leader>cO', -- Add comment on the line above.
    below='<leader>co', -- Add comment on the line below.
    eol='<leader>cA', -- Add comment at the end of line.
  },

  -- Enable keybindings. Note: If given `false` then the plugin
  -- won't create any mappings
  mappings={ line=false, block=false },

  ---Function to call before (un)comment.
  pre_hook=nil,

  ---Function to call after (un)comment.
  post_hook=nil,
}

-- This is to try to reproduce the behavior of NERDCommenter that
-- we are used to. TODO: these should probably eventually be re-
-- moved after we stop using the `u` mappings, which are really
-- not necessary as the above mappings are all toggles.
nmap['<leader>cu'] = '<Plug>(comment_toggle_linewise_current)'
vmap['<leader>cu'] = '<Plug>(comment_toggle_linewise_visual)'
