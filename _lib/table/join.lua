-- Generic functions for joining tables and arrays in Lua.
require("_lib.table.copy")

-- Joins two arrays
function JoinArrays(a1, a2)
    local a = Copy(a1)
    for index, value in ipairs(a2) do
        a[index + #a1] = value
    end
    return a
end

-- Joins two arrays indexed from zero
function JoinZeroArrays(a1, a2)
    local a = Copy(a1)
    a[#a1 + 1] = a2[0]
    for index, value in ipairs(a2) do
        a[index + #a1 + 1] = value
    end
    return a
end