---@class util.root
---@overload fun(buf?: number): string
local M = setmetatable({}, {
  __call = function(m)
    return m.root()
  end,
})

---@alias RootDetectorHelper fun(buf?: number, ...): string[]
---@type table<string, RootDetectorHelper>
M.helper = {}

---@return string[]
function M.helper.cwd()
  return { vim.uv.cwd() }
end

---@param bufnr number
---@return string[]
function M.helper.lsp(bufnr)
  local bufpath = util.path.bufpath(bufnr)
  if not bufpath then
    return {}
  end
  local roots = {}
  for _, client in pairs(vim.lsp.get_clients({ bufnr = bufnr })) do
    for _, workspace_folder in pairs(client.config.workspace_folders or {}) do
      roots[#roots + 1] = vim.uri_to_fname(workspace_folder.uri)
    end
  end
  return vim.tbl_filter(function(path)
    path = vim.fs.normalize(path)
    return path and bufpath:find(path, 1, true) == 1
  end, roots)
end

---@param bufnr number
---@param matcher string | string[] | fun(name: string, path: string): boolean
---@return string[]
function M.helper.pattern(bufnr, matcher)
  local path = util.path.bufpath(bufnr) or vim.uv.cwd()
  if type(matcher) == "string" then
    matcher = { matcher }
  end
  if type(matcher) == "table" then
    local patterns = matcher
    matcher = function(name, _)
      for _, pattern in pairs(patterns) do
        if pattern == name then
          return true
        end
      end
      return false
    end
  end
  local matches = vim.fs.find(matcher, { path = path, upward = true, limit = math.huge })
  return vim.tbl_map(vim.fs.dirname, matches)
end

---@alias RootDetector fun(buf?: number): string[]
---@type table<string, RootDetector>
M.detectors = {
  M.helper.lsp,
  function(bufnr)
    return M.helper.pattern(bufnr, { ".git" })
  end,
  M.helper.cwd,
}

---@param bufnr? number
---@return string[]
function M.roots(bufnr)
  bufnr = (bufnr == nil or bufnr == 0) and vim.api.nvim_get_current_buf() or bufnr
  local roots = {}
  for _, detector in pairs(M.detectors) do
    vim.list_extend(roots, detector(bufnr))
  end
  return roots
end

---@param bufnr? number
---@return string
function M.root(bufnr)
  return M.roots(bufnr)[1]
end

return M
