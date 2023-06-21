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

vim.opt.foldmethod = 'expr'
vim.opt.foldlevel = 99

vim.opt.cindent = true
vim.opt.cinoptions = { 'N-s', 'g0', 'j1', '(s', 'm1' }

vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

vim.opt.termguicolors = true

vim.opt.exrc = true


vim.keymap.set('n', '<leader>1', [[<cmd>w<CR>]], { noremap = true })

function table_length(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

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

vim.keymap.set('n', '<leader>%', function()
    local current_buffer = vim.api.nvim_get_current_buf()
    local is_modified = vim.api.nvim_buf_get_option(current_buffer, 'modified')
    if is_modified then
        error('Cannot quit modified buffer!')
    end
    vim.cmd('q')
end, { noremap = true })

vim.keymap.set('n', '<leader>z', [[za]], { noremap = true })


vim.api.nvim_create_autocmd({ 'BufEnter', 'BufNew' }, {
    pattern = 'term://*',
    callback = function()
        vim.schedule(function()
            vim.cmd('startinsert')
        end)
    end
})

vim.keymap.set('t', '<esc>', [[<C-\><C-N>]], { noremap = true })
vim.keymap.set('t', '<C-w><left>', [[<C-\><C-N><C-w><left>]], { noremap = true })
vim.keymap.set('t', '<C-w><up>', [[<C-\><C-N><C-w><up>]], { noremap = true })
vim.keymap.set('t', '<C-w><right>', [[<C-\><C-N><C-w><right>]], { noremap = true })
vim.keymap.set('t', '<C-w><down>', [[<C-\><C-N><C-w><down>]], { noremap = true })

vim.api.nvim_create_autocmd({ 'VimLeave' }, {
    callback = function()
        vim.opt.guicursor = 'a:ver20-blinkon500-blinkoff500'
    end
})

vim.api.nvim_create_autocmd({ 'BufLeave', 'FocusLost' }, {
    callback = function()
        vim.cmd('silent! wall')
    end
})
