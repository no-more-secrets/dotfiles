-- Speeds up loading time by enabling the experimental Lua module
-- loader which removes the default Neovim loader and uses the
-- byte-compilation cache.
vim.loader.enable()

-- Should go first.
require 'dsicilia.use'
