require 'dsicilia.packages.use'

-- Note that we don't require the individual package config mod-
-- ules here; we do that in each package's post-startup config in
-- the `use` module since we wouldn't want to configure it until
-- it is loaded.
