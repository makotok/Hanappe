local class = require("hp/lang/class")

--------------------------------------------------------------------------------
-- TMXMapのレイヤークラスです.
-- @class table
-- @name TMXLayer
--------------------------------------------------------------------------------
local M = class()

---------------------------------------
-- コンストラクタです
---------------------------------------
function M:init(tmxMap)
    self.tmxMap = tmxMap
    self.name = ""
    self.x = 0
    self.y = 0
    self.width = 0
    self.height = 0
    self.opacity = 0
    self.visible = true
    self.properties = {}
    self.tiles = {}
end

---------------------------------------
-- プロパティを返します.
---------------------------------------
function M:getProperty(key)
    return self.properties[key]
end

---------------------------------------
-- x,y座標のGIDを返します.
---------------------------------------
function M:getGid(x, y)
    if not self:checkBounds(x, y) then
        return nil
    end
    return self.tiles[(y - 1) * self.width + x]
end

---------------------------------------
-- x,y座標のGIDを設定します.
---------------------------------------
function M:setGid(x, y, gid)
    if not self:checkBounds(x, y) then
        error("index out of bounds!")
    end
    self.tiles[(y - 1) * self.width + x] = gid
end

---------------------------------------
-- x,y座標が範囲内かどうか判定します.
---------------------------------------
function M:checkBounds(x, y)
    if x < 1 or self.width < x then
        return false
    end
    if y < 1 or self.height < y then
        return false
    end
    return true
end

return M