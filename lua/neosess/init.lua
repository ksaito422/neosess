local ui = require('neosess.ui')

local M = {}

function M.setup(opts)
    -- Define default values
    -- TODO: localで定義したい
    session_path = opts.session_path or '~/.config/nvim/sessions'
    -- TODO: 空文字列, nilなどの不正な値ならエラーにしたい
    session_path = vim.fn.expand(session_path)
end

-- ディレクトリが存在しない場合、ディレクトリを作成する
local function dir_exists()
    local dir_exists = vim.loop.fs_stat(session_path)
    if not dir_exists then
        os.execute('mkdir -p ' .. session_path)
    end
end

-- ファイルが存在しない場合、ファイルを作成する
local function file_exists(session_file_path)
    local file_exists = vim.loop.fs_stat(session_file_path)
    if not file_exists then
        local f = assert(io.open(session_file_path, 'w'))
        f:close()
    end
end

-- セッションを保存する
function M.save_session(file)
    local session_file_path = session_path .. '/' .. file .. '.vim'

    dir_exists()
    file_exists(session_file_path)

    vim.api.nvim_command('mksession! ' .. session_file_path)
    vim.api.nvim_command('redraw')
    vim.api.nvim_echo({{ 'neosess: session created.' }}, true, {})
end

-- 保存したセッションファイル一覧を取得する
local function fetch_session_file()
    local function readdir()
        return vim.fn.globpath(session_path, '*', 1, 1)
    end

    local result = {}
    for _, file in ipairs(readdir(session_path)) do
        if vim.fn.isdirectory(session_path .. '/' .. file) == 0 then
            table.insert(result, file)
        end
    end

    return result
end

-- session filesをfloat windowに表示する
local function show_table_in_float_win(t)
    function process_line(line, win_id, mode)
        if mode == 'load' then
            load_session(line, win_id)
        elseif 'delete' then
            delete_session(line, win_id)
        end
    end

    local bufnr = ui.create_float_win()
    local lines = {}
    for k, v in pairs(t) do
        table.insert(lines, tostring(v))
    end
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
    -- TODO: local function process_lineを呼び出したい
    -- vim.api.nvim_buf_set_current_win(win_id)
end

-- 保存したセッションを読み込む
function load_session(file, win_id)
    vim.api.nvim_win_close(win_id, true)
    vim.api.nvim_command('source ' .. file)
end

-- 保存してあるセッションを削除する
function delete_session(file, win_id)
    vim.api.nvim_win_close(win_id, true)
    os.remove(file)
    vim.api.nvim_echo({{ 'neosess: ' .. file .. ' has been deleted.' }}, true, {})
end

-- session fileを一覧表示する
function M.display_session_files()
    local res = fetch_session_file()
    show_table_in_float_win(res)
end

return M
