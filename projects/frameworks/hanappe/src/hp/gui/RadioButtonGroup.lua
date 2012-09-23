----------------------------------------------------------------
-- ラジオボタンウィジットクラスです.<br>
-- @class table
-- @name RadioButton
----------------------------------------------------------------
local table                 = require "hp/lang/table"
local class                 = require "hp/lang/class"
local EventDispatcher       = require "hp/event/EventDispatcher"

-- class
local M                     = class(EventDispatcher)

-- event
M.EVENT_SELECTED_CHANGED    = "selectedChanged"

----------------------------------------------------------------
-- インスタンスを生成して返します.
----------------------------------------------------------------
function M:init()
    self._selectedItem = nil
    self._children = {}
end

----------------------------------------------------------------
-- ラジオボタンリストを返します.
----------------------------------------------------------------
function M:getChildren()
    return self._children
end

----------------------------------------------------------------
-- ラジオボタンを追加します.
----------------------------------------------------------------
function M:addChild(child)
    local added = table.insertElement(self._children, child)
    if added then
        child:setRadioButtonGroup(self)
    end
end

----------------------------------------------------------------
-- ラジオボタンを削除します.
----------------------------------------------------------------
function M:removeChild(child)
    local removed = table.removeElement(self._children, child)
    if removed then
        child:setRadioButtonGroup(nil)
    end
end


----------------------------------------------------------------
-- 選択済のラジオボタンを返します.
----------------------------------------------------------------
function M:getSelectedItem()
    return self._selectedItem
end

----------------------------------------------------------------
-- 選択済のラジオボタンを設定します.
----------------------------------------------------------------
function M:setSelectedItem(item)
    if self:getSelectedItem() == item then
        return
    end
    
    self._selectedItem = item
    self._selectedItem:setSelected(true)
    
    for i, child in ipairs(self:getChildren()) do
        if child ~= item then
            child:setSelected(false)
        end
    end
    
    local e = Event(M.EVENT_SELECTED_CHANGED)
    e.selectedItem = item
    self:dispatchEvent(e)
end

return M