function print_table(table, indent)
    indent = indent or 0
    local indentStr = string.rep(' ', indent)

    for key, value in pairs(table) do
        local valueType = type(value)
        local formattedValue

        if valueType == 'table' then
            print(indentStr .. key .. ' = {')
            print_table(value, indent + 4)
            print(indentStr .. '}')
        elseif valueType == 'string' then
            formattedValue = string.format('%q', value)
        elseif valueType == 'boolean' then
            formattedValue = value and 'true' or 'false'
        else
            formattedValue = tostring(value)
        end
        print(indentStr .. key .. ' = ' .. tostring(value))
    end
end
