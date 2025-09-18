--Lume serialization functions

function dostring(str)
    return assert((loadstring or load)(str))()
end

local serialize_map = {
    ["boolean"] = tostring,
    ["nil"] = tostring,
    ["string"] = function(v) return string.format("%q", v) end,
    ["number"] = function(v)
        if v ~= v then
            return "0/0"                       --  nan
        elseif v == 1 / 0 then
            return "1/0"                       --  inf
        elseif v == -1 / 0 then
            return "-1/0"
        end                                    -- -inf
        return tostring(v)
    end,
    ["function"] = function(f)
    local ok, dumped = pcall(string.dump, f)
    if not ok then
        error("can't dump function (probably a C function or not dumpable)")
    end
    return "loadstring(" .. string.format("%q", dumped) .. ")"
end,
    ["table"] = function(t, stk)
        stk = stk or {}
        if stk[t] then error("circular reference") end
        local rtn = {}
        stk[t] = true
        for k, v in pairs(t) do
            rtn[#rtn + 1] = "[" .. serializeb(k, stk) .. "]=" .. serialize(v, stk)
        end
        stk[t] = nil
        return "{" .. table.concat(rtn, ",") .. "}"
    end
}

setmetatable(serialize_map, {
    __index = function(_, k) error("unsupported serialize type: " .. k) end
})

serializeb = function(x, stk)
    return serialize_map[type(x)](x, stk)
end

function serialize(x)
    return serializeb(x)
end

function deserialize(str)
    return dostring("return " .. str)
end
