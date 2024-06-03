---@class util.lazy
local M = {}

---@param root string
---@return nil
function M.bootstrap(root)
  local lazypath = vim.fs.joinpath(root, "lazy.nvim")
  if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable",
      lazypath,
    })
  end
  vim.opt.runtimepath:prepend(lazypath)
end

---@param lazyspec LazySpec
---@param spec? LazySpec[]
---@return nil
function M.setup(lazyspec, spec)
  ---@diagnostic disable-next-line: param-type-mismatch
  local lazyopts = type(lazyspec.opts) == "function" and lazyspec.opts(nil, {}) or (lazyspec.opts or {})
  lazyopts.root = lazyopts.root or vim.fs.joinpath(util.path.data, "plugins")
  lazyopts.spec = lazyopts.spec or {}
  vim.list_extend(lazyopts.spec, spec or {})
  M.bootstrap(lazyopts.root)
  local config = lazyspec.config or function(_, opts)
    require("lazy").setup(opts)
  end
  config(nil, lazyopts)
end

return M
