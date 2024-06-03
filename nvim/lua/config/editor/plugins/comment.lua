return {
  "numToStr/Comment.nvim",
  event = "LazyFile",
  opts = {
    toggler = {
      line = "<Leader>cc",
      block = "<Leader>cb",
    },
    opleader = {
      line = "<Leader>cC",
      block = "<Leader>cB",
    },
    extra = {
      above = "<Leader>ck",
      below = "<Leader>cj",
      eol = "<Leader>cl",
    },
    remap = {
      extra = {
        above = "<Leader>c<Up>",
        below = "<Leader>c<Down>",
        eol = "<Leader>c<Right>",
      },
    },
    mappings = {
      basic = true,
      extra = true,
    },
  },
  config = function(_, opts)
    require("Comment").setup(opts)
    local api = require("Comment.api")

    -- stylua: ignore start
    vim.keymap.set("n", opts.remap.extra.above, function() api.insert.linewise.above() end, { desc = "Comment insert above" })
    vim.keymap.set("n", opts.remap.extra.below, function() api.insert.linewise.below() end, { desc = "Comment insert below" })
    vim.keymap.set("n", opts.remap.extra.eol, function() api.insert.linewise.eol() end, { desc = "Comment insert end of line" })
    -- stylua: ignore end
  end,
}
