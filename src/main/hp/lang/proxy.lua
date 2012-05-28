local table = require("hp/lang/table")

--------------------------------------------------------------------------------
-- クラスベースなオブジェクト指向を簡単に実現するためのクラスです.<br>
-- クラスの基本的な機能を有します.<br>
-- setmetatableによる継承ではなく、テーブルに展開する事で<br>
-- 継承が多くなった場合でもパフォーマンスが劣化しません.<br>
--
-- カプセル化の仕組みとして、getPrivate、setPrivateを用意しています.<br>
-- この関数を使用すると、外部から隠したい一時変数等をmetatableに隠す事ができます.<br>
-- @class table
-- @name class
--------------------------------------------------------------------------------
local M = {}
setmetatable(M, M)


local function isProperty(self, properties, key)
    if properties[key] then
        return true
    end
    return false
end

local function getSetter(self, properties, key)
    if properties[key] then
        return true
    end
    local setterName
    return self[setterName]
end

--------------------------------------------------------------------------------
-- インスタンスにプロパティアクセス機能を付与します.
-- 既にメタテーブルが設定されていた場合でもこのプロパティアクセスを付与できます.
-- @param src インスタンスです. 
-- @return class
--------------------------------------------------------------------------------
function M:__call(object, properties)

    

end

----------------------------------------
-- プロパティに値を設定した場合の処理です.<br>
-- setter関数が存在する場合は、その関数を使用します.
-- @param key プロパティ名
-- @param value 値
----------------------------------------
function PropertySupport:propertyChange(key, value)
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
-- @param key プロパティ名
-- @return プロパティ値
----------------------------------------
function PropertySupport:propertyAccess(key)
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

return M
