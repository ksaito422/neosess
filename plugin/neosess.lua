if vim.g.loaded_neosess then
    return
end
vim.g.loaded_neosess = 1

vim.api.nvim_command('command! -nargs=1 SaveSession lua require("neosess").save_session(<f-args>)')
vim.api.nvim_command('command! -nargs=1 LoadSession lua require("neosess").load_session(<f-args>)')
vim.api.nvim_command('command! -nargs=0 DisplaySession lua require("neosess").display_session_files()')
