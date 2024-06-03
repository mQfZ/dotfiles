return {
  "williamboman/mason.nvim",
  cmd = "Mason",
  keys = {
    { "<Leader>mm", "<CMD>Mason<CR>", desc = "Mason" },
    { "<Leader>mum", "<CMD>Mason<CR> | q", noremap = true, desc = "Mason" },
  },
  config = function(_, opts)
    require("mason").setup(opts)
    local registry = require("mason-registry")

    opts.ensure_installed = util.dedup(opts.ensure_installed)
    registry.refresh(function()
      for _, tool in ipairs(opts.ensure_installed) do
        local package = registry.get_package(tool)
        if not package:is_installed() then
          package:install()
        end
      end
    end)
  end,
}
