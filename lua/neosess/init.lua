local M = {}

-- デフォルトでセッションの保存先を指定するグローバル変数を定義する
vim.g.session_path = os.getenv("HOME") .. "/.config/nvim/sessions/"

-- ディレクトリが存在しない場合、ディレクトリを作成する
local function dir_exists()
    local dir_exists = vim.loop.fs_stat(vim.g.session_path)
    if not dir_exists then
        os.execute("mkdir -p " .. vim.g.session_path)
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
    -- TODO: vim.fn.expand()でsession_pathを安全に扱えるようにする
    local session_file_path = vim.g.session_path .. file .. ".vim"

    dir_exists()
    file_exists(session_file_path)

    vim.api.nvim_command("mksession! " .. session_file_path)
    vim.api.nvim_command("redraw")
    print("session.vim: created")
end

-- 保存したセッションを読み込む
function M.load_session(file)
    vim.api.nvim_command("source " .. vim.g.session_path .. file)
end

-- 保存したセッションファイル一覧を取得する
function M.fetch_session_file()
    local session_path = vim.g.session_path

    local function readdir()
        print("aaa")
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
-- TODO: 保存したセッションファイルをbufferに表示する

-- function M.setup()
--     vim.api.nvim_create_user_command('CreateSession', require('nvim-session').create_session(), {})
--     vim.api.nvim_create_user_command('LoadSession', require('nvim-session').load_session(), {})
-- end

return M
