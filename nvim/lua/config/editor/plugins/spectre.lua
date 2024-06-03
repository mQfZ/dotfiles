return {
  "nvim-pack/nvim-spectre",
  build = false,
  cmd = "Spectre",
  -- stylua: ignore
  keys = {
    { "<Leader>sr", function() require("spectre").open() end, desc = "Replace in Files (Spectre)" },
  },
  opts = {
    open_cmd = "noswapfile vnew",
  },
}
