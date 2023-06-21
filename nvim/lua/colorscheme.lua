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
