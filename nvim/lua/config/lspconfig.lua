local lsp_on_attach = function(client, bufnr)
    local opts = { noremap = true, silent = true, buffer = true }

    vim.keymap.set('n', 'gD', [[<cmd>lua vim.lsp.buf.declaration()<CR>]], opts)
    vim.keymap.set('n', 'gd', [[<cmd>lua vim.lsp.buf.definition()<CR>]], opts)
    vim.keymap.set('n', 'K', [[<cmd>lua vim.lsp.buf.hover()<CR>]], opts)
    vim.keymap.set('n', 'gi', [[<cmd>lua vim.lsp.buf.implementation()<CR>]], opts)
    vim.keymap.set('n', '<C-k>', [[<cmd>lua vim.lsp.buf.signature_help()<CR>]], opts)
    vim.keymap.set('n', 'gr', [[<cmd>lua vim.lsp.buf.references()<CR>]], opts)
    vim.keymap.set('n', 'gy', [[<cmd>lua vim.lsp.buf.type_definition()<CR>]], opts)

    vim.keymap.set('n', '<leader>lr', [[<cmd>lua vim.lsp.buf.rename()<CR>]], opts)
    vim.keymap.set('n', '<leader>lf', [[<cmd>lua vim.lsp.buf.code_action()<CR>]], opts)
    vim.keymap.set('n', '<leader>le', [[<cmd>lua vim.diagnostic.open_float({scope="c"})<CR>]], opts)
    vim.keymap.set('n', '[d', [[<cmd>lua vim.diagnostic.goto_prev()<CR>]], opts)
    vim.keymap.set('n', ']d', [[<cmd>lua vim.diagnostic.goto_next()<CR>]], opts)
    vim.keymap.set('n', '<leader>lq', [[<cmd>lua vim.diagnostic.setloclist()<CR>]], opts)

    vim.keymap.set('n', '<Leader>lw', [[<cmd>lua vim.lsp.buf.formatting()<CR>]], opts)
    vim.keymap.set('v', '<Leader>lw', [[<cmd>lua vim.lsp.buf.range_formatting()<CR>]], opts)
end

vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        underline = true,
        virtual_text = {
            spacing = 8,
            severity_limit = 'Error',
        },
        signs = false,
        update_in_insert = false,
    }
)

local capabilities = require('cmp_nvim_lsp').default_capabilities(
    vim.lsp.protocol.make_client_capabilities()
)
capabilities.textDocument.completion.completionItem.snippetSupport = false
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = { 'documentation', 'detail', 'additionalTextEdits' },
}


local util = require('lspconfig/util')

local path = util.path

local function get_python_path(workspace)
    -- Use activated virtualenv.
    if vim.env.VIRTUAL_ENV then
        return path.join(vim.env.VIRTUAL_ENV, 'bin', 'python')
    end

    -- Find and use virtualenv in workspace directory.
    for _, pattern in ipairs({'*', '.*'}) do
        local match = vim.fn.glob(path.join(workspace, pattern, 'pyvenv.cfg'))
        if match ~= '' then
            return path.join(path.dirname(match), 'bin', 'python')
        end
    end

    -- Fallback to system Python.
    return exepath('python3') or exepath('python') or 'python'
end


require('lspconfig').pyright.setup({
    before_init = function(_, config)
        config.settings.python.analysis.autoImportCompletions = false
        config.settings.python.pythonPath = get_python_path(config.root_dir)
    end,
    on_attach = lsp_on_attach,
    capabilities = capabilities
})

require('lspconfig').clangd.setup({
    on_attach = lsp_on_attach,
    cmd = {
        '/usr/local/opt/llvm/bin/clangd',
        '--header-insertion=never',
        '--completion-style=detailed',
        '--pretty',
    },
    flags = {
        debounce_text_changes = 0,
    },
    capabilities = capabilities
})
