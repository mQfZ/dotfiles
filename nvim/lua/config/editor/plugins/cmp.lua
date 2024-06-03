return {
  "hrsh7th/nvim-cmp",
  event = { "CmdlineEnter", "InsertEnter" },
  dependencies = {
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
  },
  init = function()
    vim.opt.pumheight = 15
  end,
  opts = function()
    local cmp = require("cmp")

    -- stylua: ignore start
    local select_next_fallback = cmp.mapping(function(fallback)
      if cmp.visible() then cmp.select_next_item() else fallback() end
    end, { "i", "c", "s" })

    local select_prev_fallback = cmp.mapping(function(fallback)
      if cmp.visible() then cmp.select_prev_item() else fallback() end
    end, { "i", "c", "s" })

    local complete = cmp.mapping(function() cmp.complete() end, { "i", "c", "s" })
    local close = cmp.mapping(function(fallback)
      if cmp.visible() then cmp.abort(); cmp.core:reset() else fallback() end
    end, { "i", "c", "s" })
    -- stylua: ignore stop

    local function format(opts)
      opts = opts or {}
      opts.cmp_kinds = opts.cmp_kinds or {}
      opts.abbr_width = opts.abbr_width or 30
      opts.kind_width = opts.kind_width or 15
      opts.menu_width = opts.menu_width or 20
      opts.ellipsis_char = opts.ellipsis_char or "…"

      return function(_, vim_item)
        vim_item.kind = (opts.cmp_kinds[vim_item.kind] or "") .. " " .. vim_item.kind
        local abbr = vim_item.abbr and vim_item.abbr or ""
        local truncated_abbr = vim.fn.strcharpart(abbr, 0, opts.abbr_width)
        if truncated_abbr ~= abbr then
          vim_item.abbr = truncated_abbr .. opts.ellipsis_char
        elseif string.len(abbr) < opts.abbr_width then
          local padding = string.rep(" ", opts.abbr_width - string.len(abbr))
          vim_item.abbr = abbr .. padding
        end
        local kind = vim_item.kind and vim_item.kind or ""
        local truncated_kind = vim.fn.strcharpart(kind, 0, opts.kind_width)
        if truncated_kind ~= kind then
          vim_item.kind = truncated_kind .. opts.ellipsis_char
        elseif string.len(kind) < opts.kind_width then
          local padding = string.rep(" ", opts.kind_width - string.len(kind))
          vim_item.kind = kind .. padding
        end
        local menu = vim_item.menu and vim_item.menu or ""
        local truncated_menu = vim.fn.strcharpart(menu, 0, opts.menu_width)
        if truncated_menu ~= menu then
          vim_item.menu = truncated_menu .. opts.ellipsis_char
        elseif string.len(menu) < opts.menu_width and menu ~= "" then
          local padding = string.rep(" ", opts.menu_width - string.len(menu))
          vim_item.menu = menu .. padding
        end
        return vim_item
      end
    end

    local mapping = cmp.mapping.preset.insert({
      ["<C-d>"] = cmp.mapping.scroll_docs(4),
      ["<C-u>"] = cmp.mapping.scroll_docs(-4),
      ["<Tab>"] = select_next_fallback,
      ["<S-Tab>"] = select_prev_fallback,
      ["<Down>"] = select_next_fallback,
      ["<Up>"] = select_prev_fallback,
      ["<C-Space>"] = complete,
      ["<C-f>"] = close,
      ["<CR>"] = cmp.mapping.confirm({ select = false }),
    })

    local opts = {
      completion = {
        completeopt = "menu,menuone,preview,noselect",
        autocomplete = false,
      },
      mapping = mapping,
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
      }, {
        { name = "path" },
        { name = "buffer" },
      }),
      formatting = {
        fields = { "abbr", "kind", "menu" },
        format = format({
          cmp_kinds = {
            Array         = "",
            Boolean       = "󰨙",
            Class         = "",
            Codeium       = "󰘦",
            Color         = "",
            Control       = "",
            Collapsed     = "",
            Constant      = "󰏿",
            Constructor   = "",
            Copilot       = "",
            Enum          = "",
            EnumMember    = "",
            Event         = "",
            Field         = "",
            File          = "",
            Folder        = "",
            Function      = "󰊕",
            Interface     = "",
            Key           = "",
            Keyword       = "",
            Method        = "󰊕",
            Module        = "",
            Namespace     = "󰦮",
            Null          = "",
            Number        = "󰎠",
            Object        = "",
            Operator      = "",
            Package       = "",
            Property      = "",
            Reference     = "",
            Snippet       = "",
            String        = "",
            Struct        = "󰆼",
            TabNine       = "󰏚",
            Text          = "",
            TypeParameter = "",
            Unit          = "",
            Value         = "",
            Variable      = "󰀫",
          },
          abbr_width = 30,
          kind_width = 15,
          menu_width = 20,
          ellipsis_char = "…",
        }),
      },
      cmdline_cmp = {
        { "/", {
          mapping = mapping,
          sources = {
            { name = "buffer" },
          },
        }, },
        { ":", {
          mapping = mapping,
          sources = cmp.config.sources({
            { name = "cmdline" },
            { name = "path" },
          }),
        }, },
      },
    }
    return opts
  end,
  config = function(_, opts)
    local cmp = require("cmp")

    cmp.setup(opts)

    for _, cmdline in ipairs(opts.cmdline_cmp) do
      cmp.setup.cmdline(cmdline[1], cmdline[2])
    end
  end,
}
