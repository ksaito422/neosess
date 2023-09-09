local load_session = require('neosess.load_session')
local save_session = require('neosess.save_session')

local M = {}

function M.setup(opts)
    -- Define default values
    local session_dir = opts.session_path or '~/.config/nvim/sessions'
    SessionPath = vim.fn.expand(session_dir)
end

M.display_session_files = load_session.display
M.save_session = save_session.save

return M
