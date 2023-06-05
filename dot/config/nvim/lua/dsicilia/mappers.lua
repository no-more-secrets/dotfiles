-----------------------------------------------------------------
--                         Keymappers
-----------------------------------------------------------------
local M = {}

-- Helpers
-- ==============================================================
-- Note that `to` can be a string, or a Lua function.
local function xnoremap( mode, keys, to, opts )
  opts = opts or {}
  if opts.silent == nil then opts.silent = true end
  -- if opts.nowait == nil then opts.nowait = true end
  vim.keymap.set( mode, keys, to, opts )
end

function M.build_mapper( mode, opts )
  return setmetatable( {}, {
    __newindex=function( _, keys, to )
      xnoremap( mode, keys, to, opts )
    end,
    __index=function() error( 'no reading from mappers.' ) end,
  } )
end

M.nmap = M.build_mapper( 'n' )
M.imap = M.build_mapper( 'i' )
M.vmap = M.build_mapper( 'v' )

return M
