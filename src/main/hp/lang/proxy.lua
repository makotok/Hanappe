local table = require("hp/lang/table")

--------------------------------------------------------------------------------
-- プロパティアクセスをサポートするproxyクラスです.<br>
-- 既存のオブジェクトに対してプロパティアクセス機能を付与します.
-- @class table
-- @name proxy
--------------------------------------------------------------------------------
local M = {}
setmetatable(M, M)

----------------------------------------
-- プロパティに値を設定した場合の処理です.<br>
-- setter関数が存在する場合は、その関数を使用します.
----------------------------------------
local function propertyChange(self, key, value)
    local meta = getmetatable(self)
    local object = meta.__object
    local properties = meta.__properties

    if isProperty(properties, key) then
        local setter = object:getSetter(key)
        if setter then
            setter(self, value)
        end
    else
        object[key] = value
    end
end

----------------------------------------
-- プロパティにアクセスした場合の処理です.<br>
-- getter関数が存在する場合は、その関数を使用します.
----------------------------------------
local function propertyAccess(self, key)
    local object = getmetatable(self).__object

    -- プロパティの場合はプロパティ関数を使用
    if object:isProperty(key) then
        local getter = object:getGetter(key)
        if getter then
            return getter(self)
        else
            return nil
        end
    else
        return object[key]
    end
end

--------------------------------------------------------------------------------
-- インスタンスにプロパティアクセス機能を付与します.
-- 既にメタテーブルが設定されていた場合でもこのプロパティアクセスを付与できます.
-- @param src インスタンスです. 
-- @return class
--------------------------------------------------------------------------------
function M:__call(object, properties)
    local mt = getmetatable(object)
    mt = mt or {}
    
    mt.__indexChain = mt.__index
    mt.__newindexChain = mt.__newindex
    
    mt.__index = propertyChange
    mt.__newindex = 

end

function M:isProperty(properties, key)
    if properties[key] then
        return true
    end
    return false
end

function M:getSetter(properties, key)
    if properties[key] then
        return true
    end
    local setterName
    return self[setterName]
end

function M:getGetter(properties, key)
    if properties[key] then
        return true
    end
    local setterName
    return self[setterName]
end

return M
