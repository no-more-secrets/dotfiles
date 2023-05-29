-----------------------------------------------------------------
-- Auto-formatting.
-----------------------------------------------------------------
local M = {}

-----------------------------------------------------------------
-- Imports.
-----------------------------------------------------------------
local mappers = require( 'dsicilia.mappers' )

-----------------------------------------------------------------
-- Aliases.
-----------------------------------------------------------------
local nmap = mappers.nmap
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-----------------------------------------------------------------
-- Functions.
-----------------------------------------------------------------
local function autoformat()
  local ft = vim.o.ft
  if not ft then return end

  -- Neoformat is a plugin that can take an external formatter
  -- and use it to format the buffer in a way that plays nice
  -- with vim in general. It has out of the box support for many
  -- common formatters for many languages, so we may want to add
  -- new formatters using Neoformat. That said, the LSP also has
  -- a formatting function that we want to use in some cases.

  if ft == 'lua' then
    -- At the time of writing, the language server that we use
    -- for Lua does support foramtting, but it doesn't seem to
    -- allow us to control the formatter, so we use Neoformat.
    vim.cmd.Neoformat( 'luaformat' )
    return
  end

  -- Else, just format if there is a language server client at-
  -- tached to the current buffer and it can format.
  local bufnr = vim.fn.bufnr()
  local clients = vim.lsp.get_active_clients{ bufnr=bufnr }
  for _, client in ipairs( clients ) do
    if client.server_capabilities.documentFormattingProvider then
      vim.lsp.buf.format()
      return
    end
  end
end

-----------------------------------------------------------------
-- Global settings.
-----------------------------------------------------------------
vim.g.neoformat_only_msg_on_error = 1

-----------------------------------------------------------------
-- Keymaps.
-----------------------------------------------------------------
nmap['<C-c>'] = autoformat

-----------------------------------------------------------------
-- Format-on-save.
-----------------------------------------------------------------
-- We don't enable format-on-save by default because we wouldn't
-- want that to be done universally, since sometimes we are
-- editing files that are not normally formatted and/or that we
-- don't really own, and that probably don't have formatting
-- config files in their parent folders.
--
-- So, we provide this API for enabling format-on-save which al-
-- lows 1) opting in, and 2) allows providing a callback function
-- to filter the files that are actually formatted based on path.
function M.enable_autoformat_on_save( filter_fn )
  autocmd( 'BufWritePre', {
    group=augroup( 'AutoFormatOnSave', { clear=true } ),
    callback=function()
      if filter_fn then
        local bufnr = vim.fn.bufnr()
        local abs_file_path = vim.fn.getbufinfo( bufnr )[1].name
        if not filter_fn( abs_file_path ) then return end
      end
      autoformat()
    end,
  } )
end

-----------------------------------------------------------------
-- Finished.
-----------------------------------------------------------------
return M
