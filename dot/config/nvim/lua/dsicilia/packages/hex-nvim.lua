-----------------------------------------------------------------
-- Package: hex-nvim
-----------------------------------------------------------------
local M = {}

-----------------------------------------------------------------
-- Imports.
-----------------------------------------------------------------
local hex = require( 'hex' )

-----------------------------------------------------------------
-- Aliases.
-----------------------------------------------------------------
local lower = string.lower

-----------------------------------------------------------------
-- Constants.
-----------------------------------------------------------------
-- These will only be tested against lowercase'd strings.
local BINARY_EXTS = {
  'sav', 'out', 'bin', 'png', 'jpg', 'jpeg', 'exe', 'dll',
}

-----------------------------------------------------------------
-- Config.
-----------------------------------------------------------------
hex.setup{

  -- cli command used to dump hex data
  dump_cmd='xxd -g2 -c 16',

  -- cli command used to assemble from hex data
  assemble_cmd='xxd -r',

  -- Function that runs on BufReadPre to determine if it's binary
  -- or not.
  is_file_binary_pre_read=function()
    -- Only work on normal buffers.
    if vim.bo.ft ~= '' then return false end

    -- Check -b flag.
    if vim.bo.bin then return true end

    -- local filename = vim.fn.expand( '%:t' )

    -- Check extension.
    local ext = lower( vim.fn.expand( '%:e' ) )
    if vim.tbl_contains( BINARY_EXTS, ext ) then return true end

    -- None of the above.
    return false
  end,

  -- Function that runs on BufReadPost to determine if it's bi-
  -- nary or not.
  is_file_binary_post_read=function()
    local encoding = (vim.bo.fenc ~= '' and vim.bo.fenc) or
                         vim.o.enc
    if encoding ~= 'utf-8' then return true end
    return false
  end,
}

-----------------------------------------------------------------
-- Finished.
-----------------------------------------------------------------
return M
