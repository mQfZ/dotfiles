require('nvim-treesitter.configs').setup {
    ensure_installed = { 'c', 'cpp', 'css', 'html', 'javascript', 'lua', 'python' },
    auto_install = false,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = true,
    },
}

vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
