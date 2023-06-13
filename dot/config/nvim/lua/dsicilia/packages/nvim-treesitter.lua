-----------------------------------------------------------------
-- Package: nvim-treesitter
-----------------------------------------------------------------

-----------------------------------------------------------------
-- Imports.
-----------------------------------------------------------------
local work = require( 'dsicilia.work' )

-----------------------------------------------------------------
-- Setup.
-----------------------------------------------------------------
if work.iscit() then
  -- This might be slower, but otherwise tree-sitter will try to
  -- use curl to download the parsers which won't work in all of
  -- our environments.
  require( 'nvim-treesitter.install' ).prefer_git = true
end

require( 'nvim-treesitter.configs' ).setup{
  -- A list of parser names, or "all".
  ensure_installed={
    'c', 'cpp', 'lua', 'vim', 'vimdoc', 'query', 'glsl',
    'haskell', 'awk', 'bash', 'cmake', 'diff', 'fish',
    'git_config', 'gitignore', 'gitcommit', 'html', 'ini',
    'java', 'json', 'passwd', 'perl', 'python', 'regex', 'rust',
    'sql', 'toml', 'yaml', 'make', 'markdown', 'ninja',
    'comment',
  },

  -- Install parsers synchronously (only applied to
  -- `ensure_installed`)
  sync_install=false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter`
  -- CLI installed locally
  auto_install=false,

  -- List of parsers to ignore installing (for "all").
  ignore_install={},

  highlight={ enable=true },
}
