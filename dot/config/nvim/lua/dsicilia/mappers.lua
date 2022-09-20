-----------------------------------------------------------------
--                         Keymappers
-----------------------------------------------------------------
local M = {}

-- Helpers
-- ==============================================================
-- Note that `to` can be a string, or a Lua function.
local function xnoremap( mode, keys, to )
  vim.keymap.set( mode, keys, to, { silent=true } )
end

local function build_mapper( mode )
  return setmetatable( {}, {
    __newindex=function( _, keys, to )
      xnoremap( mode, keys, to )
    end,
    __index = function() error('no reading from mappers.') end
  } )
end

M.nmap = build_mapper( 'n' )
M.imap = build_mapper( 'i' )
M.vmap = build_mapper( 'v' )

return M
