local M = {}

local function load_session(file, win_id)
    vim.api.nvim_win_close(win_id, true)
    vim.api.nvim_command('source ' .. file)
end

local function delete_session(file, win_id)
    vim.api.nvim_win_close(win_id, true)
    os.remove(file)
    vim.api.nvim_echo({ { 'neosess: ' .. file .. ' has been deleted.' } }, true, {})
end

-- Define actions that can be operated in the float windows
function ProcessLine(line, win_id, mode)
    if mode == 'load' then
        load_session(line, win_id)
    elseif 'delete' then
        delete_session(line, win_id)
    end
end

return M
