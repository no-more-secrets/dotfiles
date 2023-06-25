-----------------------------------------------------------------
-- Package: nvim-scrollbar.
-----------------------------------------------------------------
local scrollbar = require( 'scrollbar' )
local search = require( 'scrollbar.handlers.search' )
local gitsigns = require( 'scrollbar.handlers.gitsigns' )
local colors = require( 'dsicilia.colors' )
local palette = require( 'gruvbox.palette' )

-----------------------------------------------------------------
-- Colors.
-----------------------------------------------------------------
colors.hl_setter( 'ScrollbarColors', function( hi )
  local P = palette.colors
  -- local B = palette.get_base_colors( 'dark' )
  hi.ScrollbarHandle = { bg=P.dark4 }
end )

-----------------------------------------------------------------
-- Setup.
-----------------------------------------------------------------
scrollbar.setup{
  show=true,
  show_in_active_only=false,
  set_highlights=true,
  hide_if_all_visible=false, -- Hides everything if all lines are visible
  handle={
    text=' ',
    blend=50, -- 0 for fully opaque and 100 to full transparent.
    highlight='ScrollbarHandle',
    hide_if_all_visible=true, -- Hides handle if all lines are visible
  },
  handlers={
    cursor=false, -- would show dot at cursor location.
    diagnostic=true,
    gitsigns=true, -- Requires gitsigns
    handle=true,
    search=true, -- Requires hlslens
  },
}

-- Show marks representing search results in the scrollbar.
search.setup{}

-- Show marks representing git changes in the scrollbar.
gitsigns.setup()
