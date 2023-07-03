-----------------------------------------------------------------
-- Package: treesitter-playground.
-----------------------------------------------------------------
-----------------------------------------------------------------
-- Setup.
-----------------------------------------------------------------
require'nvim-treesitter.configs'.setup{
  playground={
    enable=true,
    disable={},
    -- Debounced time for highlighting nodes in the playground
    -- from source code
    updatetime=25,
    -- Whether the query persists across vim sessions
    persist_queries=false,
    keybindings={
      toggle_query_editor='o',
      toggle_hl_groups='i',
      toggle_injected_languages='t',
      toggle_anonymous_nodes='a',
      toggle_language_display='I',
      focus_language='f',
      unfocus_language='F',
      update='R',
      goto_node='<cr>',
      show_help='?',
    },
  },
}
