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
local BOLD = config.bold

-- Setup must be called before loading the colorscheme.
gruvbox.setup( {
  italic={
    strings=false,
    comments=true,
    operators=false,
    folds=true,
  },
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
    Todo={ fg=P.light0, bg=C.bg0, bold=BOLD },
  },
} )

-- Need to do this after calling setup I believe.
vim.o.background = BACKGROUND
vim.cmd.colorscheme'gruvbox'
