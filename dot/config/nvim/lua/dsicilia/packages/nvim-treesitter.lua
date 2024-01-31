-----------------------------------------------------------------
-- Package: nvim-treesitter
-----------------------------------------------------------------
-----------------------------------------------------------------
-- Imports.
-----------------------------------------------------------------
local work = require( 'dsicilia.work' )

-----------------------------------------------------------------
-- Aliases.
-----------------------------------------------------------------
local nvim_buf_get_name = vim.api.nvim_buf_get_name

-----------------------------------------------------------------
-- Setup.
-----------------------------------------------------------------
if work.iscit() then
  -- This might be slower, but otherwise tree-sitter will try to
  -- use curl to download the parsers which won't work in all of
  -- our environments.
  require( 'nvim-treesitter.install' ).prefer_git = true
end

local DISABLE = {
  -- cpp=true,
  -- lua=true,
}

require( 'nvim-treesitter.configs' ).setup{
  -- A list of parser names, or "all".
  ensure_installed={
    'c', 'cpp', 'lua', 'vim', 'vimdoc', 'query', 'glsl',
    'haskell', 'awk', 'bash', 'cmake', 'diff', 'fish',
    'git_config', 'gitignore', 'gitcommit', 'html', 'ini',
    'java', 'json', 'passwd', 'python', 'regex', 'rust', 'sql',
    'toml', 'yaml', 'make', 'markdown', 'ninja', 'comment',
    'luap',
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

  highlight={
    enable=true,
    -- disable = DISABLE,
    disable=function( lang, buf )
      if DISABLE[lang] then return true end
      local max_filesize = 1024 * 1024 -- 1MB
      local ok, stats = pcall( vim.loop.fs_stat,
                               nvim_buf_get_name( buf ) )
      if ok and stats and stats.size > max_filesize then
        return true
      end
    end,
  },
}
