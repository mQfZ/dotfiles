return {
  "folke/noice.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },
  event = "VeryLazy",
  -- stylua: ignore
  keys = {
    { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect Cmdline" },
    { "<Leader>snl", function() require("noice").cmd("last") end, desc = "Noice Last Message" },
    { "<Leader>snh", function() require("noice").cmd("history") end, desc = "Noice History" },
    { "<Leader>sna", function() require("noice").cmd("all") end, desc = "Noice All" },
    { "<Leader>snd", function() require("noice").cmd("dismiss") end, desc = "Dismiss All" },
    { "<Leader>snt", function() require("noice").cmd("telescope") end, desc = "Noice Telescope" },
    { "<C-d>", function() if not require("noice.lsp").scroll(4) then return "<C-u>" end end, silent = true, expr = true, desc = "Scroll Forward", mode = {"i", "n", "s"} },
    { "<C-u>", function() if not require("noice.lsp").scroll(-4) then return "<C-d>" end end, silent = true, expr = true, desc = "Scroll Backward", mode = {"i", "n", "s"} },
  },
  opts = {
    lsp = {
      signature = {
        auto_open = {
          enabled = false,
        },
      },
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
    },
    routes = {
      {
        filter = {
          event = "msg_show",
          any = {
            { find = "%d+L, %d+B" },
            { find = "; after #%d+" },
            { find = "; before #%d+" },
          },
        },
        view = "mini",
      },
      {
        filter = {
          event = "lsp",
          kind = "progress",
          find = "workspace",
        },
        opts = { skip = true },
      },
    },
    presets = {
      bottom_search = true,
      command_palette = true,
      long_message_to_split = true,
      inc_rename = false,
    },
  },
}
