--------------------------------------------------------------------------------
-- ランダムダンジョンのマップを生成機です.
-- 任意のパラメータを与える事で、よくあるランダムダンジョンのマップデータの基礎を生成します.
-- @class table
-- @name DungeonMapBuilder
--------------------------------------------------------------------------------
local M = class()

-- aからbの範囲内でランダムな数値を生成します.
local function randomRange(a, b)
    local r = math.random(b - a) + a
    return r
end

--------------------------------------------------------------------------------
-- コンストラクタです.
--------------------------------------------------------------------------------
function M:init()
    self.options = {
        map = {
            width = 60,         -- マップ幅
            height = 60,        -- マップ高さ
        },
        range = {
            minSize = 3,        -- 領域の最小数
            maxSize = 6,        -- 領域の最大数
            minWidth = 10,      -- 領域の最小幅
            minHeight = 10,     -- 領域の最小高さ
            createRate = 70,    -- 領域を作成する確率
            
        },
        room = {
            minWidth = 8,
            minHeight = 8,
            margin = 2
        },
        road = {
            minSize = 1
            maxSize = 4
        },
    }
end

--------------------------------------------------------------------------------
-- ランダムダンジョンを生成します
--------------------------------------------------------------------------------
function M:generate()
    return self:createMapData()
end

--------------------------------------------------------------------------------
-- ランダムダンジョンのマップデータを生成します.
--------------------------------------------------------------------------------
function M:createMapData()
    local mapOptions = self.options.map
    local mapData = DungeonMap(mapOptions.width, mapOptions.height)

    self:createRanges(mapData)
    self:createRooms(mapData)
    self:createRoads(mapData)
    self:createObjects(mapData)
    
    return mapData
end

--------------------------------------------------------------------------------
-- 領域を生成します.
--------------------------------------------------------------------------------
function M:createRanges(mapData)
    local range = DungeonRange(1, 1, mapData.width, mapData.height)
    mapData:addRamge(range)
    self:createRange(mapData, range)
end

--------------------------------------------------------------------------------
-- 領域を生成します.
--------------------------------------------------------------------------------
function M:createRange(mapData, parentRange, direction)
    if self:isSplitExit(mapData, parentRange, direction) then
        return
    end
    
    local rect1, rect2 = self:getSplitRects(mapData, parentRange, direction)
    self:splitRange(mapData, parentRange, rect1, rect2)
    
    local newDir = direction == DungeonRange.DIR_HORIZONAL and DungeonRange.DIR_VERTICAL or DungeonRange.DIR_HORIZONAL
    self:createRange(mapData, newRange1, newDir)
end

--------------------------------------------------------------------------------
-- 領域を分割します.
--------------------------------------------------------------------------------
function M:splitRange(mapData, oldRange, rect1, rect2)
    local range1 = DungeonRange(rect1.x, rect1.y, rect1.width, rect1.height)
    local range2 = DungeonRange(rect2.x, rect2.y, rect2.width, rect2.height)
    mapData:removeRange(oldRange)
    mapData:addRange(range1)
    mapData:addRange(range2)
    
end

--------------------------------------------------------------------------------
-- 分割する領域を返します.
--------------------------------------------------------------------------------
function M:getSplitRects(mapData, parentRange, direction)
    local rect1 = {}
    local rect2 = {}
    
    rect1.x, rect1.y = parentRange.x, parentRange.y
    rect2.x, rect2.y = newX1, newY1
    rect1.width, rect1.height = parentRange.width, parentRange.height
    rect2.width, rect2.height = parentRange.width, parentRange.height
    
    if direction == DungeonRange.DIR_HORIZONAL then
        rect1.width = rect1.width / 2
        rect2.width = rect2.width - rect1.width
        rect2.x = rect1.x + rect1.width
    else
        rect1.height = rect1.height / 2
        rect2.height = rect2.height - rect1.height
        rect2.y = rect1.y + rect1.height
    end

    return rect1, rect2
end

--------------------------------------------------------------------------------
-- 領域を分割するかどうか返します.
--------------------------------------------------------------------------------
function M:isSplitExit(mapData, parentRange, direction)
    local options = self.options.range
    local minSize, maxSize = options.minSize, options.maxSize
    local minWidth, minHeight = options.maxWidth + options.margin, options.maxHeight + options.margin
    local rangeSize = #mapData.ranges
    
    -- 分割最大数を超えた場合は終了
    if rangeSize >= maxSize then
        return true
    end

    return false
end

--------------------------------------------------------------------------------
-- 部屋を生成します
--------------------------------------------------------------------------------
function M:createRooms(mapData)
    local options = self.options.room
    local minWidth, minHeight = options.minWidth, options.minHeight
    local margin = options.margin
    for i, range in ipairs(mapData.ranges) do
        local width  = randomRange(minWidth, range.width)
        local height = randomRange(minHeight, range.height)
        local x = randomRange(range.x + margin, range.x + range.width - width - margin)
        local y = randomRange(range.y + margin, range.y + range.height - height - margin)
        
        local room = DungeonRoom(x, y, width, height)
        room.range = range
        mapData:addRoom(room)
    end
end

--------------------------------------------------------------------------------
-- 部屋を繋ぐ道を生成します
--------------------------------------------------------------------------------
function M:createRoads(mapData)
    local options = self.options.road
    local minSize, maxSize = options.minSize, options.maxSize
    for i, rooms in ipairs(mapData.rooms) do
        local width  = randomRange(minWidth, range.width)
        local height = randomRange(minHeight, range.height)
        local x = randomRange(range.x + margin, range.x + range.width - width - margin)
        local y = randomRange(range.y + margin, range.y + range.height - height - margin)
        
        local road = DungeonRoad(x, y, width, height)
        mapData:addRoad(road)
    end

end

--------------------------------------------------------------------------------
-- マップに配置するオブジェクトを生成します
--------------------------------------------------------------------------------
function M:createObjects(mapData)

end


return M