local M = {}

-- float windowを定義する
function M.create_float_win()
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

return M
