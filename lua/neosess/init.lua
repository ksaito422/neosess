local save_session = require('neosess.save_session')
local load_session = require('neosess.telescope')

local M = {}

function M.setup(opts)
    opts = opts or {}

    -- Define default values
    local session_dir = opts.session_path or '~/.config/nvim/sessions'
    SessionPath = vim.fn.expand(session_dir)
    WindowConfig = opts.window_config or {
        title = nil,
        border = nil,
        title_pos = nil,
    }

    -- Store auto save configuration globally
    AutoSaveEnabled = opts.auto_save or false
    AutoSaveConfirm = opts.auto_save_confirm == nil and true or opts.auto_save_confirm

    -- Auto save session on exit
    if AutoSaveEnabled then
        vim.api.nvim_create_autocmd('VimLeavePre', {
            group = vim.api.nvim_create_augroup('NeosessAutoSave', { clear = true }),
            callback = function()
                local session_name = M.get_current_dir_session_name()
                M.auto_save_session(session_name)
            end,
        })
    end
end

function M.get_current_dir_session_name()
    local cwd = vim.fn.getcwd()
    local session_name = vim.fn.fnamemodify(cwd, ':t')
    return session_name
end

function M.auto_save_session(session_name)
    if not AutoSaveConfirm then
        save_session.save(session_name)
        return
    end

    local session_file_path = SessionPath .. '/' .. session_name .. '.vim'
    local file_exists = vim.loop.fs_stat(session_file_path) ~= nil

    local message = file_exists and 'Session "' .. session_name .. '" already exists. Overwrite? (y/N): '
        or 'Save session "' .. session_name .. '"? (y/N): '

    vim.ui.input({ prompt = message }, function(input)
        if input and (input:lower() == 'y' or input:lower() == 'yes') then
            save_session.save(session_name)
        end
    end)
end

M.display_session_files = load_session.sessions
M.save_session = save_session.save

return M
