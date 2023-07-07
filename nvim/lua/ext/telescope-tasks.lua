local themes = require('telescope.themes')
local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local entry_display = require('telescope.pickers.entry_display')
local conf = require('telescope.config').values
local resolve = require('telescope.config.resolve')

local M = {}

local inputs = {}
local categories = {}

local parse_task
local get_task
local get_category

local previous_task = function() end

function themes.vscode(opts)
    opts = opts or {}
    local theme_opts = {
        theme = 'dropdown',
        sorting_strategy = 'ascending',
        layout_strategy = 'vertical',
        layout_config = {
            anchor = 'N',
            prompt_position = 'top',
            width = function(_, max_columns, _)
                return math.min(max_columns, 120)
            end,
            height = function(_, _, max_lines)
                return math.min(max_lines, 15)
            end,
        },
    }
    if opts.layout_config and opts.layout_config.prompt_position == 'bottom' then
        theme_opts.borderchars = {
            prompt = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
            results = { '─', '│', '─', '│', '╭', '╮', '┤', '├' },
            preview = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
        }
    end
    return vim.tbl_deep_extend('force', theme_opts, opts)
end

local function vscode()
    return require('telescope.themes').vscode({})
end

local function table_length(T)
    local count = 0
    for _ in pairs(T) do
        count = count + 1
    end
    return count
end

function parse_task(opts, category, task, idx, final_input)
    opts = opts or {}
    idx = idx or 1
    final_input = final_input or {}

    local function traverse(dx)
        idx = idx + dx
        if idx < 1 then
            get_tasks(opts, category)
        else
            parse_task(opts, category, task, idx, final_input)
        end
    end

    if idx > table_length(task.inputs) then
        previous_task = function()
            task.command(final_input)
        end
        previous_task()
        return
    end

    local input_id = task.inputs[idx]
    local input = inputs[input_id]
    local input_type = input.type or 'prompt'
    local input_default = input.default or ''
    local input_choices = input.choices or {}

    local prompt_title = input.name or input_id
    local results_title = input.help or false
        
    if input_default ~= '' and input_type == 'prompt' then
        prompt_title = prompt_title ..
                        ' (default: \'' .. input_default .. '\')'
    end
    prompt_title = prompt_title .. ' | ' .. task.name

    
    if input_type == 'prompt' then
        pickers.new(opts, {
            prompt_title = prompt_title,
            results_title = results_title,
            finder = finders.new_table({
                results = {},
            }),
            sorter = conf.generic_sorter(opts),
            attach_mappings = function(prompt_bufnr, map)
                map('i', '<C-b>', function()
                    traverse(-1)
                end)
                map('n', '<C-b>', function()
                    traverse(-1)
                end)
                
                actions.select_default:replace(function()
                    local current_picker = require('telescope.actions.state')
                                            .get_current_picker(prompt_bufnr)
                    local prompt = current_picker:_get_prompt()
                    actions.close(prompt_bufnr)
                    if prompt == '' or prompt == nil then
                        prompt = input_default
                    end
                    final_input[input_id] = prompt
                    traverse(1)
                end)
                return true
            end,
        }):find()
    elseif input_type == 'pick' then
        pickers.new(opts, {
            prompt_title = prompt_title,
            results_title = results_title,
            finder = finders.new_table({
                results = input_choices,
                entry_maker = function(entry)
                    local value_width = 36

                    local displayer = entry_display.create({
                        separator = ' ▏',
                        items = {
                            { width = value_width },
                            { remaining = true },
                        },
                    })

                    local function make_display()
                        return displayer({
                            { entry.value },
                            { entry.description or '' },
                        })
                    end

                    return {
                        value = entry,
                        display = make_display,
                        ordinal = string.format('%s %s',
                                                entry.value,
                                                entry.description or ''),
                    }
                end,
            }),
            sorter = conf.generic_sorter(opts),
            attach_mappings = function(prompt_bufnr, map)
                map('i', '<C-b>', function()
                    traverse(-1)
                end)
                map('n', '<C-b>', function()
                    traverse(-1)
                end)

                actions.select_default:replace(function()
                    actions.close(prompt_bufnr)
                    local selection = action_state.get_selected_entry()
                    local value = selection.value.value
                    final_input[input_id] = value
                    traverse(1)
                end)
                return true
            end,
        }):find()
    end
end

function get_task(opts, category)
    opts = opts or {}

    pickers.new(opts, {
        prompt_title = category.name,
        results_title = false,
        finder = finders.new_table({
            results = category.tasks,
            entry_maker = function(entry)
                local command_width = 36

                local displayer = entry_display.create({
                    separator = ' ▏',
                    items = {
                        { width = command_width },
                        { remaining = true },
                    },
                })

                local function make_display()
                    return displayer({
                        { entry.name },
                        { entry.description or '' },
                    })
                end

                return {
                    value = entry,
                    display = make_display,
                    ordinal = string.format('%s %s',
                                            entry.name,
                                            entry.description or ''),
                }
            end,
        }),
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr, map)
            map('i', '<C-b>', function()
                get_category(opts)
            end)
            map('n', '<C-b>', function()
                get_category(opts)
            end)

            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                local task = selection.value
                parse_task(opts, category, task, 1, {})
            end)
            return true
        end,
    }):find()
end

function get_category(opts)
    pickers.new(opts, {
        prompt_title = 'Categories',
        results_title = false,
        finder = finders.new_table({
            results = categories,
            entry_maker = function(entry)
                local command_width = 36

                local displayer = entry_display.create({
                    separator = ' ▏',
                    items = {
                        { width = command_width },
                        { remaining = true },
                    },
                })

                local function make_display()
                    return displayer({
                        { entry.name },
                        { entry.description or '' },
                    })
                end

                return {
                    value = entry,
                    display = make_display,
                    ordinal = string.format('%s %s',
                                            entry.name,
                                            entry.description or ''),
                }
            end,
        }),
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                if selection == nil then
                    return true
                end
                local category = selection.value
                get_task(opts, category)
            end)
            return true
        end,
    }):find()
end

local function add_task_mapping(category, task)
    if task.mapping ~= nil then
        vim.keymap.set('n', task.mapping, function()
            parse_task(vscode(), category, task, 1, {})
        end, { noremap = true })
    end
end

local function add_category_mapping(category)
    if category.mapping ~= nil then
        vim.keymap.set('n', category.mapping, function()
            get_task(vscode(), category)
        end, { noremap = true })
    end
    for _, task in pairs(category.tasks) do
        add_task_mapping(category, task)
    end
end

function M.extend_inputs(new_inputs)
    inputs = vim.tbl_extend('force', inputs, new_inputs)
end

function M.extend_categories(new_categories)
    for _, category in pairs(new_categories) do
        add_category_mapping(category)
    end
    vim.list_extend(categories, new_categories)
end

local function run_task()
    get_category(vscode())
end

local function run_previous_task()
    previous_task()
end

vim.api.nvim_create_user_command('TaskRun', run_task, { nargs = 0 })
vim.api.nvim_create_user_command('TaskPrevious', run_previous_task, { nargs = 0 })

return M
