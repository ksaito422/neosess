local M = {}

local function create_window()
    local win_height = 0.4 * vim.o.lines -- 高さは画面の40%
    local win_width = 0.4 * vim.o.columns -- 幅は画面の40%

    local win_config = {
        relative = 'editor',
        row = math.ceil((vim.o.lines - win_height) / 2 - 1),
        col = math.ceil((vim.o.columns - win_width) / 2),
        height = math.ceil(win_height),
        width = math.ceil(win_width),
        title = 'Sessions',
        border = 'single',
        title_pos = 'center',
    }

    local bufnr = vim.api.nvim_create_buf(false, true)

    return bufnr, win_config
end

function M.create_float_win()
    local bufnr, win_config = create_window()
    local win_id = vim.api.nvim_open_win(bufnr, true, {
        relative = win_config.relative,
        row = win_config.row,
        col = win_config.col,
        height = win_config.height,
        width = win_config.width,
        title = win_config.title,
        border = win_config.border,
        title_pos = win_config.title_pos,
    })

    return bufnr, win_id
end

return M
