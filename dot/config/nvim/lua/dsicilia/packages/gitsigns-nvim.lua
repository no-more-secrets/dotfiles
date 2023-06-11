-----------------------------------------------------------------
-- Package: gitsigns.
-----------------------------------------------------------------
-----------------------------------------------------------------
-- Imports.
-----------------------------------------------------------------
local gitsigns = require( 'gitsigns' )
local colors = require( 'dsicilia.colors' )
local mappers = require( 'dsicilia.mappers' )
local win = require( 'dsicilia.win' )
local status_bar = require( 'dsicilia.status-bar' )

-----------------------------------------------------------------
-- Aliases.
-----------------------------------------------------------------
local hl_setter = colors.hl_setter
local modify_hl = colors.modify_hl

-----------------------------------------------------------------
-- Helpers.
-----------------------------------------------------------------
-- This allows us to open and close the preview window with the
-- same key binding. Otherwise we'd have to close it by pressing
-- one of the motion keys which moves the cursor.
local function toggle_preview()
  local n_closed = win.close_all_floating_windows()
  if n_closed > 0 then return end
  gitsigns.preview_hunk()
end

-----------------------------------------------------------------
-- Setup.
-----------------------------------------------------------------
gitsigns.setup{
  signs={
    add={ text='│' },
    change={ text='│' },
    delete={ text='_' },
    topdelete={ text='‾' },
    changedelete={ text='~' },
    untracked={ text='┆' },
  },
  signcolumn=true, -- Toggle with `:Gitsigns toggle_signs`.
  numhl=true, -- Toggle with `:Gitsigns toggle_numhl`.
  linehl=false, -- Toggle with `:Gitsigns toggle_linehl`.
  word_diff=false, -- Toggle with `:Gitsigns toggle_word_diff`.
  watch_gitdir={ interval=1000, follow_files=true },
  attach_to_untracked=true,
  current_line_blame=true,
  current_line_blame_opts={
    virt_text=true,
    virt_text_pos='eol', -- 'eol' | 'overlay' | 'right_align'.
    delay=1000,
    ignore_whitespace=false,
  },
  current_line_blame_formatter='<author>, <author_time:%Y-%m-%d> - <summary>',
  sign_priority=6,
  update_debounce=100,
  status_formatter=nil, -- Use default
  -- Disable if file is longer than this in lines.
  max_file_length=40000,
  preview_config={
    -- Options passed to nvim_open_win
    border='single',
    style='minimal',
    relative='cursor',
    row=0,
    col=1,
  },

  on_attach=function( bufnr )
    -- Redraw status bar, since it will give us the branch.
    status_bar.rebuild_for_buffer( bufnr )

    local opts = { buffer=bufnr }
    local nmap = mappers.build_mapper( 'n', opts )
    local vmap = mappers.build_mapper( 'v', opts )

    local gs = gitsigns

    nmap['<leader>gn'] = gs.next_hunk
    nmap['<leader>gk'] = gs.prev_hunk

    -- Changes.
    nmap['<leader>gr'] = gs.reset_hunk -- Revert unstaged changes.
    nmap['<leader>gR'] = gs.reset_buffer

    -- Staging.
    nmap['<leader>gs'] = gs.stage_hunk
    nmap['<leader>gS'] = gs.stage_buffer
    vmap['<leader>gs'] = function()
      gs.stage_hunk{ vim.fn.line( '.' ), vim.fn.line( 'v' ) }
    end
    vmap['<leader>gr'] = function()
      gs.reset_hunk{ vim.fn.line( '.' ), vim.fn.line( 'v' ) }
    end
    nmap['<leader>gu'] = gs.undo_stage_hunk

    -- Getting info.
    nmap['<leader>gd'] = gs.toggle_deleted
    nmap['<leader>gp'] = toggle_preview
    nmap['<leader>gD'] = gs.diffthis
    nmap['<leader>gb'] =
        function() gs.blame_line{ full=true } end
  end,
}

-----------------------------------------------------------------
-- Colors.
-----------------------------------------------------------------
hl_setter( 'GitSigns', function( _ )
  modify_hl( 'GitSignsAdd', function( g ) g.bg = nil end )
  modify_hl( 'GitSignsDelete', function( g ) g.bg = nil end )
  modify_hl( 'GitSignsChange', function( g ) g.bg = nil end )
  modify_hl( 'GitSignsUntracked', function( g ) g.bg = nil end )
end )
