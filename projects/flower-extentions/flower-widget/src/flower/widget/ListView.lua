----------------------------------------------------------------------------------------------------
-- List view class.
--
-- @author Makoto
-- @release V3.0.0
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.class"
local table = require "flower.table"
local UIEvent = require "flower.widget.UIEvent"
local PanelView = require "flower.widget.PanelView"
local ListViewLayout = require "flower.widget.ListViewLayout"

-- class
local ListView = class(PanelView)

--- Style: listItemFactory
ListView.STYLE_ITEM_RENDERER_FACTORY = "itemRendererFactory"

--- Style: rowHeight
ListView.STYLE_ROW_HEIGHT = "rowHeight"

--- Style: columnCount
ListView.STYLE_COLUMN_COUNT = "columnCount"

--- Event: selectedChanged
ListView.EVENT_SELECTED_CHANGED = "selectedChanged"

--- Event: itemClick
ListView.EVENT_ITEM_CLICK = "itemClick"

---
-- Initializes the internal variables.
function ListView:_initInternal()
    ListView.__super._initInternal(self)
    self._themeName = "ListView"
    self._dataSource = {}
    self._dataField = nil
    self._selectedItems = {}
    self._selectionMode = "single"
    self._itemRenderers = {}
    self._itemToRendererMap = {}
    self._itemRendererChanged = false
    self._touchedRenderer = nil
end

---
-- Create the children objects.
function ListView:_createChildren()
    ListView.__super._createChildren(self)

    local layout = ListViewLayout {
        rowHeight = self:getRowHeight(),
        columnCount = self:getColumnCount(),
    }
    self:setLayout(layout)
end

---
-- Update the item renderers.
function ListView:_updateItemRenderers()
    if not self._itemRendererChanged then
        return
    end
    for i, data in ipairs(self:getDataSource()) do
        self:_updateItemRenderer(data, i)
    end

    if #self._itemRenderers > #self:getDataSource() then
        for i = #self._itemRenderers, #self:getDataSource() do
            self:_removeItemRenderer(self._itemRenderers[i])
        end
    end

    self._itemRendererChanged = false
end

---
-- Update the item renderer.
-- @param data data.
-- @param index index of items.
function ListView:_updateItemRenderer(data, index)
    local renderer = self._itemRenderers[index]
    if not renderer then
        renderer = self:getItemRendererFactory():newInstance()
        table.insert(self._itemRenderers, renderer)
        self:addContent(renderer)
    end
    renderer:setData(data)
    renderer:setDataIndex(index)
    renderer:setDataField(self:getDataField())
    renderer:setHostComponent(self)
    renderer:addEventListener(UIEvent.TOUCH_DOWN, self.onItemRendererTouchDown, self)
    renderer:addEventListener(UIEvent.TOUCH_UP, self.onItemRendererTouchUp, self)
    renderer:addEventListener(UIEvent.TOUCH_CANCEL, self.onItemRendererTouchCancel, self)

    self._itemToRendererMap[data] = renderer
end

---
-- Remove the item renderers.
function ListView:_removeItemRenderers()
    for i, renderer in ipairs(self._itemRenderers) do
        self:_removeItemRenderer(renderer)
    end

    self._itemRenderers = {}
    self._itemToRendererMap = {}
end

---
-- Remove the item renderer.
-- @param renderer item renderer.
function ListView:_removeItemRenderer(renderer)
    renderer:removeEventListener(UIEvent.TOUCH_DOWN, self.onItemRendererTouchDown, self)
    renderer:removeEventListener(UIEvent.TOUCH_UP, self.onItemRendererTouchUp, self)
    renderer:removeEventListener(UIEvent.TOUCH_CANCEL, self.onItemRendererTouchCancel, self)

    self:removeContent(renderer)
    table.removeElement(self._itemRenderers, renderer)
    self._itemToRendererMap[renderer:getData()] = nil
end

---
-- Update the display
function ListView:updateDisplay()
    ListView.__super.updateDisplay(self)
    self:_updateItemRenderers()
end

---
-- Update the display
function ListView:updateLayout()
    if self:getContentLayout() then
        self:getContentLayout():setRowHeight(self:getRowHeight())
        self:getContentLayout():setColumnCount(self:getColumnCount())
    end

    ListView.__super.updateLayout(self)
end

---
-- Invalidate item renderers.
function ListView:invalidateItemRenderers()
    if not self._itemRendererChanged then
        self:invalidateDisplay()
        self._itemRendererChanged = true
    end
end

---
-- Set the selected item.
-- @param item selected item.
function ListView:setSelectedItem(item)
    self:setSelectedItems(item and {item} or {})
end

---
-- Return the selected item.
-- @return selected item.
function ListView:getSelectedItem()
    if #self._selectedItems > 0 then
        return self._selectedItems[1]
    end
end

---
-- Sets the selected items.
-- @param items selected items.
function ListView:setSelectedItems(items)
    assert(self._selectionMode == "single" and #items < 2)

    local changed = #items ~= #self._selectedItems
    if not changed then
        for i, item in ipairs(items) do
            if item ~= self._selectedItems[i] then
                changed = true
                break
            end
        end

        if not changed then
            return
        end
    end

    for i, selectedItem in ipairs(self._selectedItems) do
        local renderer = self._itemToRendererMap[selectedItem]

        if renderer then
            renderer:setSelected(false)
        end
    end

    self._selectedItems = {}
    for i, item in ipairs(items) do
        local renderer = self._itemToRendererMap[item]

        if renderer then
            renderer:setSelected(true)
            table.insert(self._selectedItems, item)
        end
    end

    self:dispatchEvent(ListView.EVENT_SELECTED_CHANGED, self._selectedItems)
end

---
-- Set the dataSource.
-- @param dataSource dataSource
function ListView:setDataSource(dataSource)
    if self._dataSource ~= dataSource then
        self._dataSource = dataSource
        self:invalidateItemRenderers()
    end
end

---
-- Return the dataSource.
-- @return dataSource
function ListView:getDataSource()
    return self._dataSource
end

---
-- Set the dataField.
-- @param dataField dataField
function ListView:setDataField(dataField)
    if self._dataField ~= dataField then
        self._dataField = dataField
        self:invalidateItemRenderers()
    end
end

---
-- Return the dataField.
-- @return dataField
function ListView:getDataField()
    return self._dataField
end

---
-- Sets the itemRendererFactory.
-- @param factory itemRendererFactory
function ListView:setItemRendererFactory(factory)
    if self:getItemRendererFactory() ~= factory then
        self:setStyle(ListView.STYLE_ITEM_RENDERER_FACTORY, factory)
        self:_removeItemRenderers()
        self:invalidateItemRenderers()
    end
end

---
-- Returns the itemRendererFactory.
-- @return itemRendererFactory
function ListView:getItemRendererFactory()
    return self:getStyle(ListView.STYLE_ITEM_RENDERER_FACTORY)
end

---
-- Set the height of the row.
-- @param rowHeight height of the row
function ListView:setRowHeight(rowHeight)
    if self:getRowHeight() ~= rowHeight then
        self:setStyle(ListView.STYLE_ROW_HEIGHT, rowHeight)
        self:invalidateLayout()
    end
end

---
-- Return the height of the row.
-- @return rowHeight
function ListView:getRowHeight()
    return self:getStyle(ListView.STYLE_ROW_HEIGHT)
end


---
-- Set the count of the columns.
-- @param columnCount count of the columns
function ListView:setColumnCount(columnCount)
    if self:getColumnCount() ~= columnCount then
        self:setStyle(ListView.STYLE_COLUMN_COUNT, columnCount)
        self:invalidateLayout()
    end
end

---
-- Return the count of the columns.
-- @return columnCount
function ListView:getColumnCount()
    return self:getStyle(ListView.STYLE_COLUMN_COUNT)
end

---
-- Set the event listener that is called when the selected changed.
-- @param func selected changed event handler
function ListView:setOnSelectedChanged(func)
    self:setEventListener(ListView.EVENT_SELECTED_CHANGED, func)
end

---
-- Set the event listener that is called when the item click.
-- @param func selected changed event handler
function ListView:setOnItemClick(func)
    self:setEventListener(ListView.EVENT_ITEM_CLICK, func)
end

---
-- This event handler is called when touch.
-- @param e Touch Event
function ListView:onItemRendererTouchDown(e)
    if self._touchedRenderer ~= nil then
        return
    end

    local renderer = e.target
    if renderer.isRenderer then
        renderer:setPressed(true)
        renderer:setSelected(true)
        self:setSelectedItem(renderer:getData())
        self._touchedRenderer = renderer
    end
end

---
-- This event handler is called when touch.
-- @param e Touch Event
function ListView:onItemRendererTouchUp(e)
    if self._touchedRenderer == nil or self._touchedRenderer ~= e.target then
        return
    end

    self._touchedRenderer = nil
    local renderer = e.target
    if renderer.isRenderer then
        renderer:setPressed(false)
        self:dispatchEvent(ListView.EVENT_ITEM_CLICK, renderer:getData())
    end
end

---
-- This event handler is called when touch.
-- @param e Touch Event
function ListView:onItemRendererTouchCancel(e)
    if self._touchedRenderer == nil or self._touchedRenderer ~= e.target then
        return
    end
    
    self._touchedRenderer = nil
    local renderer = e.target
    if renderer.isRenderer then
        renderer:setPressed(false)
        self:setSelectedItem(nil)
    end
end

return ListView