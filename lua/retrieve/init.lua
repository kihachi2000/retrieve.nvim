local stack = require("retrieve.stack").new()

local function set_mark()
    stack:push(vim.call("getcurpos"))
end

local function jump_back()
    if stack:is_empty() then
        print("-- NO MARK REGISTERED --")
        return
    end

    vim.fn.setpos(".", stack:pop())
end

vim.keymap.set("n", "<Plug>retrieve-set-mark", set_mark, {noremap = true, silent = true})
vim.keymap.set("n", "<Plug>retrieve-jump-back", jump_back, {noremap = true, silent = true})

return
