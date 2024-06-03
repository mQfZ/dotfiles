return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  version = false,
  dependencies = {
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-lua/plenary.nvim",
  },
  -- stylua: ignore
  keys = {
    { "<Leader>,", function() require("telescope.builtin").buffers({ sort_mru = true }) end, desc = "Switch Buffer" },
    { "<Leader>/", function() require("telescope.builtin").live_grep({ cwd = util.root() }) end, desc = "Grep (Root Dir)" },
    { "<Leader>:", function() require("telescope.builtin").command_history() end, desc = "Command History" },
    { "<Leader><Space>", function() require("telescope.builtin").find_files({ cwd = util.root() }) end, desc = "Find Files (Root Dir)" },
    { "<Leader>fb", function() require("telescope.builtin").buffers({ sort_mru = true }) end, desc = "Find Buffer" },
    { "<Leader>fc", function() require("telescope.builtin").find_files({ cwd = vim.env.XDG_CONFIG_HOME }) end, desc = "Find Config File" },
    { "<Leader>ff", function() require("telescope.builtin").find_files({ cwd = util.root() }) end, desc = "Find Files (Root Dir)" },
    { "<Leader>fF", function() require("telescope.builtin").find_files({ cwd = vim.uv.cwd() }) end, desc = "Find Files (cwd)" },
    { "<Leader>fg", function() require("telescope.builtin").git_files() end, desc = "Find Files (git-files)" },
    { "<Leader>fr", function() require("telescope.builtin").oldfiles() end, desc = "Recent Files" },
    { "<Leader>gc", function() require("telescope.builtin").git_commits() end, desc = "Commits" },
    { "<Leader>gs", function() require("telescope.builtin").git_status() end, desc = "Status" },
    { "<Leader>s\"", function() require("telescope.builtin").registers() end, desc = "Registers" },
    { "<Leader>sa", function() require("telescope.builtin").autocommands() end, desc = "Autocommands" },
    { "<Leader>sb", function() require("telescope.builtin").current_buffer_fuzzy_find() end, desc = "Buffer" },
    { "<Leader>sc", function() require("telescope.builtin").command_history() end, desc = "Command History" },
    { "<Leader>sC", function() require("telescope.builtin").commands() end, desc = "Commands" },
    { "<Leader>sd", function() require("telescope.builtin").diagnostics({ bufnr = 0 }) end, desc = "Document Diagnostics" },
    { "<Leader>sD", function() require("telescope.builtin").diagnostics() end, desc = "Workspace Diagnostics" },
    { "<Leader>sg", function() require("telescope.builtin").live_grep({ cwd = util.root() }) end, desc = "Grep (Root Dir)" },
    { "<Leader>sG", function() require("telescope.builtin").live_grep({ cwd = vim.uv.cwd() }) end, desc = "Grep (cwd)" },
    { "<Leader>sh", function() require("telescope.builtin").help_tags() end, desc = "Help Pages" },
    { "<Leader>sH", function() require("telescope.builtin").highlights() end, desc = "Highlights" },
    { "<Leader>sj", function() require("telescope.builtin").jumplist() end, desc = "Jumplist" },
    { "<Leader>sk", function() require("telescope.builtin").keymaps() end, desc = "Keymaps" },
    { "<Leader>sl", function() require("telescope.builtin").loclist() end, desc = "Location List" },
    { "<Leader>sm", function() require("telescope.builtin").marks() end, desc = "Marks" },
    { "<Leader>sM", function() require("telescope.builtin").man_pages() end, desc = "Man Pages" },
    { "<Leader>so", function() require("telescope.builtin").vim_options() end, desc = "Vim Options" },
    { "<Leader>sq", function() require("telescope.builtin").quickfix() end, desc = "Quickfix" },
    { "<Leader>sR", function() require("telescope.builtin").resume() end, desc = "Resume" },
    { "<Leader>ss", function() require("telescope.builtin").builtin() end, desc = "Telescope" },
    { "<Leader>sw", function() require("telescope.builtin").grep_string({ cwd = util.root(), word_match = "-w" }) end, desc = "Word (Root Dir)" },
    { "<Leader>sW", function() require("telescope.builtin").grep_string({ cwd = vim.uv.cwd(), word_match = "-w" }) end, desc = "Word (cwd)" },
    { "<Leader>sw", function() require("telescope.builtin").grep_string({ cwd = util.root() }) end, mode = "v", desc = "Selection (Root Dir)" },
    { "<Leader>sW", function() require("telescope.builtin").grep_string({ cwd = vim.uv.cwd() }) end, mode = "v", desc = "Selection (cwd)" },
    { "<Leader>uc", function() require("telescope.builtin").colorscheme() end, desc = "Colorscheme" },
    { "<Leader>uC", function() require("telescope.builtin").colorscheme({ enable_preview = true }) end, desc = "Colorscheme with Preview" },
  },
  opts = function()
    return {
      defaults = {
        mappings = {
          i = { ["<C-t>"] = require("trouble.providers.telescope").open_with_trouble },
          n = { ["<C-t>"] = require("trouble.providers.telescope").open_with_trouble },
        },
      },
    }
  end,
  config = function()
    require("telescope").load_extension("fzf")
  end,
}
