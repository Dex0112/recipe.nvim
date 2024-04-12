local M = {}

-- Do these need to go in module?
local bufnr = nil
local win = nil
local augroup = vim.api.nvim_create_augroup('TodoList', { clear = true })

local timerEnd = true

--TODO: Add saving behaviour based on working directory for easy pickup

M.setup = function(opts)
    -- Set default mappings or whatnot
    -- A opt for that takes a function that decides how the todo opens
    -- Ex: time
    opts = opts or {
        time = 10 * 60 * 1000,
        open_todo = function()
            vim.cmd('rightbelow vsplit')

            win = vim.api.nvim_get_current_win()

            vim.api.nvim_win_set_buf(win, bufnr)
        end,
    }

    bufnr = vim.api.nvim_create_buf(false, true)

    M.open_todo = opts['open_todo']

    vim.api.nvim_create_autocmd('BufWinLeave', {
        group = augroup,
        buffer = bufnr,
        callback = function()
            if timerEnd then
                timerEnd = false
                vim.defer_fn(function()
                    M.open_todo()
                    timerEnd = true
                end, opts['time'])
            end
        end
    })
end

M.end_todo = function()

end

return M
