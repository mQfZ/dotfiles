return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.opt.timeout = true
    vim.opt.timeoutlen = 500
  end,
  opts = {
    plugins = { spelling = true },
    defaults = {
      ["g"] = { name = "+goto" },
      ["z"] = { name = "+fold" },
      ["]"] = { name = "+next" },
      ["["] = { name = "+prev" },
      ["<Leader>b"] = { name = "+buffer" },
      ["<Leader>c"] = { name = "+comment" },
      ["<Leader>d"] = { name = "+diagnostics/quickfix" },
      ["<Leader>e"] = { name = "+editor" },
      ["<Leader>f"] = { name = "+find" },
      ["<Leader>g"] = { name = "+git" },
      ["<leader>gh"] = { name = "+hunks" },
      ["<Leader>m"] = { name = "+manager" },
      ["<Leader>mu"] = { name = "+update" },
      ["<Leader>s"] = { name = "+search" },
      ["<Leader>sn"] = { name = "+noice" },
      ["<Leader>u"] = { name = "+ui" },
      ["<Leader>q"] = { name = "+quit" },
    },
    layout = {
      height = {
        min = 4,
        max = 10,
      },
    },
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
    wk.register(opts.defaults)
  end,
}
