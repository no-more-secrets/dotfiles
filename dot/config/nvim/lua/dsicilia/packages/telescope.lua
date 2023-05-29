-----------------------------------------------------------------
-- Package: telescope
-----------------------------------------------------------------

-----------------------------------------------------------------
-- Imports.
-----------------------------------------------------------------
local mappers = require( 'dsicilia.mappers' )
local telescope = require( 'telescope' )
local builtin = require( 'telescope.builtin' )
local actions = require( 'telescope.actions' )
local colors = require( 'dsicilia.colors' )

-----------------------------------------------------------------
-- Aliases
-----------------------------------------------------------------
local nmap, vmap = mappers.nmap, mappers.vmap

-----------------------------------------------------------------
-- Setup/extensions.
-----------------------------------------------------------------
telescope.setup {
  defaults = {
    layout_config = {
      mirror = false,
      prompt_position = 'top',
      scroll_speed = 1,
      --vertical = { width = 0.5 }
      -- other layout configuration here
    },

    -- More relevant results are placed at the top of the results
    -- window.
    sorting_strategy = 'ascending',

    mappings = {
      i = {
        -- Shows the mappings for your picker.
        ['<C-h>'] = actions.which_key,
        ['<C-j>'] = actions.move_selection_next,
        ['<C-k>'] = actions.move_selection_previous,
        ['<C-u>'] = actions.preview_scrolling_down,
        ['<C-i>'] = actions.preview_scrolling_up,
        -- Comment this out for the default behavior, which is
        -- that the input line in telescope uses a vim modal
        -- style with vim key bindings in normal mode, but you
        -- can only get to normal mode by hitting escape. Here,
        -- we have escape configured to just close the window;
        -- otherwise, it would take you into normal mode.
        ['<ESC>'] = actions.close,
      }
    }
  },
}

-- Use fzf as the sorter.
telescope.load_extension( 'fzf' )

-----------------------------------------------------------------
-- Colors.
-----------------------------------------------------------------
colors.hl_setter( 'Telescope', function( hi )
  local GRUVBOX_NEUTRAL_BLUE = '#458588'
  hi.TelescopeBorder    = { fg=GRUVBOX_NEUTRAL_BLUE }
  hi.TelescopeSelection = { bg=GRUVBOX_NEUTRAL_BLUE }
end )

-----------------------------------------------------------------
-- Keymaps.
-----------------------------------------------------------------
-- NOTE: the LSP pickers are mapped to keys in the LSP module.
--
-- The 't' stands for "Telescope".

-- If you don't remember all of the builtin pickers or don't have
-- one mapped, then you just have to remember this one. It will
-- show a list of all builtin pickers, allow you to pick one,
-- then will run that picker.
nmap['<leader>t?'] = builtin.builtin

-- General.
nmap['<C-t>']      = builtin.find_files -- under cwd
nmap['<leader>tt'] = function() builtin.find_files{ cwd='~' } end
nmap['<leader>ta'] = builtin.live_grep
nmap['<leader>tA'] = function() builtin.live_grep{ cwd='~' } end
nmap['<leader>tb'] = builtin.buffers
nmap['<leader>tw'] = builtin.grep_string
-- FIXME: this one is supposed to search for the highlighted
-- text, but doesn't seem to work.
vmap['<leader>tw'] = builtin.grep_string
nmap['<leader>t/'] = builtin.current_buffer_fuzzy_find

-- Help tags.
nmap['<leader>th'] = builtin.help_tags

-- Git specific.
nmap['<leader>tg'] = builtin.git_files -- all files in repo.
nmap['<leader>ts'] = builtin.git_status -- changed files.

-- Commands.
nmap['<leader>tc'] = builtin.commands
