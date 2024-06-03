return {
  "neovim/nvim-lspconfig",
  event = "LazyFile",
  dependencies = {
    "folke/neodev.nvim",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
  },
  keys = {
    { "<Leader>em", "<CMD>LspInfo<CR>", desc = "Lsp Info" },
    { "<Leader>eR", "<CMD>LspRestart<CR>", desc = "LSP Restart" },
  },
  opts = {
    diagnostics = {
      underline = true,
      update_in_insert = false,
      virtual_text = {
        spacing = 4,
        source = "if_many",
        prefix = "icons",
      },
      severity_sort = true,
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = config.icons.diagnostics.Error,
          [vim.diagnostic.severity.WARN] = config.icons.diagnostics.Warn,
          [vim.diagnostic.severity.HINT] = config.icons.diagnostics.Hint,
          [vim.diagnostic.severity.INFO] = config.icons.diagnostics.Info,
        },
      },
    },
    -- stylua: ignore
    keymaps = {
      { "<Leader>er", vim.lsp.buf.rename, desc = "Rename" },
      { "<Leader>ea", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "v" }, has = "codeAction" },
      { "<Leader>ei", function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({})) end, desc = "Toggle Inlay Hints", has = "inlayHint" },
      { "K", vim.lsp.buf.hover, desc = "Hover" },
      { "<C-k>", vim.lsp.buf.signature_help, desc = "Signature Help", mode = { "n", "i" }, has = "signatureHelp" },
      { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
      { "gd", function() require("telescope.builtin").lsp_definitions({ reuse_win = true }) end, desc = "Goto Definition", has = "definition" },
      { "gr", function() require("telescope.builtin").lsp_references({ reuse_win = true }) end, desc = "References" },
      { "gI", function() require("telescope.builtin").lsp_implementations({ reuse_win = true }) end, desc = "Goto Implementation" },
      { "gy", function() require("telescope.builtin").lsp_type_definitions({ reuse_win = true }) end, desc = "Goto Type Definition" },
      { "]]", vim.diagnostic.goto_next, desc = "Next Reference", has = "documentHighlight" },
      { "[[", vim.diagnostic.goto_prev, desc = "Previous Reference", has = "documentHighlight" },
    },
    inlay_hints = {
      enabled = false,
    },
    capabilities = {
      flags = {
        debounce_text_changes = 150,
      },
    },
    servers = {},
  },
  config = function(_, opts)
    require("neodev").setup(util.opts("neodev.nvim"))

    util.lsp.on_attach(function(_, bufnr)
      for _, keymap in ipairs(opts.keymaps) do
        if not keymap.has or util.lsp.has(bufnr, keymap.has) then
          local keyopts = { desc = keymap.desc, silent = keymap.silent ~= false, buffer = bufnr }
          vim.keymap.set(keymap.mode or "n", keymap[1], keymap[2], keyopts)
        end
      end
    end)

    for severity, icon in pairs(opts.diagnostics.signs.text or {}) do
      local name = vim.diagnostic.severity[severity]:lower():gsub("^%l", string.upper)
      vim.fn.sign_define(name, { text = icon, texthl = "DiagnosticSign" .. name, numhl = "" })
    end

    opts.diagnostics.virtual_text.prefix = function(diagnostic)
      for severity, icon in pairs(opts.diagnostics.signs.text or {}) do
        if diagnostic.severity == severity then
          return icon
        end
      end
    end

    vim.diagnostic.config(vim.deepcopy(opts.diagnostics))
    vim.lsp.inlay_hint.enable(opts.inlay_hints.enabled)

    local capabilities = vim.tbl_deep_extend(
      "force",
      {},
      vim.lsp.protocol.make_client_capabilities(),
      require("cmp_nvim_lsp").default_capabilities(),
      opts.capabilities or {}
    )

    local function setup(server)
      local server_opts = vim.tbl_deep_extend("force", {
        capabilities = vim.deepcopy(capabilities),
      }, opts.servers[server] or {})
      require("lspconfig")[server].setup(server_opts)
    end

    for server, server_opts in pairs(opts.servers) do
      if server_opts.mason == false then
        setup(server)
      end
    end

    require("mason-lspconfig").setup({ handlers = { setup } })
  end,
}
