local retrieve = {}

local utils = require("retrieve.utils")

local stack
local ns_id = 0

local function set_mark()
    local data = {}
    local buffer = vim.api.nvim_win_get_buf(0)
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))

    data.buffer  = buffer
    data.mark_id = vim.api.nvim_buf_set_extmark(buffer, ns_id, row - 1, col, {})

    stack:push(data)
end

local function jump_back()

    if stack:is_empty() then
        -- 何も保存されていないとき
        print("-- NO MARK REGISTERED --")
        return
    end

    local data = stack:pop()
    local row, col = unpack(vim.api.nvim_buf_get_extmark_by_id(data.buffer, ns_id, data.mark_id, {}))
    local pos = {row + 1, col}

    -- ポップしたマークを削除
    vim.api.nvim_buf_del_extmark(data.buffer, ns_id, data.mark_id)

    if utils.find_buf(data.buffer) ~= nil then
        -- バッファが表示されているとき
        local target_win = utils.find_buf(data.buffer)
        vim.api.nvim_win_set_cursor(target_win, pos)
        vim.api.nvim_set_current_win(target_win)
    else
        -- バッファが表示されていないとき
        vim.api.nvim_win_set_buf(0, data.buffer)
        vim.api.nvim_win_set_cursor(0, pos)
        vim.api.nvim_set_current_win(0)
    end
end

function retrieve.setup()
    stack = require("retrieve.stack").new()
    ns_id = vim.api.nvim_create_namespace("retrieve")
    vim.keymap.set("n", "<Plug>retrieve-set", set_mark, {noremap = true, silent = false})
    vim.keymap.set("n", "<Plug>retrieve-return", jump_back, {noremap = true, silent = false})
end

return retrieve
