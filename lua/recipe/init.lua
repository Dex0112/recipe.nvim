local M = {}

local bufnr = nil

local endTimer = true

M.setup = function(opts)
    -- Set default mappings or whatnot
    -- A opt for that takes a function that decides how the todo opens
    -- Ex: time
    opts = opts or {}

    M.create_todo()

    vim.keymap.set('n', '<leader>q', function()
        vim.cmd('q')
        M.close_todo()
    end, { buffer = bufnr })
end

M.create_todo = function()
    bufnr = vim.api.nvim_create_buf(false, true)

    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {
        "Yo what up fool?",
        "You be kind stupid looking right now",
        "This is a test to see if I can initialize a buffer with some text btw",
    })
end

M.open_todo = function()
    vim.cmd('rightbelow vsplit')

    local win = vim.api.nvim_get_current_win()

    vim.api.nvim_win_set_buf(win, bufnr)
end

-- Wait 10 seconds

M.close_todo = function()
    vim.cmd('bp')

    if endTimer then
        vim.defer_fn(function()
            M.open_todo()
        end, 1000 * 10)
    end
end

-- vim.api.nvim_create_augroup('Todo', {})
-- vim.api.nvim_create_augroup events I think
-- vim.defer_fn

return M
