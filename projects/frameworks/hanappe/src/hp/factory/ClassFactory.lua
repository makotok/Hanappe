--------------------------------------------------------------------------------
-- クラスのインスタンスを生成するファクトリークラスです.
-- @class table
-- @name ClassFactory
--------------------------------------------------------------------------------

-- imports
local class = require("hp/lang/class")

-- class define
local M = class()

local function getSetterName(name)
    local headName = string.upper(name:sub(1, 1))
    local upperName = key:len() > 1 and headName .. name:sub(2) or headName
    local setterName = "set" .. upperName
    return setterName
end

local function copyParams(self, params)
    for k, v in pairs(params)
        local setterName = getSetterName(k)
        if self[setterName] then
            self[setterName](v)
        end
    end
    return self
end

--------------------------------------------------------------------------------
-- コンストラクタ
--------------------------------------------------------------------------------
function M:init(clazz)
    self.clazz = clazz
    self.params = {}
end

--------------------------------------------------------------------------------
-- オブジェクトを生成します.
--------------------------------------------------------------------------------
function M:create()
    local obj = self.clazz()
    return copyParams(obj, self.params)
end

return M