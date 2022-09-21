local utils = {}

function utils.find_buf(buffer)
    if vim.api.nvim_win_get_buf(0) == buffer then
        return 0
    else
        local wins = vim.api.nvim_list_wins()

        for i = 1, #wins do
            if vim.api.nvim_win_get_buf(wins[i]) == buffer then
                return wins[i]
            end
        end

        return nil
    end
end

return utils
