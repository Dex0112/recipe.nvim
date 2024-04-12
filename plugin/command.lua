vim.api.nvim_create_user_command('RecipeStart', function ()
    local recipe = require('recipe')
    recipe.setup(nil)
    recipe.open_todo()
end, {})

vim.api.nvim_create_user_command('RecipeEnd', function ()
    require('recipe').end_todo()
end, {})

vim.api.nvim_create_user_command('RecipeReload', function ()
    package.loaded["recipe"] = nil
    require('recipe')
end, {})
