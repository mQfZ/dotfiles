return {
  "folke/todo-comments.nvim",
  cmd = { "TodoTrouble", "TodoTelescope" },
  event = "LazyFile",
  config = true,
  -- stylua: ignore
  keys = {
    { "]t", function() require("todo-comments").jump_next() end, desc = "Next Todo Comment" },
    { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous Todo Comment" },
    { "<Leader>dt", "<CMD>TodoTrouble<CR>", desc = "Todo" },
    { "<Leader>dT", "<CMD>TodoTrouble keywords=TODO,FIX,FIXME<CR>", desc = "Todo/Fix/Fixme" },
    { "<Leader>st", "<CMD>TodoTelescope<CR>", desc = "Todo" },
    { "<Leader>sT", "<CMD>TodoTelescope keywords=TODO,FIX,FIXME<CR>", desc = "Todo/Fix/Fixme" },
  },
}
