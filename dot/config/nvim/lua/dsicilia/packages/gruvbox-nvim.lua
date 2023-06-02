-----------------------------------------------------------------
-- Package: gruvbox.nvim
-----------------------------------------------------------------
local gruvbox = require( 'gruvbox' )
local palette = require( 'gruvbox.palette' )

local BACKGROUND = 'dark'

local config = gruvbox.config

-- See ~/.local/.../gruvbox.nvim/lua/gruvbox/palette.lua.
local P = palette.colors
local C = palette.get_base_colors( BACKGROUND )

local INVERT = config.invert_signs

-- Setup must be called before loading the colorscheme.
gruvbox.setup( {
  undercurl=true,
  underline=true,
  bold=true,
  italic={
    strings=false,
    comments=true,
    operators=false,
    folds=true,
  },
  strikethrough=true,
  invert_selection=false,
  invert_signs=false,
  invert_tabline=false,
  invert_intend_guides=false,
  inverse=true, -- invert background for search, diffs, statuslines and errors
  contrast='', -- can be "hard", "soft" or empty string
  dim_inactive=false,
  transparent_mode=false,
  palette_overrides={
    -- This is so that the background of vim matches the back-
    -- ground of our terminal.
    dark0='#262626',
  },
  overrides={
    WinSeparator={ bg=C.bg1 },
    TabLineFill={ fg=P.light4, bg=C.bg1, reverse=INVERT },
    TabLineSel={ fg=P.light1, bg=P.faded_orange },
    CursorLineNr={ fg=C.yellow, bg=C.bg0 },
    Function={ fg=C.green },
    String={ fg=C.neutral_green },
  },
} )

-- Need to do this after calling setup I believe.
vim.o.background = BACKGROUND
vim.cmd.colorscheme'gruvbox'
