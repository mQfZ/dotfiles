return {
  "folke/trouble.nvim",
  cmd = { "TroubleToggle", "Trouble" },
  opts = {
    padding = false,
    use_diagnostic_signs = true,
  },
  -- stylua: ignore
  keys = {
    { "<Leader>dd", "<CMD>Trouble diagnostics toggle<CR>", desc = "Diagnostics (Trouble)" },
    { "<Leader>db", "<CMD>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Buffer Diagnostics (Trouble)" },
    { "<Leader>es", "<CMD>Trouble symbols toggle focus=false<CR>", desc = "Symbols (Trouble)" },
    {
      "<Leader>cS",
      "<CMD>Trouble lsp toggle focus=false win.position=right<CR>",
      desc = "LSP references/definitions/... (Trouble)",
    },
    { "<Leader>dl", "<CMD>Trouble loclist toggle<CR>", desc = "Location List (Trouble)" },
    { "<Leader>dq", "<CMD>Trouble qflist toggle<CR>", desc = "Quickfix List (Trouble)" },
    {
      "[q",
      function()
        if require("trouble").is_open() then
          ---@diagnostic disable-next-line: missing-parameter, missing-fields
          require("trouble").prev({ skip_groups = true, jump = true })
        else
          local ok, err = pcall(vim.cmd.cprevious)
          if not ok then
            ---@diagnostic disable-next-line: param-type-mismatch
            vim.notify(err, vim.log.levels.ERROR)
          end
        end
      end,
      desc = "Previous Trouble/Quickfix Item",
    },
    {
      "]q",
      function()
        if require("trouble").is_open() then
          ---@diagnostic disable-next-line: missing-parameter, missing-fields
          require("trouble").next({ skip_groups = true, jump = true })
        else
          local ok, err = pcall(vim.cmd.cnext)
          if not ok then
            ---@diagnostic disable-next-line: param-type-mismatch
            vim.notify(err, vim.log.levels.ERROR)
          end
        end
      end,
      desc = "Next Trouble/Quickfix Item",
    },
  },
}
