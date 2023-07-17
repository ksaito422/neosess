if vim.g.loaded_neosess then
    return
end
vim.g.loaded_neosess = 1

vim.api.nvim_command('command! -nargs=1 SaveSession lua require("neosess").save_session(<f-args>)')
vim.api.nvim_command('command! -nargs=0 LoadSession lua require("neosess").display_session_files()')
