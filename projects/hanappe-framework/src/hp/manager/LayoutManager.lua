--------------------------------------------------------------------------------
-- UIComponentのレイアウトを管理するマネージャです.
--------------------------------------------------------------------------------

-- import
local table                 = require "hp/lang/table"
local PriorityQueue         = require "hp/util/PriorityQueue"
local Executors             = require "hp/util/Executors"

-- module
local M                     = {}

--------------------------------------------------------------------------------
-- private
--------------------------------------------------------------------------------

-- 比較関数
local ascComparetor = function(a, b) 
    local alevel = a:getNestLevel()
    local blevel = b:getNestLevel()
    
    if alevel < blevel then
        return -1
    elseif alevel == blevel then
        return 0
    else
        return 1
    end
end

-- 比較関数
local descComparetor = function(a, b)
    return ascComparetor(a, b) * -1
end

-- queue
local invalidateDisplayQueue        = PriorityQueue(descComparetor)
local invalidateLayoutQueue         = PriorityQueue(descComparetor)

-- flag
local invalidateDisplayFlag = false
local invalidateLayoutFlag = false

-- 表示の更新
local function validateDisplay()
    local object = invalidateDisplayQueue:poll()
    while object do
        object:validateDisplay()
        object = invalidateDisplayQueue:poll()
    end
end

-- レイアウトの検証実施
local function validateLayout()
    local object = invalidateLayoutQueue:poll()
    while object do
        object:validateLayout()
        object = invalidateLayoutQueue:poll()
    end
end

-- フレーム処理
local function enterFrame()
    if invalidateDisplayFlag then
        validateDisplay()
        invalidateDisplayFlag = false
    end
    if invalidateLayoutFlag then
        validateLayout()
        invalidateLayoutFlag = false
    end
end

-- event handler
Executors.callLoop(enterFrame)

--------------------------------------------------------------------------------
-- public functions
--------------------------------------------------------------------------------

---------------------------------------
-- invalidateDisplayをスケジューリングします.
---------------------------------------
function M:invalidateDisplay(object)
    invalidateDisplayFlag = true
    invalidateDisplayQueue:push(object)
end

---------------------------------------
-- invalidateLayoutをスケジューリングします.
---------------------------------------
function M:invalidateLayout(object)
    invalidateLayoutFlag = true
    invalidateLayoutQueue:push(object)
end

return M
