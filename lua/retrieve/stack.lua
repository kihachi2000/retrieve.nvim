Stack = {}

function Stack.new()
    local obj = { buff = {} }
    return setmetatable(obj, {__index = Stack})
end

function Stack:push(x)
    table.insert(self.buff, x)
end

function Stack:pop()
    return table.remove(self.buff)
end

function Stack:is_empty()
    return #self.buff == 0
end

return Stack
