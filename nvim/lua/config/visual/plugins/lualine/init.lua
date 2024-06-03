return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = function()
    return {
      options = {
        theme = function()
          local name = "config.visual.plugins.lualine.theme.auto"
          package.loaded[name] = nil
          local theme = require(name)
          theme.normal.c.gui = "bold"
          theme.insert.c.gui = "bold"
          theme.replace.c.gui = "bold"
          theme.visual.c.gui = "bold"
          theme.command.c.gui = "bold"
          theme.terminal.c.gui = "bold"
          theme.inactive.c.gui = "bold"
          return theme
        end,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },
        lualine_c = {
          {
            "diagnostics",
            symbols = {
              error = config.icons.diagnostics.Error,
              warn = config.icons.diagnostics.Warn,
              info = config.icons.diagnostics.Info,
              hint = config.icons.diagnostics.Hint,
            },
          },
          {
            "filename",
            file_status = true,
            newfile_status = true,
            path = 1,
          },
        },
        lualine_x = {
          {
            ---@diagnostic disable-next-line: undefined-field
            require("noice").api.status.command.get,
            ---@diagnostic disable-next-line: undefined-field
            cond = require("noice").api.status.command.has,
            color = { fg = util.Color.from_highlight("fg", "Statement"):to_str() },
          },
          {
            ---@diagnostic disable-next-line: undefined-field
            require("noice").api.status.mode.get,
            ---@diagnostic disable-next-line: undefined-field
            cond = require("noice").api.status.mode.has,
            color = { fg = util.Color.from_highlight("fg", "Constant"):to_str() },
          },
          {
            require("lazy.status").updates,
            cond = require("lazy.status").has_updates,
            color = { fg = util.Color.from_highlight("fg", "Special"):to_str() },
          },
          { "diff" },
        },
        lualine_y = {
          { "progress", separator = " ", padding = { left = 1, right = 0 } },
          { "location", padding = { left = 0, right = 1 } },
        },
        lualine_z = {
          function()
            return " " .. os.date("%R")
          end,
        },
      },
    }
  end,
}
