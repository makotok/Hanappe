--------------------------------------------------------------------------------
-- クラスのオブジェクトに対するユーティリティ関数です.
--------------------------------------------------------------------------------

-- imports
local class = require("hp/lang/class")

-- class define
local M = {}

--------------------------------------------------------------------------------
-- オブジェクトのsetter関数経由でパラメータを設定します.
-- setter関数が存在しない場合は無視します.
--------------------------------------------------------------------------------
function M.setProperties(obj, params, unpackFlag)
    for k, v in pairs(params) do
        M.setProperty(obj, k, v, unpackFlag)
    end
end

--------------------------------------------------------------------------------
-- オブジェクトのsetter関数経由で値を設定します.
--------------------------------------------------------------------------------
function M.setProperty(obj, name, value, unpackFlag)
    local setterName = M.getSetterName(name)
    local setter = obj[setterName]
    if setter then
        if not unpackFlag or type(value) ~= "table" or getmetatable(value) ~= nil then
            return setter(obj, value)
        else
            return setter(obj, unpack(value))
        end
    end
end

--------------------------------------------------------------------------------
-- オブジェクトのgetter関数経由で値を返します.
--------------------------------------------------------------------------------
function M.getProperty(obj, name)
    local getterName = M.getGetterName(name)
    local getter = obj[getterName]
    if getter then
        return getter(obj)
    end
end

--------------------------------------------------------------------------------
-- プロパティ名からsetter関数名を返します.
--------------------------------------------------------------------------------
function M.getSetterName(name)
    local headName = string.upper(name:sub(1, 1))
    local upperName = name:len() > 1 and headName .. name:sub(2) or headName
    local setterName = "set" .. upperName
    return setterName
end

--------------------------------------------------------------------------------
-- プロパティ名からgetter関数名を返します.
--------------------------------------------------------------------------------
function M.getGetterName(name)
    local headName = string.upper(name:sub(1, 1))
    local upperName = name:len() > 1 and headName .. name:sub(2) or headName
    local setterName = "get" .. upperName
    return setterName
end


return M