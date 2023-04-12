-----------------------------------------------------------------
--                           Options
-----------------------------------------------------------------
-- Utils
-- ==============================================================
local function has( what ) return vim.call( 'has', what ) end

-- Encoding
-- ==============================================================
vim.o.enc = 'utf-8'
vim.o.fenc = 'utf-8'
vim.o.termencoding = 'utf-8'
vim.o.t_Co = '256'

-- Spacing
-- ==============================================================
vim.o.wrap = false
vim.o.sw = 2
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.expandtab = true
vim.o.fixeol = false
vim.o.eol = false
vim.o.textwidth = 65

vim.o.backspace = 'indent,eol,start'

-- Window Layout/Appearance
-- ==============================================================
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.number = true -- turn line numbers on
vim.o.relativenumber = true -- line number deltas
vim.o.cursorline = true
vim.o.cursorlineopt = 'number'
-- This sets the window pane divider char to empty, instead of
-- the default pipe char.
vim.o.fillchars = 'vert: '
-- Don't show a preview window when autocompleting.
vim.opt.completeopt:remove( 'preview' )

-- This disables the intro message that appears when vim starts.
vim.o.shortmess = 'I'

-- This will cause the error signs to appear over the line num-
-- bers instead of putting them in the 'gutter' and taking up an
-- extra line of horizontal space.
vim.o.signcolumn = 'number'

vim.o.sidescroll = 1

if has( 'nvim' ) then
  -- TODO: When neovim releases this uncomment it.
  -- vim.o.cmdheight = 0
end

-- Detect if we are in diff mode.
if vim.o.diff then vim.o.cmdheight = 2 end

-- Colors
-- ==============================================================
if has( 'termguicolors' ) then
  -- Set 24-bit 'True Color' if supported.
  vim.o.termguicolors = true
end

-- Syntax Highlighting
-- ==============================================================
vim.o.syntax = 'on'

-- Highlight matching braces.
vim.o.showmatch = true

-- Format Options
-- ==============================================================
-- Don't auto-wrap text.
vim.opt.formatoptions:remove( 't' )
-- Auto-wrap comments using textwidth, inserting the current com-
-- ment leader automatically.
vim.opt.formatoptions:append( 'c' )
-- Where it makes sense, remove a comment leader when joining
-- lines.
vim.opt.formatoptions:append( 'j' )
-- Don't break lines at single spaces that follow periods.
vim.opt.formatoptions:append( 'p' )
-- Don't break a line after a one-letter word (do it before).
vim.opt.formatoptions:append( '1' )
-- Long lines are broken in insert mode.
vim.opt.formatoptions:remove( 'l' )
-- Don't automatically insert the current comment leader after
-- hitting 'o' or 'O' in Normal mode.
vim.opt.formatoptions:remove( 'o' )
-- Automatically insert the current comment leader after hitting
-- <Enter> in Insert mode.
vim.opt.formatoptions:append( 'r' )

-- Searching
-- ==============================================================
vim.o.hlsearch = true
vim.o.incsearch = true -- Ignore case when searching (\c).
vim.o.ignorecase = true -- Ignore case unless there is a cap.
vim.o.smartcase = true

-- Mouse
-- ==============================================================
vim.o.mouse = 'a'

-- Clipboard
-- ==============================================================
-- If vim has clipboard support then just use that by default for
-- yanking.
if has( 'clipboard' ) then vim.o.clipboard = 'unnamed' end

-- Security
-- ==============================================================
-- Do not allow unsafe commands (such as shell commands) in
-- project-specific vimrc files.
vim.o.secure = true
