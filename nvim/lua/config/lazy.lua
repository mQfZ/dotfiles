return {
  "folke/lazy.nvim",
  opts = {
    root = vim.fs.joinpath(util.path.data, "plugins"),
    install = {
      missing = false,
    },
    change_detection = {
      notify = false,
    },
    ui = {
      backdrop = 100,
    },
    event = {
      LazyFile = { "BufReadPost", "BufNewFile", "BufWritePre" },
    },
    performance = {
      rtp = {
        disabled_plugins = {
          "gzip",
          "matchit",
          "matchparen",
          "netrwPlugin",
          "tarPlugin",
          "tohtml",
          "tutor",
          "zipPlugin",
        },
      },
    },
  },
  config = function(_, opts)
    util.lazyevent = require("lazy.core.handler.event")
    for name, event in pairs(opts.event or {}) do
      util.lazyevent.mappings[name] = { id = name, event = event }
      util.lazyevent.mappings["User " .. name] = util.lazyevent.mappings[name]
    end
    util.lazyevent = nil

    require("lazy").setup(opts)

    vim.keymap.set("n", "<Leader>ml", "<CMD>Lazy<CR>", { desc = "Lazy" })
    vim.keymap.set("n", "<Leader>mul", "<CMD>Lazy sync<CR>", { desc = "Lazy" })
  end,
}
