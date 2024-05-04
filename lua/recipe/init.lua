local popup = require("plenary.popup")
local M = {}

local popup_bufnr = nil
local popup_win_id = nil

local todo_elements = {
    "Your mom",
    "Your dad",
    "Finish coding",
    "Rewrite universe",
}

-- Do these need to go in module?
-- local win_id = nil
-- local augroup = vim.api.nvim_create_augroup('TodoList', { clear = true })


--TODO: Add saving behaviour based on working directory for easy pip

function M.setup(opts)
    -- Set default mappings or whatnot
    -- A opt for that takes a function that decides how the todo opens
    -- Ex: time

    opts = opts or {
        time = 10 * 1000,
    }
end

function M.end_todo()
    -- TODO
end

function M.toggle_menu()
    if popup_win_id ~= nil and vim.api.nvim_win_is_valid(popup_win_id) then
        -- close popup
        vim.api.nvim_win_close(popup_win_id, true)

        popup_win_id = nil
        return
    end

    local popup_window = M.create_overview()
    popup_win_id = popup_window.win_id
    popup_bufnr = popup_window.bufnr

    -- Maybe set the ● in like the sign column or something so you can just edit 
    -- vim.api.nvim_buf_set_option(popup_bufnr, "modifiable", false) if this doesn't work
    for i = 0, #todo_elements - 1, 1 do
        vim.api.nvim_buf_set_lines(popup_bufnr, i, i, false, { "● " .. todo_elements[i + 1] })
    end

    -- apply keymaps and whatever
    vim.keymap.set('n', '<CR>', function()
        local idx = vim.api.nvim_win_get_cursor(popup_win_id)[1]
        print("You are on line " .. idx)

        -- Goto new buffer with this popup in it
    end, { buffer = popup_bufnr })

    vim.keymap.set('n', 'q', function()
        -- We need to save
        M.toggle_menu()
    end, { buffer = popup_bufnr })

    -- TODO: add keymaps for marking complete and unmarking complete 
    -- vim.keymap.set('n', 'a', function()
        -- Create new todo item
    -- end)

    -- vim.keymap.set('n', '', function()
        -- Edit item
    -- end)
end

function M.create_overview()
    local width = 80
    local height = 40
    local borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }
    local bufnr = popup_bufnr or vim.api.nvim_create_buf(false, true)

    local recipe_win_id, win = popup.create(bufnr, {
        title = "Recipe Overview",
        highlight = "RecipeWindow",
        line = math.floor(((vim.o.lines - height) / 2) - 1),
        col = math.floor((vim.o.columns - width) / 2),
        minwidth = width,
        minheight = height,
        borderchars = borderchars,
    })

    vim.api.nvim_win_set_option(
        win.border.win_id,
        "winhl",
        "Normal:RecipeWindow"
    )

    return {
        bufnr = bufnr,
        win_id = recipe_win_id,
    }
end

return M
