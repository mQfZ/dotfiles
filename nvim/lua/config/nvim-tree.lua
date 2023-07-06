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
