----------------------------------------------------------------
-- Widgetを格納するViewコンテナです.<br>
-- 全てのウィジットはViewに追加します.<br>
-- <br>
-- また、ViewにViewを追加する事もできます.<br>
-- その場合、自身の描画後に子のViewが描画されます.<br>
-- @class table
-- @name View
----------------------------------------------------------------

-- import
local table                 = require "hp/lang/table"
local array                 = require "hp/lang/array"
local class                 = require "hp/lang/class"
local Layer                 = require "hp/display/Layer"
local Event                 = require "hp/event/Event"
local Executors             = require "hp/util/Executors"
local Component             = require "hp/gui/Component"
local ViewManager           = require "hp/manager/ViewManager"
local Executors             = require "hp/util/Executors"

-- class define
local super                 = Component
local M                     = class(super)

local function internalUpdateRenderPriority(obj, priority)
    obj:setPriority(priority)
    priority = priority + 1
    
    if obj.isGroup then
        local children = obj:getChildren()
        for i, child in ipairs(children) do
            priority = internalUpdateRenderPriority(child, priority)
        end
    end
    
    return priority
end

--------------------------------------------------------------------------------
-- 内部変数の初期化を行います.
--------------------------------------------------------------------------------
function M:initInternal()
    super.initInternal(self)
    self._priorityUpdateEnabled = true
end

--------------------------------------------------------------------------------
-- Viewの初期化処理を行います.
--------------------------------------------------------------------------------
function M:initComponent(params)
    self:initLayer()
    super.initComponent(self, params)
end

--------------------------------------------------------------------------------
-- View自身が元レイヤーを初期化します.
--------------------------------------------------------------------------------
function M:initLayer()
    local layer = Layer()
    layer:setSortMode(MOAILayer.SORT_PRIORITY_ASCENDING)
    layer:setTouchEnabled(true)

    self:setLayer(layer)
    self:setSize(layer:getViewSize())
end

--------------------------------------------------------------------------------
-- シーンを設定します.
--------------------------------------------------------------------------------
function M:setScene(scene)
    self:getLayer():setScene(scene)
end

--------------------------------------------------------------------------------
-- 描画順序を順番に行うように更新します.
--------------------------------------------------------------------------------
function M:updateLayout()
    super.updateLayout(self)
    if self._priorityUpdateEnabled then
        internalUpdateRenderPriority(self, 1)
    end
end

--------------------------------------------------------------------------------
-- 描画順序のプライオリティを自動的に更新するかどうか設定します.
-- パフォーマンスが問題になる場合に、手動でプライオリティを設定する事で、
-- パフォーマンスを向上させる事ができます.
--------------------------------------------------------------------------------
function M:setPriorityUpdateEnabled(value)
    self._priorityUpdateEnabled = value
end

return M