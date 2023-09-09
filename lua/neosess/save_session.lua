local M = {}

-- If the directory does not exist, create it
local function dir_exists()
    local session_dir = vim.loop.fs_stat(SessionPath)
    if not session_dir then
        os.execute('mkdir -p ' .. SessionPath)
    end
end

-- If the file does not exist, create it
local function file_exists(session_file_path)
    local session_file = vim.loop.fs_stat(session_file_path)
    if not session_file then
        local f = assert(io.open(session_file_path, 'w'))
        f:close()
    end
end

-- Save the session
function M.save(file)
    local session_file_path = SessionPath .. '/' .. file .. '.vim'

    dir_exists()
    file_exists(session_file_path)

    vim.api.nvim_command('mksession! ' .. session_file_path)
    vim.api.nvim_command('redraw')
    vim.api.nvim_echo({ { 'neosess: session created.' } }, true, {})
end

return M
