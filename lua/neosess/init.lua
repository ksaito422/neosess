local M = {}

-- デフォルトでセッションの保存先を指定するグローバル変数を定義する
vim.g.session_path = os.getenv("HOME") .. "/.config/nvim/sessions/"

-- セッションを保存する
function M.save_session(file)
    local session_file_path = vim.g.session_path .. file .. ".vim"
    local dir_exists = vim.loop.fs_stat(vim.g.session_path)
    local file_exists = vim.loop.fs_stat(session_file_path)

    -- ディレクトリが存在しない場合、ディレクトリを作成する
    if not dir_exists then
        os.execute("mkdir -p " .. vim.g.session_path)
    end

    -- ファイルが存在しない場合、ファイルを作成する
    if not file_exists then
        local f = assert(io.open(session_file_path, "w"))
        f:close()
    end

    vim.api.nvim_command("mksession! " .. session_file_path)
    vim.api.nvim_command("redraw")
    print("session.vim: created")
end

-- 保存したセッションを読み込む
function M.load_session(file)
    vim.api.nvim_command("source " .. vim.g.session_path .. file)
end

-- TODO: 保存したセッションを一覧表示する

-- function M.setup()
--     vim.api.nvim_create_user_command('CreateSession', require('nvim-session').create_session(), {})
--     vim.api.nvim_create_user_command('LoadSession', require('nvim-session').load_session(), {})
-- end

return M
