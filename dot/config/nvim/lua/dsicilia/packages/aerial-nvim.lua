-----------------------------------------------------------------
-- Package: aerial.nvim.
-----------------------------------------------------------------
-----------------------------------------------------------------
-- Imports.
-----------------------------------------------------------------
local mappers = require( 'dsicilia.mappers' )

-----------------------------------------------------------------
-- Setup.
-----------------------------------------------------------------
require( 'aerial' ).setup( {
  -- Priority list of preferred backends for aerial.
  backends={ 'treesitter', 'lsp', 'markdown', 'man' },

  layout={
    -- These control the width of the aerial window. They can be
    -- integers or a float between 0 and 1 (e.g. 0.4 for 40%)
    -- min_width and max_width can be a list of mixed types.
    -- max_width = {40, 0.2} means "the lesser of 40 columns or
    -- 20% of total"
    max_width={ 40, 0.2 },
    width=nil,
    min_width=10,

    -- Determines the default direction to open the aerial win-
    -- dow. The 'prefer' options will open the window in the
    -- other direction *if* there is a different buffer in the
    -- way of the preferred direction Enum: prefer_right,
    -- prefer_left, right, left, float
    default_direction='right',

    -- Determines where the aerial window will be opened
    --   edge   - open aerial at the far right/left of the editor
    --   window - open aerial to the right/left of the current window
    placement='edge',

    -- Preserve window size equality with (:help CTRL-W_=).
    preserve_equality=false,
  },

  -- Determines how the aerial window decides which buffer to
  -- display symbols for.
  --   window - aerial window will display symbols for the buffer
  --            in the window from which it was opened
  --   global - aerial window will display symbols for the cur-
  --            rent window
  attach_mode='global',

  -- When true, don't load aerial until a command or function is
  -- called Defaults to true, unless `on_attach` is provided,
  -- then it defaults to false
  lazy_load=true,

  -- Disable aerial on files with this many lines.
  disable_max_lines=40000,

  -- Disable aerial on files this size or larger (in bytes).
  disable_max_size=10000000, -- Default 2MB

  -- A list of all symbols to display. Set to false to display
  -- all symbols. This can be a filetype map (see :help
  -- aerial-filetype-map) To see all available values, see :help
  -- SymbolKind
  filter_kind={
    'Class', 'Constructor', 'Enum', 'Function', 'Interface',
    'Module', 'Method', 'Struct',
  },

  -- Highlight the closest symbol if the cursor is not exactly on
  -- one.
  highlight_closest=true,

  -- Highlight the symbol in the source buffer when cursor is in
  -- the aerial win.
  highlight_on_hover=false,

  -- When jumping to a symbol, highlight the line for this many
  -- ms. Set to false to disable.
  highlight_on_jump=300,

  -- Control which windows and buffers aerial should ignore.
  -- Aerial will not open when these are focused, and existing
  -- aerial windows will not be updated.
  ignore={
    -- Ignore unlisted buffers. See :help buflisted.
    unlisted_buffers=false,
    -- List of filetypes to ignore.
    filetypes={},
  },

  -- Set default symbol icons to use patched font icons (see
  -- https://www.nerdfonts.com/) "auto" will set it to true if
  -- nvim-web-devicons or lspkind-nvim is installed.
  nerd_font='auto',

  -- Run this command after jumping to a symbol (false will dis-
  -- able)
  post_jump_cmd='normal! zz',

  -- Show box drawing characters for the tree hierarchy
  show_guides=true,

  -- Customize the characters used when show_guides = true
  guides={
    mid_item='├─', -- When the child item has a sibling below it.
    last_item='└─', -- When the child item is the last in the list.
    nested_top='│ ', -- When there are nested child guides to the right.
    whitespace='  ', -- Raw indentation.
  },
} )

-----------------------------------------------------------------
-- Keymaps.
-----------------------------------------------------------------
local nmap = mappers.nmap

-- Open the aerial window. With ! cursor stays in current window.
nmap['<leader>oo'] = '<cmd>AerialOpen<CR>'
nmap['<leader>oO'] = '<cmd>AerialOpen!<CR>'

-- AerialCloseAll: Close all visible aerial windows.
nmap['<leader>oc'] = '<cmd>AerialCloseAll<CR>'

-- AerialNavToggle:	Open or close the aerial nav window.
nmap['<leader>of'] = '<cmd>AerialNavToggle<CR>'
