local M = {}

-- デフォルトでセッションの保存先を指定するグローバル変数を定義する
if vim.g["session_path"] == nil then
    vim.g.session_path = vim.fn.expand("~/.config/nvim/sessions")
end

-- ディレクトリが存在しない場合、ディレクトリを作成する
local function dir_exists(session_path)
    local dir_exists = vim.loop.fs_stat(session_path)
    if not dir_exists then
        os.execute("mkdir -p " .. session_path)
    end
end

-- ファイルが存在しない場合、ファイルを作成する
local function file_exists(session_file_path)
    local file_exists = vim.loop.fs_stat(session_file_path)
    if not file_exists then
        local f = assert(io.open(session_file_path, "w"))
        f:close()
    end
end

-- セッションを保存する
function M.save_session(file)
    local session_path = vim.fn.expand(vim.g.session_path .. "/")
    local session_file_path = session_path .. file .. ".vim"

    dir_exists(session_path)
    file_exists(session_file_path)

    vim.api.nvim_command("mksession! " .. session_path .. file .. ".vim")
    vim.api.nvim_command("redraw")
    print("neosess: session created")
end

-- 保存したセッションファイル一覧を取得する
local function fetch_session_file()
    local session_path = vim.g.session_path

    local function readdir()
        return vim.fn.globpath(session_path, "*", 1, 1)
    end

    if session_path == "" then
        vim.api.nvim_err_writeln("session_path is empty")
        return {}
    end

    session_path = vim.fn.expand(session_path)

    local result = {}
    for _, file in ipairs(readdir(session_path)) do
        if vim.fn.isdirectory(session_path .. "/" .. file) == 0 then
            table.insert(result, file)
        end
    end

    return result
end

-- float windowを定義する
local function create_float_win()
    -- float windowのパラメータを定義します
    local win_height = 0.4 * vim.o.lines -- 高さは画面の40%
    local win_width = 0.4 * vim.o.columns -- 幅は画面の40%

    local row = math.ceil((vim.o.lines - win_height) / 2 - 1)
    local col = math.ceil((vim.o.columns - win_width) / 2)

    local buf = vim.api.nvim_create_buf(false, true)

    -- float windowを作成する
    local win_id = vim.api.nvim_open_win(buf, true, {
        relative = 'editor',
        row = row,
        col = col,
        width = math.ceil(win_width),
        height = math.ceil(win_height),
    })

    return buf, win_id
end

-- session filesをfloat windowに表示する
local function show_table_in_float_win(t)
    function process_line(line, win_id)
        load_session(line, win_id)
    end

    local buf, win_id = create_float_win()
    local lines = {}
    for k, v in pairs(t) do
        table.insert(lines, tostring(v))
    end
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    -- TODO: local function process_lineを呼び出したい
    vim.api.nvim_buf_set_keymap(buf, "n", "<CR>", string.format(":lua process_line(vim.api.nvim_get_current_line(), %d)<CR>", win_id), {noremap = true, silent = true})
    -- vim.api.nvim_buf_set_current_win(win_id)
end

-- 保存したセッションを読み込む
function load_session(file, win_id)
    vim.api.nvim_win_close(win_id, true)
    vim.api.nvim_command("source " .. file)
end

-- session fileを一覧表示する
function M.display_session_files()
    local res = fetch_session_file()
    show_table_in_float_win(res)
end

return M
