return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  version = false,
  event = "VeryLazy",
  cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
  keys = {
    { "<Leader>mut", "<CMD>TSUpdateSync<CR>", desc = "Treesitter" },
    { "<C-Space>", desc = "Increment Selection" },
    { "<BS>", desc = "Decrement Selection", mode = "x" },
  },
  opts = {
    highlight = {
      enable = true,
    },
    indent = {
      enable = true,
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<C-Space>",
        node_incremental = "<C-Space>",
        scope_incremental = false,
        node_decremental = "<BS>",
      },
    },
  },
  config = function(_, opts)
    opts.ensure_installed = util.dedup(opts.ensure_installed)
    require("nvim-treesitter.configs").setup(opts)
  end,
}
