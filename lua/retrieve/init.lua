local stack = require("retrieve.stack").new()

local function set_mark()
    local data = {}
    data.bufnum = vim.api.nvim_win_get_buf(0)
    data.curpos = vim.api.nvim_win_get_cursor(0)

    stack:push(data)
end

local function jump_back()
    if stack:is_empty() then
        print("-- NO MARK REGISTERED --")
        return
    end

    local data = stack:pop()
    local wins = vim.api.nvim_list_wins()

    -- 現在のウインドウに行き先のバッファが表示されているとき
    -- そのまま保存箇所に移動
    if data.bufnum == vim.api.nvim_win_get_buf(0) then
        vim.api.nvim_win_set_cursor(0, data.curpos)
        return
    end

    -- バッファが表示されているとき
    -- 表示中のウインドウにフォーカスしてからカーソルを移動
    local winnum = 0
    for i = 1, #wins do
        local bufnum = vim.api.nvim_win_get_buf(wins[i])

        if data.bufnum == bufnum then
            winnum = wins[i]
        end
    end

    -- バッファが表示されていないとき
    -- 現在のウインドウでバッファを表示してカーソルを移動
    if winnum == 0 then
        vim.api.nvim_win_set_buf(0, data.bufnum)
    end

    vim.api.nvim_win_set_cursor(winnum, data.curpos)
    vim.api.nvim_set_current_win(winnum)
end

vim.keymap.set("n", "<Plug>retrieve-set-mark", set_mark, {noremap = true, silent = true})
vim.keymap.set("n", "<Plug>retrieve-jump-back", jump_back, {noremap = true, silent = true})

return
