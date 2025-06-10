local has_telescope, _ = pcall(require, 'telescope')

if not has_telescope then
    error('This plugin requires telescope.nvim (https://github.com/nvim-telescope/telescope.nvim)')
end

local finders = require('telescope.finders')
local pickers = require('telescope.pickers')
local conf = require('telescope.config').values
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local previewers = require('telescope.previewers')

local M = {}

M.sessions = function(opts)
    opts = opts or {}

    local function fetch_session_files()
        local function readdir()
            return vim.fn.globpath(SessionPath, '*', 1, 1)
        end

        local session_files = {}
        for _, file in ipairs(readdir(SessionPath)) do
            if vim.fn.isdirectory(SessionPath .. '/' .. file) == 0 then
                table.insert(session_files, file)
            end
        end

        return session_files
    end

    pickers.new(opts, {
        prompt_title = 'sessions',
        -- telescopeに表示する値
        finder = finders.new_table {
            results = fetch_session_files()
        },
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr, map)
            -- <Enter>でセッションに保存してあるファイルを開く
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                vim.api.nvim_command('source ' .. selection[1])
            end)

            -- <ctrl-;>でセッションファイルを削除する
            local delete_session = function(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                local filename = vim.fn.fnamemodify(selection[1], ':t')

                -- 削除確認
                local confirm = vim.fn.confirm('Delete session "' .. filename .. '"?', '&Yes\n&No', 2)
                if confirm == 1 then
                    os.remove(selection[1])
                    vim.api.nvim_echo({ { 'neosess: ' .. filename .. ' has been deleted.' } }, true, {})

                    -- 画面リフレッシュ
                    actions.close(prompt_bufnr)
                    M.sessions(opts)
                end
            end

            map('n', '<C-;>', delete_session)

            return true
        end,
    }):find()
end

return M
