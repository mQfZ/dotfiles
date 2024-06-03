return {
  "stevearc/conform.nvim",
  event = "LazyFile",
  keys = {
    {
      "<Leader>eF",
      function()
        require("conform").format({
          timeout_ms = 1500,
          async = false,
          quiet = false,
          lsp_fallback = true,
        })
      end,
      mode = { "n", "v" },
      desc = "Format",
    },
  },
}
