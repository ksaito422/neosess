local M = {}

local function set_keybinds(bufnr, win_id)
    vim.api.nvim_buf_set_keymap(
        bufnr,
        'n',
        'q',
        string.format(':q<CR>', win_id),
        { noremap = true, silent = true }
    )
    vim.api.nvim_buf_set_keymap(
        bufnr,
        'n',
        '<CR>',
        string.format(':lua ProcessLine(vim.api.nvim_get_current_line(), %d, "load")<CR>', win_id),
        { noremap = true, silent = true }
    )
    vim.api.nvim_buf_set_keymap(
        bufnr,
        'n',
        'D',
        string.format(':lua ProcessLine(vim.api.nvim_get_current_line(), %d, "delete")<CR>', win_id),
        { noremap = true, silent = true }
    )
end

local function load_session(file, win_id)
    vim.api.nvim_win_close(win_id, true)
    vim.api.nvim_command('source ' .. file)
end

local function delete_session(file)
    os.remove(file)
    vim.api.nvim_echo({ { 'neosess: ' .. file .. ' has been deleted.' } }, true, {})
end

-- Define actions that can be operated in the float windows
function ProcessLine(line, win_id, mode)
    if mode == 'load' then
        load_session(line, win_id)
    elseif 'delete' then
        delete_session(line)
    end
end

local function create_window()
    local win_height = 0.4 * vim.o.lines -- 高さは画面の40%
    local win_width = 0.4 * vim.o.columns -- 幅は画面の40%

    local win_config = {
        relative = 'editor',
        row = math.ceil((vim.o.lines - win_height) / 2 - 1),
        col = math.ceil((vim.o.columns - win_width) / 2),
        height = math.ceil(win_height),
        width = math.ceil(win_width),
        title = WindowConfig.title or 'Sessions',
        border = WindowConfig.border or 'single',
        title_pos = WindowConfig.title_ops or 'center',
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

    set_keybinds(bufnr, win_id)

    return bufnr, win_id
end

return M
