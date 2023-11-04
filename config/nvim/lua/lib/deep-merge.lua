local function deep_merge(tbl, keys, value)
    local last_key = keys[#keys]

    for i = 1, #keys - 1 do
        local key = keys[i]

        if not tbl[key] then
            tbl[key] = {}
        end

        tbl = tbl[key]
    end

    if not tbl[last_key] then
        tbl[last_key] = {}
    end

    tbl[last_key] = value
end

M = {}
M.deep_merge = deep_merge
