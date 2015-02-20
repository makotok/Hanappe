--------------------------------------------------------------------------------
-- 位置とサイズを持つ二次元空間座標を表現するクラスです.
--------------------------------------------------------------------------------

-- import
local class = require "flower.class"

-- class
local DungeonRect = class()

function DungeonRect:init(x, y, width, height)
    self.x = x or 0
    self.y = y or 0
    self.width = width or 0
    self.height = height or 0
end

---
-- 指定した位置が空間座標内に含まれる場合にtrueを返します.
-- @param x X座標
-- @param y Y座標
-- @return 位置が空間座標内に含まれる場合はtrue
function DungeonRect:contains(x, y)
    return self.x <= x and self.y <= y and x <= (self.x + self.width) and y <= (self.y + self.height)
end

---
-- 指定した位置が空間座標内に含まれる場合にtrueを返します.
-- @param x X座標
-- @param y Y座標
-- @return 位置が空間座標内に含まれる場合はtrue
function DungeonRect:containsByRect(rect)
    return self:contains(rect.x, rect.y)
    or self:contains(rect.x + rect.width, rect.y)
    or self:contains(rect.x, rect.y + rect.height)
    or self:contains(rect.x + rect.width, rect.y + rect.height)
    or false
end

return DungeonRect