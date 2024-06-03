vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.fillchars = { eob = " " }
vim.opt.undofile = true

-- stylua: ignore start
vim.keymap.set("n", "<Leader>1", "<CMD>w<CR>", { desc = "Save" })
vim.keymap.set("n", "<Leader>qq", function() util.buffer.remove() end, { desc = "Delete Buffer" })
vim.keymap.set("n", "<Leader>qs", "<CMD>wq<CR>", { desc = "Quit Write" })
vim.keymap.set("n", "<Leader>q.", "<CMD>q<CR>", { desc = "Quit" })
-- stylua: ignore end

return {
  { import = "config.editor.plugins" },
}
