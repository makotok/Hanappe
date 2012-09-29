--------------------------------------------------------------------------------
-- コンポーネントのリストを表示する共通のクラスです.<br>
-- TODO:未実装
-- @class table
-- @name ListBase
--------------------------------------------------------------------------------

-- import
local table                     = require "hp/lang/table"
local class                     = require "hp/lang/class"
local NinePatch                 = require "hp/display/NinePatch"
local TextLabel                 = require "hp/display/TextLabel"
local Event                     = require "hp/event/Event"
local Component                 = require "hp/gui/Component"

-- class
local M                         = class(Component)
local super                     = Component

-- Event
M.EVENT_SELECTED_CHANGED        = "selectedChanged"

--------------------------------------------------------------------------------
-- 内部変数の初期化処理を行います.
--------------------------------------------------------------------------------
function M:initInternal()
    super.initInternal(self)
    self._rowCount = 1
    self._listItems = {}
    self._background = nil
    self._container = nil
    self._selectedItem = nil
end

----------------------------------------------------------------
-- 子コンポーネントを生成します.
----------------------------------------------------------------
function M:createChildren()
    self._background = Panel()
    self._container = Component()
    
    self:addChild(self._background)
    self:addChild(self._container)
end

--------------------------------------------------------------------------------
-- 表示の更新を行います.
--------------------------------------------------------------------------------
function M:updateDisplay()
    self._background:setSize(self:getSize())
    self._container:setSize()
end

--------------------------------------------------------------------------------
-- リストに表示するアイテムを追加します.
--------------------------------------------------------------------------------
function M:addListItem(item)
    table.insertElement(self._container, item)
end

--------------------------------------------------------------------------------
-- リストに表示するアイテムを追加します.
--------------------------------------------------------------------------------
function M:addListItemAt(item, i)

end

--------------------------------------------------------------------------------
-- リストに表示するアイテムを削除します.
--------------------------------------------------------------------------------
function M:removeListItem(item)

end

--------------------------------------------------------------------------------
-- リストに表示する全てのアイテムを設定します.
--------------------------------------------------------------------------------
function M:setListItems(items)

end

--------------------------------------------------------------------------------
-- 選択済のアイテムを返します.
-- 未選択の場合は返しません.
--------------------------------------------------------------------------------
function M:getSelectedItem()

end

--------------------------------------------------------------------------------
-- 選択済のアイテムを設定します.
--------------------------------------------------------------------------------
function M:setSelectedItem(value)
    if self._selectedItem == value then
        return
    end
    
    if value and table.indexOf(self._container:getChildren(), value) > 0 then
        self._selectedItem
    else
        
    end
end

--------------------------------------------------------------------------------
-- リストアイテムのソート順を設定します.
-- ソート順を設定した場合、
--------------------------------------------------------------------------------
function M:setOrderBy(compare)
    
end

--------------------------------------------------------------------------------
-- リストボックスに表示可能な行数を設定します.
--------------------------------------------------------------------------------
function M:setRowCount(value)
    if self._rowCount ~= value then
        self._rowCount = value
        self._rowCountChanged = true
        self:invalidateAll()
    end
end

function M:calcRowCount()
    self:
end

--------------------------------------------------------------------------------
-- リストボックスに表示可能な行数を設定します.
--------------------------------------------------------------------------------
function M:getRowCount()
    return self._rowCount
end

function M:setListItemFactory(value)
    if self._listItemRendererFactory ~= value then
        self._listItemRendererFactory = value
        self._invalidItemFlag = true
    end
end

return M