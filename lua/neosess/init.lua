-- local load_session = require('neosess.load_session')
local save_session = require('neosess.save_session')
local load_session = require('neosess.telescope')

local M = {}

function M.setup(opts)
    -- Define default values
    local session_dir = opts.session_path or '~/.config/nvim/sessions'
    SessionPath = vim.fn.expand(session_dir)
    WindowConfig = opts.window_config or {
        title = nil,
        border = nil,
        title_pos = nil,
    }
end

-- M.display_session_files = load_session.sessions(require('telescope.themes').get_dropdown {})
M.display_session_files = load_session.sessions
M.save_session = save_session.save

return M
