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

-- vim.cmd [[
-- let s:timer = 0
-- autocmd TextChangedI * call s:on_text_changed()
-- function! s:on_text_changed() abort
    -- call timer_stop(s:timer)
    -- let s:timer = timer_start(300, function('s:complete'))
-- endfunction
-- function! s:complete(...) abort
    -- lua require('cmp').complete({ reason = require('cmp').ContextReason.Auto })
-- endfunction
-- ]]
