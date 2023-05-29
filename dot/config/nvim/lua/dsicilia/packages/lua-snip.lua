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
ls.config.setup{
  history=true,
  updateevents='TextChanged,TextChangedI',
  enable_autosnippets=true,
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
-- Load lua snippets.
-----------------------------------------------------------------
-- NOTE: it appears that the plugin will watch for any changes to
-- those files an automatically pick them up, so if you add a
-- snippet in the future then you don't have to source the file
-- or reload the editor.
local SNIPPETS_FOLDER = '~/.config/nvim/lua/dsicilia/snippets'

-- This will load snippets from SnipMate files. This should be
-- the default way to store simple snippets, unless the more pow-
-- erful Lua method (below) is needed.
require( 'luasnip.loaders.from_snipmate' ).lazy_load{
  paths={ SNIPPETS_FOLDER .. '/snipmate' },
}

-- This will load snippets defined as strings (to be parsed) in-
-- side lua files. This method is the most flexible, but is more
-- difficult to use.  Most standard/simple snippets should be
-- defined in the snipmate files further below.
require( 'luasnip.loaders.from_lua' ).lazy_load{
  paths={ SNIPPETS_FOLDER .. '/lua' },
}
