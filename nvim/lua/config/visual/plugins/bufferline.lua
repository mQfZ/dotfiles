return {
  "akinsho/bufferline.nvim",
  event = "VeryLazy",
  keys = {
    { "<Leader>bp", "<CMD>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
    { "<Leader>bP", "<CMD>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
    { "<Leader>bo", "<CMD>BufferLineCloseOthers<CR>", desc = "Delete Other Buffers" },
    { "<Leader>br", "<CMD>BufferLineCloseRight<CR>", desc = "Delete Buffers to the Right" },
    { "<Leader>bl", "<CMD>BufferLineCloseLeft<CR>", desc = "Delete Buffers to the Left" },
    { "<S-h>", "<CMD>BufferLineCyclePrev<CR>", desc = "Prev Buffer" },
    { "<S-l>", "<CMD>BufferLineCycleNext<CR>", desc = "Next Buffer" },
    { "[b", "<CMD>BufferLineCyclePrev<CR>", desc = "Prev Buffer" },
    { "]b", "<CMD>BufferLineCycleNext<CR>", desc = "Next Buffer" },
  },
  opts = {
    highlights = {},
    options = {
      always_show_bufferline = true,
      close_command = function(bufnr)
        util.buffer.remove(bufnr)
      end,
      right_mouse_command = function(bufnr)
        util.buffer.remove(bufnr)
      end,
      diagnostics = "nvim_lsp",
      diagnostics_update_in_insert = false,
      diagnostics_indicator = function(_, _, diag)
        return vim.trim(
          (diag.error and config.icons.diagnostics.Error .. diag.error .. " " or "")
            .. (diag.warning and config.icons.diagnostics.Warn .. diag.warning or "")
        )
      end,
      offsets = {
        {
          filetype = "neo-tree",
          text = "Explorer",
          highlight = "Directory",
          text_align = "left",
        },
      },
    },
  },
}
