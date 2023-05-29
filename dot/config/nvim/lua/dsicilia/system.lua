-----------------------------------------------------------------
-- System commands.
-----------------------------------------------------------------
local M = {}

-----------------------------------------------------------------
-- Aliases.
-----------------------------------------------------------------
local format = string.format

-----------------------------------------------------------------
-- Functions.
-----------------------------------------------------------------
-- Invokes system commands with error checking. For info on what
-- the parameters can contain, see `h: system`. For example, if
-- `cmd` is a table then it contains a list of arguments and it
-- runs it without any shell, while if it is a string it will run
-- it with a shell. Returns the stdout of the program and raises
-- an error if the command did not succeed.
function M.system( cmd, input )
  assert( cmd )
  local output = vim.fn.system( cmd, input )
  if vim.v.shell_error ~= 0 then
    error( format( 'error: command %s returned error code %d.',
                   vim.inspect( cmd ), vim.v.shell_error ) )
  end
  return output
end

function M.git_clone( ... )
  return M.system( { 'git', 'clone', ... } )
end

-- `where` should be a folder that is created as a result of
-- cloning, i.e. it must not exist.
function M.github_clone( acct, repo, where, ... )
  assert( where )
  local url = format( 'https://github.com/%s/%s', acct, repo )
  return M.git_clone( url, where, ... )
end

-----------------------------------------------------------------
-- Finished.
-----------------------------------------------------------------
return M
