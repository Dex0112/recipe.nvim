-- require("recipe")

vim.keymap.set('n', '<leader>vt', function() require('recipe').open_todo() end, {})

-- local bufnr = vim.api.nvim_create_buf(false, false)
-- 
-- vim.api.nvim_set_current_buf(bufnr)
-- 
-- print(bufnr)
