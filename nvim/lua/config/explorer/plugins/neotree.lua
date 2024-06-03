return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  cmd = "Neotree",
  -- stylua: ignore
  keys = {
    { "<Leader>fe", function() require("neo-tree.command").execute({ toggle = true, dir = util.root() }) end, desc = "NeoTree Explorer (Root Dir)" },
    { "<Leader>fE", function() require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() }) end, desc = "NeoTree Explorer (cwd)" },
    { "<Leader>;", "<Leader>fe", desc = "Explorer NeoTree (Root Dir)", remap = true },
    { "<Leader>ge", function() require("neo-tree.command").execute({ source = "git_status", toggle = true }) end, desc = "Git Explorer" },
    { "<Leader>be", function() require("neo-tree.command").execute({ source = "buffers", toggle = true }) end, desc = "Buffer Explorer" },
  },
  init = function()
    vim.api.nvim_create_autocmd("BufEnter", {
      group = vim.api.nvim_create_augroup("Neotree_start_directory", { clear = true }),
      desc = "Start Neo-tree with directory",
      once = true,
      callback = function()
        if package.loaded["neo-tree"] then
          return
        else
          ---@diagnostic disable-next-line: param-type-mismatch
          local stats = vim.uv.fs_stat(vim.fn.argv(0))
          if stats and stats.type == "directory" then
            require("neo-tree")
          end
        end
      end,
    })
  end,
  opts = {
    close_if_last_window = true,
    popup_border_style = "single",
    sources = { "filesystem", "buffers", "git_status", "document_symbols" },
    open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
    filesystem = {
      commands = {
        delete = function(state)
          local inputs = require("neo-tree.ui.inputs")
          local path = state.tree:get_node().path
          local msg = "Are you sure you want to trash \"" .. vim.fs.basename(path) .. "\"?"
          inputs.confirm(msg, function(confirmed)
            if not confirmed then
              return
            end
            vim.fn.system({ "trash", vim.fn.fnameescape(path) })
            require("neo-tree.sources.manager").refresh(state.name)
          end)
        end,
        delete_visual = function(state, selected_nodes)
          local inputs = require("neo-tree.ui.inputs")

          local msg = "Are you sure you want to trash " .. vim.tbl_count(selected_nodes) .. " items?"
          inputs.confirm(msg, function(confirmed)
            if not confirmed then
              return
            end
            for _, node in ipairs(selected_nodes) do
              vim.fn.system({ "trash", vim.fn.fnameescape(node.path) })
            end
            require("neo-tree.sources.manager").refresh(state.name)
          end)
        end,
      },
      filtered_items = {
        hide_dotfiles = false,
        hide_hidden = false,
      },
      bind_to_cwd = false,
      follow_current_file = { enabled = true },
      use_libuv_file_watcher = true,
    },
    window = {
      width = 33,
      mappings = {
        ["<Space>"] = "none",
        ["Y"] = {
          function(state)
            local node = state.tree:get_node()
            local path = node:get_id()
            vim.fn.setreg("+", path, "c")
          end,
          desc = "Copy Path to Clipboard",
        },
      },
    },
    default_component_configs = {
      name = {
        use_git_status_colors = false,
      },
      modified = {
        symbol = "+",
      },
      git_status = {
        symbols = {
          added = "A",
          modified = "M",
          deleted = "D",
          renamed = "R",
          untracked = "N",
          ignored = "I",
          unstaged = "U",
          staged = "S",
          conflict = "C",
        },
      },
      indent = {
        with_expanders = true,
        expander_collapsed = "",
        expander_expanded = "",
        expander_highlight = "NeoTreeExpander",
      },
    },
  },
  config = function(_, opts)
    vim.api.nvim_set_hl(0, "NeoTreeMessage", { link = "Comment" })

    local function on_move(data)
      util.lsp.on_rename(data.source, data.destination)
    end

    local events = require("neo-tree.events")
    opts.event_handlers = opts.event_handlers or {}
    vim.list_extend(opts.event_handlers, {
      { event = events.FILE_MOVED, handler = on_move },
      { event = events.FILE_RENAMED, handler = on_move },
    })
    require("neo-tree").setup(opts)
    vim.api.nvim_create_autocmd("TermClose", {
      pattern = "*lazygit",
      callback = function()
        if package.loaded["neo-tree.sources.git_status"] then
          require("neo-tree.sources.git_status").refresh()
        end
      end,
    })
  end,
}
