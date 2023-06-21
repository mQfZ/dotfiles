require('telescope').setup {

}


vim.keymap.set('n', '<leader>t', [[<cmd>Telescope<CR>]], { noremap = true })
vim.keymap.set('n', '<leader>b', [[<cmd>Telescope buffers<CR>]], { noremap = true })


tt = require('config.ext.telescope-tasks')
vim.keymap.set('n', '<leader>p', [[<cmd>TaskPrevious<CR>]], { noremap = true })
vim.keymap.set('n', '<leader>o', [[<cmd>TaskRun<CR>]], { noremap = true })
