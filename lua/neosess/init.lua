local ui = require('neosess.ui')
local load_session = require('neosess.load_session')
local save_session = require('neosess.save_session')

local M = {}

function M.setup(opts)
    -- Define default values
    local session_dir = opts.session_path or '~/.config/nvim/sessions'
    SessionPath = vim.fn.expand(session_dir)
end

-- 保存したセッションファイル一覧を取得する
local function fetch_session_file()
    local function readdir()
        return vim.fn.globpath(SessionPath, '*', 1, 1)
    end

    local result = {}
    for _, file in ipairs(readdir(SessionPath)) do
        if vim.fn.isdirectory(SessionPath .. '/' .. file) == 0 then
            table.insert(result, file)
        end
    end

    return result
end

-- session filesをfloat windowに表示する
local function show_table_in_float_win(t)
    local bufnr = ui.create_float_win()
    local lines = {}
    for k, v in pairs(t) do
        table.insert(lines, tostring(v))
    end
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
    -- TODO: local function process_lineを呼び出したい
    -- vim.api.nvim_buf_set_current_win(win_id)
end

-- session fileを一覧表示する
function M.display_session_files()
    local res = fetch_session_file()
    show_table_in_float_win(res)
end

M.save_session = save_session.save

return M
