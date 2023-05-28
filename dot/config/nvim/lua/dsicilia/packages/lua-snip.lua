-----------------------------------------------------------------
-- Package: luasnip
-----------------------------------------------------------------

-----------------------------------------------------------------
-- Imports.
-----------------------------------------------------------------
local ls = require( 'luasnip' )
local mappers = require( 'dsicilia.mappers' )

-----------------------------------------------------------------
-- Aliases.
-----------------------------------------------------------------
local imap = mappers.imap

-----------------------------------------------------------------
-- Setup.
-----------------------------------------------------------------
ls.config.setup {
  history = true,
  updateevents = 'TextChanged,TextChangedI',
  enable_autosnippets = true,
}

-----------------------------------------------------------------
-- Keymaps.
-----------------------------------------------------------------
imap['<C-o>'] = function()
  if ls.expand_or_jumpable() then ls.expand_or_jump() end
end

imap['<C-p>'] = function()
  if ls.jumpable( -1 ) then ls.jump( -1 ) end
end

-----------------------------------------------------------------
-- Load snippets.
-----------------------------------------------------------------
local SNIPPETS_FOLDER = '~/.config/nvim/lua/dsicilia/snippets'

-- There are a couple of ways to add snippets with LuaSnip; the
-- one we're doing is to store them in separate files, repre-
-- sented in Lua, and then load them per file type. The docs for
-- this method are here:
--
--   https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md#lua
--
-- NOTE: it appears that the plugin will watch for any changes to
-- those files an automatically pick them up, so if you add a
-- snippet in the future then you don't have to source the file
-- or reload the editor.
require( "luasnip.loaders.from_lua" ).load{ paths=SNIPPETS_FOLDER }
