---@class util.buffer
local M = {}

---@param bufnr? number
---@return nil
function M.remove(bufnr)
  bufnr = bufnr or 0
  bufnr = bufnr == 0 and vim.api.nvim_get_current_buf() or bufnr

  if vim.bo.modified then
    local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
    if choice == 0 then
      return
    end
    if choice == 1 then
      vim.cmd.write()
    end
  end

  for _, win in ipairs(vim.fn.win_findbuf(bufnr)) do
    vim.api.nvim_win_call(win, function()
      if not vim.api.nvim_win_is_valid(win) or vim.api.nvim_win_get_buf(win) ~= bufnr then
        return
      end
      local alt = vim.fn.bufnr("#")
      if alt ~= bufnr and vim.fn.buflisted(alt) == 1 then
        vim.api.nvim_win_set_buf(win, alt)
        return
      end

    ---@diagnostic disable-next-line: param-type-mismatch
      local has_previous = pcall(vim.cmd, "bprevious")
      if has_previous and bufnr ~= vim.api.nvim_win_get_buf(win) then
        return
      end

      local new_buf = vim.api.nvim_create_buf(true, false)
      vim.api.nvim_win_set_buf(win, new_buf)
    end)
  end
  if vim.api.nvim_buf_is_valid(bufnr) then
    ---@diagnostic disable-next-line: param-type-mismatch
    pcall(vim.cmd, "bdelete! " .. bufnr)
  end
end

return M
