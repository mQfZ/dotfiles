return {
  "lewis6991/gitsigns.nvim",
  event = "LazyFile",
  opts = {
    signs = {
      add = { text = "▎" },
      change = { text = "▎" },
      delete = { text = "" },
      topdelete = { text = "" },
      changedelete = { text = "▎" },
      untracked = { text = "▎" },
    },
    -- stylua: ignore
    on_attach = function(bufnr)
      vim.keymap.set("n", "]h", function() require("gitsigns").nav_hunk("next") end, { buffer = bufnr, desc = "Next Hunk" })
      vim.keymap.set("n", "[h", function() require("gitsigns").nav_hunk("prev") end, { buffer = bufnr, desc = "Prev Hunk" })
      vim.keymap.set("n", "]H", function() require("gitsigns").nav_hunk("last") end, { buffer = bufnr, desc = "Last Hunk" })
      vim.keymap.set("n", "[H", function() require("gitsigns").nav_hunk("first") end, { buffer = bufnr, desc = "First Hunk" })
      vim.keymap.set({ "n", "v" }, "<Leader>ghs", ":Gitsigns stage_hunk<CR>", { buffer = bufnr, desc = "Stage Hunk" })
      vim.keymap.set({ "n", "v" }, "<Leader>ghr", ":Gitsigns reset_hunk<CR>", { buffer = bufnr, desc = "Reset Hunk" })
      vim.keymap.set("n", "<Leader>ghS", require("gitsigns").stage_buffer, { buffer = bufnr, desc = "Stage Buffer" })
      vim.keymap.set("n", "<Leader>ghu", require("gitsigns").undo_stage_hunk, { buffer = bufnr, desc = "Undo Stage Hunk" })
      vim.keymap.set("n", "<Leader>ghR", require("gitsigns").reset_buffer, { buffer = bufnr, desc = "Reset Buffer" })
      vim.keymap.set("n", "<Leader>ghp", require("gitsigns").preview_hunk_inline, { buffer = bufnr, desc = "Preview Hunk Inline" })
      vim.keymap.set("n", "<Leader>ghb", function() require("gitsigns").blame_line({ full = true }) end, { buffer = bufnr, desc = "Blame Line" })
      vim.keymap.set("n", "<Leader>ghd", require("gitsigns").diffthis, { buffer = bufnr, desc = "Diff This" })
      vim.keymap.set("n", "<Leader>ghD", function() require("gitsigns").diffthis("~") end, { buffer = bufnr, desc = "Diff This ~" })
      vim.keymap.set({ "o", "x" }, "ih", "<CMD><C-U>Gitsigns select_hunk<CR>", { buffer = bufnr, desc = "GitSigns Select Hunk" })
    end,
  },
}
