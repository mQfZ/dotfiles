vim.loader.enable()
_G.util = require("util")
_G.config = require("config.config")

vim.g.mapleader = config.mapleader or " "
vim.g.localmapleader = config.localmapleader or " "

local spec = {}
for name, filetype in vim.fs.dir(vim.fs.joinpath(util.path.config, "lua", "config")) do
  if filetype == "directory" then
    local module = require("config." .. name)
    vim.list_extend(spec, type(module) == "table" and module or {})
  end
end
util.lazy.setup(require("config.lazy"), spec)

vim.cmd.colorscheme(config.colorscheme)
