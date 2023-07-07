----------------
---- Packer ----
----------------

require('packer').startup(function()
    use 'wbthomason/packer.nvim'
    
    use 'neovim/nvim-lspconfig'
    use 'nvim-treesitter/nvim-treesitter'

    use { 'kyazdani42/nvim-tree.lua', requires = 'kyazdani42/nvim-web-devicons' }
    use { 'nvim-lualine/lualine.nvim', requires = 'kyazdani42/nvim-web-devicons' }

    use 'windwp/nvim-autopairs'
    use { 'kevinhwang91/nvim-ufo', requires = 'kevinhwang91/promise-async' }
    use 'preservim/nerdcommenter'
    
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-nvim-lsp-signature-help'
    use 'hrsh7th/nvim-cmp'

    use 'L3MON4D3/LuaSnip'
    use 'saadparwaiz1/cmp_luasnip'

    use { 'nvim-telescope/telescope.nvim', requires = 'nvim-lua/plenary.nvim' }

    use 'morhetz/gruvbox'
    use 'joshdick/onedark.vim'
end)


-------------------------
---- Global Settings ----
-------------------------

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.opt.mouse = 'a'

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

vim.opt.encoding = 'utf-8'

vim.opt.ruler = true
vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.fillchars = { eob = ' ' }

vim.opt.undofile = true

vim.opt.autoread = true
vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'CursorHoldI', 'FocusGained' }, {
    pattern = { '*' },
    command = 'if mode() != \'c\' | checktime | endif',
})

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.pumheight = 12

vim.opt.signcolumn = 'yes'

vim.o.foldcolumn = '1'
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true

vim.opt.cindent = true
vim.opt.cinoptions = { 'N-s', 'g0', 'j1', '(s', 'm1' }

vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

vim.opt.termguicolors = true

vim.opt.exrc = true

------------------
---- Keybinds ----
------------------


vim.keymap.set('n', '=', [[<cmd>vertical resize +5<cr>]], { noremap = true })
vim.keymap.set('n', '-', [[<cmd>vertical resize -5<cr>]], { noremap = true })
vim.keymap.set('n', '+', [[<cmd>horizontal resize +2<cr>]], { noremap = true })
vim.keymap.set('n', '_', [[<cmd>horizontal resize -2<cr>]], { noremap = true })

vim.keymap.set('t', '<esc>', [[<C-\><C-N>]], { noremap = true })

vim.keymap.set('t', '<C-w><left>', [[<C-\><C-N><C-w><left>]], { noremap = true })
vim.keymap.set('t', '<C-w><up>', [[<C-\><C-N><C-w><up>]], { noremap = true })
vim.keymap.set('t', '<C-w><right>', [[<C-\><C-N><C-w><right>]], { noremap = true })
vim.keymap.set('t', '<C-w><down>', [[<C-\><C-N><C-w><down>]], { noremap = true })

function table_length(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

vim.keymap.set('n', '<leader>1', [[<cmd>w<CR>]], { noremap = true })

vim.keymap.set('n', '<leader>@', function()
    local current_buffer = vim.api.nvim_get_current_buf()
    local is_modified = vim.api.nvim_buf_get_option(current_buffer, 'modified')
    if is_modified then
        error('Cannot quit modified buffer!')
    end
    vim.cmd('q')
end, { noremap = true })

vim.keymap.set('n', '<leader>4', function()
    local buffers_left = table_length(vim.fn.getbufinfo({ buflisted = 1 }))
    local current_buffer = vim.api.nvim_get_current_buf()
    local is_modified = vim.api.nvim_buf_get_option(current_buffer, 'modified')
    if is_modified then
        error('Cannot delete modified buffer!')
    end
    if buffers_left == 1 then
        vim.api.nvim_create_buf(true, true)
    end
    vim.cmd('bn | bd#')
end, { noremap = true })

vim.api.nvim_create_autocmd({ 'BufEnter', 'BufNew' }, {
    pattern = 'term://*',
    callback = function()
        vim.schedule(function()
            vim.cmd('startinsert')
        end)
    end
})

vim.api.nvim_create_autocmd({ 'BufLeave', 'FocusLost' }, {
    callback = function()
        vim.cmd('silent! wall')
    end
})


--------------------
---- LSP Config ----
--------------------

local lsp_on_attach = function(client, bufnr)
    local opts = { noremap = true, silent = true, buffer = true }

    vim.keymap.set('n', 'gD', [[<cmd>lua vim.lsp.buf.declaration()<CR>]], opts)
    vim.keymap.set('n', 'gd', [[<cmd>lua vim.lsp.buf.definition()<CR>]], opts)
    vim.keymap.set('n', 'gi', [[<cmd>lua vim.lsp.buf.implementation()<CR>]], opts)
    vim.keymap.set('n', 'gr', [[<cmd>lua vim.lsp.buf.references()<CR>]], opts)
    vim.keymap.set('n', 'gy', [[<cmd>lua vim.lsp.buf.type_definition()<CR>]], opts)
    vim.keymap.set('n', 'K', [[<cmd>lua vim.lsp.buf.hover()<CR>]], opts)
    vim.keymap.set('n', '<C-k>', [[<cmd>lua vim.lsp.buf.signature_help()<CR>]], opts)

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

capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true
}

local util = require('lspconfig/util')

local path = util.path

local function get_python_path(workspace)
    if vim.env.VIRTUAL_ENV then
        return path.join(vim.env.VIRTUAL_ENV, 'bin', 'python')
    end

    for _, pattern in ipairs({'*', '.*'}) do
        local match = vim.fn.glob(path.join(workspace, pattern, 'pyvenv.cfg'))
        if match ~= '' then
            return path.join(path.dirname(match), 'bin', 'python')
        end
    end

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
        'clangd',
        '--header-insertion=never',
        '--completion-style=detailed',
        '--pretty',
    },
    flags = {
        debounce_text_changes = 0,
    },
    capabilities = capabilities
})


--------------------
---- Treesitter ----
--------------------

require('nvim-treesitter.configs').setup {
    ensure_installed = { 'c', 'cpp', 'css', 'html', 'javascript', 'lua', 'python' },
    auto_install = false,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = true,
    },
}


-------------------
---- Nvim Tree ----
-------------------

local function on_attach(bufnr)
    local api = require('nvim-tree.api')

    local function opts(desc)
        return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    api.config.mappings.default_on_attach(bufnr)
    vim.keymap.del('n', 'd', { buffer = bufnr })
end

require('nvim-tree').setup({
    on_attach = on_attach,
    hijack_netrw = false,
    renderer = {
        icons = {
            glyphs = {
                git = {
                    unstaged = 'T',
                    staged = 'S',
                    unmerged = 'M',
                    renamed = 'R',
                    untracked = 'U',
                    deleted = 'D',
                    ignored = 'I',
                },
            },
        },
    },
})

vim.api.nvim_create_autocmd('QuitPre', {
    callback = function()
        local invalid_win = {}
        local wins = vim.api.nvim_list_wins()
        for _, w in ipairs(wins) do
            local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
            if bufname:match('NvimTree_') ~= nil then
                table.insert(invalid_win, w)
            end
        end
        if #invalid_win == #wins - 1 then
            -- Should quit, so we close all invalid windows.
            for _, w in ipairs(invalid_win) do vim.api.nvim_win_close(w, true) end
        end
    end
})

local function open_nvim_tree(data)
    local directory = vim.fn.isdirectory(data.file) == 1
    if directory then
        vim.api.nvim_create_buf(true, true)
        vim.cmd.bw(data.buf)
        vim.cmd.cd(data.file)
    elseif data.file == '' then
        vim.bo.buftype = 'nofile'
        vim.bo.bufhidden = 'hide'
    end
    
    require('nvim-tree.api').tree.toggle({
        focus = directory
    })
end

vim.api.nvim_create_autocmd({ 'VimEnter' }, { callback = open_nvim_tree })

vim.keymap.set('n', '<leader>f', [[<cmd>NvimTreeToggle<CR>]], { noremap = true })


-----------------
---- Lualine ----
-----------------

require('lualine').setup {
    options = {
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
    },
    sections = {
        lualine_c = {
            {
                'filename',
                file_status = true,
                newfile_status = true,
                path = 1,
            }
        }
    }
}


------------------------
---- Nvim Autopairs ----
------------------------

require('nvim-autopairs').setup {
    
}


------------------
---- Nvim UFO ----
------------------

local ufo = require('ufo')

ufo.setup {

}

vim.keymap.set('n', 'zR', ufo.openAllFolds)
vim.keymap.set('n', 'zM', ufo.closeAllFolds)


------------------------
---- Nerd Commenter ----
------------------------

vim.g.NERDCreateDefaultMappings = 0
vim.g.NERDSpaceDelims = 1
vim.keymap.set('n', '<leader>c', [[<Plug>NERDCommenterToggle]], { noremap = true })


------------------
---- Nvim Cmp ----
------------------

local cmp_kinds = {
    Text = '',
    Method = '',
    Function = '',
    Constructor = '',
    Field = '',
    Variable = '',
    Class = '',
    Interface = '',
    Module = '',
    Property = '',
    Unit = '',
    Value = '',
    Enum = '',
    Keyword = '',
    Snippet = '',
    Color = '',
    File = '',
    Reference = '',
    Folder = '',
    EnumMember = '',
    Constant = '',
    Struct = '',
    Event = '',
    Operator = '',
    TypeParameter = '',
}

local cmp = require('cmp')
local luasnip = require('luasnip')

local ELLIPSIS_CHAR = '…'
local MAX_ABBR_WIDTH = 25
local MIN_ABBR_WIDTH = 25
local MAX_KIND_WIDTH = 15
local MIN_KIND_WIDTH = 15
local MAX_MENU_WIDTH = 15
local MIN_MENU_WIDTH = 15

cmp.setup({
    enabled = true,
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = {
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<tab>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 'c' }),
        ['<S-tab>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' }),
        ['<down>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 'c' }),
        ['<up>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' }),
        ['<C-e>'] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
        }),
        ['<CR>'] = cmp.mapping.confirm({ select = false }),
    },
    formatting = {
        fields = { 'abbr', 'kind', 'menu' },
        format = function(entry, vim_item)
            vim_item.kind = (cmp_kinds[vim_item.kind] or '') .. '  ' .. vim_item.kind
            local abbr = vim_item.abbr
            local truncated_abbr = vim.fn.strcharpart(abbr, 0, MAX_ABBR_WIDTH)
            if truncated_abbr ~= abbr then
                vim_item.abbr = truncated_abbr .. ELLIPSIS_CHAR
            elseif string.len(abbr) < MIN_ABBR_WIDTH then
                local padding = string.rep(' ', MIN_ABBR_WIDTH - string.len(abbr))
                vim_item.abbr = abbr .. padding
            end
            local kind = vim_item.kind
            local truncated_kind = vim.fn.strcharpart(kind, 0, MAX_KIND_WIDTH)
            if truncated_kind ~= kind then
                vim_item.kind = truncated_kind .. ELLIPSIS_CHAR
            elseif string.len(kind) < MIN_KIND_WIDTH then
                local padding = string.rep(' ', MIN_KIND_WIDTH - string.len(kind))
                vim_item.kind = kind .. padding
            end
            local menu = vim_item.menu
            if menu == nil then
                menu = ''
            end
            local truncated_menu = vim.fn.strcharpart(menu, 0, MAX_MENU_WIDTH)
            if truncated_menu ~= menu then
                vim_item.menu = truncated_menu .. ELLIPSIS_CHAR
            elseif string.len(menu) < MIN_MENU_WIDTH and menu ~= '' then
                local padding = string.rep(' ', MIN_MENU_WIDTH - string.len(menu))
                vim_item.menu = menu .. padding
            end
            return vim_item
        end
    },
    sources = cmp.config.sources(
        {
            { name = 'nvim_lsp', priority = 1 },
            { name = 'luasnip', priority = 5 },
        },
        {
            { name = 'buffer' },
        },
        {
            { name = 'nvim_lsp_signature_help' },
        }
    )
})

cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    })
})

local cmp_enabled = true
vim.api.nvim_create_user_command('CmpToggleBufferAutoComplete', function()
    cmp_enabled = not cmp_enabled
    cmp.setup.buffer({ enabled = cmp_enabled })
end, {})

vim.keymap.set({ 'n', 'i' }, '<C-t>',
    '<cmd>CmpToggleBufferAutoComplete<CR>',
    { noremap = true, silent = true })


-----------------
---- Luasnip ----
-----------------

vim.cmd[[
imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>' 
inoremap <silent> <S-Tab> <cmd>lua require'luasnip'.jump(-1)<CR>
snoremap <silent> <Tab> <cmd>lua require('luasnip').jump(1)<CR>
snoremap <silent> <S-Tab> <cmd>lua require('luasnip').jump(-1)<CR>
]]

-------------------
---- Telescope ----
-------------------

require('telescope').setup {

}

vim.keymap.set('n', '<leader>tt', [[<cmd>Telescope<CR>]], { noremap = true })
vim.keymap.set('n', '<leader>b', [[<cmd>Telescope buffers<CR>]], { noremap = true })
vim.keymap.set('n', '<leader>tg', [[<cmd>Telescope live_grep<CR>]], { noremap = true })
vim.keymap.set('n', '<leader>tk', [[<cmd>Telescope keymaps<CR>]], { noremap = true })

tt = require('ext.telescope-tasks')
vim.keymap.set('n', '<leader>p', [[<cmd>TaskPrevious<CR>]], { noremap = true })
vim.keymap.set('n', '<leader>o', [[<cmd>TaskRun<CR>]], { noremap = true })


---------------------
---- Colorscheme ----
---------------------

local transparent_bg_group = vim.api.nvim_create_augroup('transparentBackground', {})

vim.api.nvim_create_autocmd('ColorScheme', {
    callback = function() 
        vim.api.nvim_set_hl(0, 'Normal', { bg = 'NONE', ctermbg = 'NONE' })
        vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'NONE', ctermbg = 'NONE' })
        vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'NONE', ctermbg = 'NONE' })
        vim.api.nvim_set_hl(0, 'NonText', { ctermbg = 'NONE' })
        vim.api.nvim_set_hl(0, 'SignColumn', { bg = 'NONE', ctermbg = 'NONE' })
    end,
    group = transparent_bg_group,
})

vim.api.nvim_create_autocmd('ColorScheme', {
    callback = function() 
        vim.api.nvim_set_hl(0, 'NonText', { ctermbg = 'NONE' })
    end,
    group = transparent_bg_group,
})

vim.api.nvim_create_autocmd('ColorScheme', {
    callback = function()
        vim.api.nvim_set_hl(0, 'SignColumn', { bg = 'NONE', ctermbg = 'NONE' })
    end,
    group = transparent_bg_group,
})

local hl_override_group = vim.api.nvim_create_augroup('highlightOverride', {})

vim.api.nvim_create_autocmd('ColorScheme', {
    pattern = { 'gruvbox', 'onedark' },
    callback = function()
        vim.api.nvim_set_hl(0, 'CmpItemAbbrMatch', { link = 'Identifier' })
        vim.api.nvim_set_hl(0, 'CmpItemAbbrMatchFuzzy', { link = 'Identifier' })
        vim.api.nvim_set_hl(0, 'CmpItemKindVariable', { link = 'Identifier' })
        vim.api.nvim_set_hl(0, 'CmpItemKindInterface', { link = 'Identifier' })
        vim.api.nvim_set_hl(0, 'CmpItemKindText', { link = 'String' })
        vim.api.nvim_set_hl(0, 'CmpItemKindFunction', { link = 'Function' })
        vim.api.nvim_set_hl(0, 'CmpItemKindMethod', { link = 'Function' })
        vim.api.nvim_set_hl(0, 'CmpItemKindKeyword', { link = 'Keyword' })
        vim.api.nvim_set_hl(0, 'CmpItemKindProperty', { link = 'Keyword' })
        vim.api.nvim_set_hl(0, 'CmpItemKindUnit', { link = 'Keyword' })
    end,
    group = hl_override_group,
})

vim.cmd.colorscheme('gruvbox')
