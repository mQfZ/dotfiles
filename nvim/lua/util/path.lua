---@class util.path
local M = {}

---@type string
---@diagnostic disable-next-line: assign-type-mismatch
M.config = vim.fn.stdpath("config")

---@type string
---@diagnostic disable-next-line: assign-type-mismatch
M.data = vim.fn.stdpath("data")

---@param path string | nil
---@return string?
function M.expand(path)
  if path == "" or path == nil then
    return nil
  end
  return vim.fs.normalize(vim.uv.fs_realpath(path) or path)
end

---@return string
function M.cwd()
  return M.expand(vim.uv.cwd()) or ""
end

---@param bufnr number
---@return string?
function M.bufpath(bufnr)
  return M.expand(vim.api.nvim_buf_get_name(bufnr))
end

return M
