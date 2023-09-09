local ui = require('neosess.ui')

local M = {}

local function fetch_session_files()
    local function readdir()
        return vim.fn.globpath(SessionPath, '*', 1, 1)
    end

    local session_files = {}
    for _, file in ipairs(readdir(SessionPath)) do
        if vim.fn.isdirectory(SessionPath .. '/' .. file) == 0 then
            table.insert(session_files, file)
        end
    end

    return session_files
end

local function show_table_in_float_win(t)
    local bufnr = ui.create_float_win()
    local lines = {}
    for _, v in pairs(t) do
        table.insert(lines, tostring(v))
    end
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
end

function M.display()
    local res = fetch_session_files()
    show_table_in_float_win(res)
end

return M
