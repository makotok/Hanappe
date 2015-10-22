----------------------------------------------------------------------------------------------------
-- List view class.
--
-- <h4>Extends:</h4>
-- <ul>
--   <li><a href="flower.widget.PanelView.html">PanelView</a><l/i>
-- </ul>
--
-- @author Makoto
-- @release V3.0.0
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.class"
local table = require "flower.table"
local ClassFactory = require "flower.ClassFactory"
local UIEvent = require "flower.widget.UIEvent"
local PanelView = require "flower.widget.PanelView"
local ListViewLayout = require "flower.widget.ListViewLayout"

-- class
local ListView = class(PanelView)

--- Style: listItemFactory
ListView.STYLE_ITEM_RENDERER_FACTORY = "itemRendererFactory"

--- Style: rowHeight
ListView.STYLE_ROW_HEIGHT = "rowHeight"

--- Style: rowCount
ListView.STYLE_ROW_COUNT = "rowCount"

--- Style: columnCount
ListView.STYLE_COLUMN_COUNT = "columnCount"

--- Event: selectedChanged
ListView.EVENT_SELECTED_CHANGED = "selectedChanged"

--- Event: itemClick
ListView.EVENT_ITEM_CLICK = "itemClick"

--- Event: itemEnter
ListView.EVENT_ITEM_ENTER = "itemEnter"

---
-- Initializes the internal variables.
function ListView:_initInternal()
    ListView.__super._initInternal(self)
    self._themeName = "ListView"
    self._dataSource = {}
    self._selectedItems = {}
    self._selectionMode = "single"
    self._itemRenderers = {}
    self._itemProperties = nil
    self._itemToRendererMap = {}
    self._itemRendererChanged = false
    self._touchedRenderer = nil
    self._touchedOldSelectedItem = nil
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
-- TODO:LDoc
function ListView:_updateViewHeightByRowCount()
    if self:getRowHeight() == nil or self:getRowCount() == nil then
        return
    end

    local rowCount = self:getRowCount()
    local rowHeight = self:getRowHeight()
    local pLeft, pTop, pRight, pBottom = 0, 0, 0, 0

    if self:getBackgroundVisible() then
        pLeft, pTop, pRight, pBottom = self._backgroundPanel:getContentPadding()
    end

    self:setHeight(rowCount * rowHeight + pTop + pBottom)

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

    local renderersSize = #self._itemRenderers
    if renderersSize > self:getDataLength() then
        for i = self:getDataLength() + 1, renderersSize do
            self:_removeItemRenderer(self._itemRenderers[i], self:getItemAt(i))
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
    renderer:setProperties(self._itemProperties)
    renderer:setData(data)
    renderer:setSelected(table.indexOf(self._selectedItems, data) > 0)
    renderer:setDataIndex(index)
    renderer:setHostComponent(self)
    renderer:setRowIndex(1 + math.floor(index / self:getColumnCount()))
    renderer:setColumnIndex(1 + index % self:getColumnCount())
    renderer:addEventListener(UIEvent.TOUCH_DOWN, self.onItemRendererTouchDown, self)
    renderer:addEventListener(UIEvent.TOUCH_UP, self.onItemRendererTouchUp, self)
    renderer:addEventListener(UIEvent.TOUCH_CANCEL, self.onItemRendererTouchCancel, self)

    self._itemToRendererMap[data] = renderer
end

---
-- Remove the item renderers.
function ListView:_removeItemRenderers()
    for i, renderer in ipairs(self._itemRenderers) do
        self:_removeItemRenderer(renderer, renderer:getData())
    end

    self._itemRenderers = {}
    self._itemToRendererMap = {}
end

---
-- Remove the item renderer.
-- @param renderer item renderer.
-- @param item item data.
function ListView:_removeItemRenderer(renderer, item)
    renderer:removeEventListener(UIEvent.TOUCH_DOWN, self.onItemRendererTouchDown, self)
    renderer:removeEventListener(UIEvent.TOUCH_UP, self.onItemRendererTouchUp, self)
    renderer:removeEventListener(UIEvent.TOUCH_CANCEL, self.onItemRendererTouchCancel, self)

    self:removeContent(renderer)
    table.removeElement(self._itemRenderers, renderer)
    if item then
        self._itemToRendererMap[item] = nil
    end
end

---
-- Update the display
function ListView:updateDisplay()
    ListView.__super.updateDisplay(self)
    self:_updateItemRenderers()
end

---
-- Update the layout.
function ListView:updateLayout()
    if self:getContentLayout() then
        self:getContentLayout():setRowHeight(self:getRowHeight())
        self:getContentLayout():setColumnCount(self:getColumnCount())
    end

    ListView.__super.updateLayout(self)
end

---
-- Update the order of rendering.
-- It is called by LayoutMgr.
-- @param priority priority.
-- @return last priority
function ListView:updatePriority(priority)
    priority = ListView.__super.updatePriority(self, priority)

    for i, renderer in ipairs(self._itemRenderers) do
        renderer:setPriority(priority)
    end

    return priority + 10
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
-- Returns the current item renderers.
-- @return current item renderers.
function ListView:getItemRenderers()
    return self._itemRenderers
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
-- Return the selected index.
-- @return selected index
function ListView:getSelectedIndex()
    local item = self:getSelectedItem()
    return item and table.indexOf(self:getDataSource(), item) or -1
end

---
-- Set the selected index.
-- @param index selected index.
function ListView:setSelectedIndex(index)
    self:setSelectedItem(self:getItemAt(index))
end

---
-- Return the selected items.
-- @return selected items
function ListView:getSelectedItems()
    return table.copy(self._selectedItems)
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
-- Returns the item at index.
-- @param index index of the dataSource.
-- @return item of the dataSource.
function ListView:getItemAt(index)
    return self._dataSource[index]
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
-- Return the length of dataSource.
-- @return data length
function ListView:getDataLength()
    return #self._dataSource
end

---
-- Add the item to dataSource.
-- @param item insert item.
-- @param index (option)insert index.
function ListView:addItem(item, index)
    if index then
        table.insert(self._dataSource, index, item)
    else
        table.insertElement(self._dataSource, item)
    end

    self:invalidateItemRenderers()
end

---
-- Remove the item from dataSource.
-- @param item item
function ListView:removeItem(item)
    if table.removeElement(self._dataSource, item) > 0 then
        self:invalidateItemRenderers()
    end
end

---
-- Remove the data from dataSource by index.
-- @param index index
function ListView:removeItemAt(index)
    if index <= self:getDataLength() then
        table.remove(self._dataSource, i)
        self:invalidateItemRenderers()
    end
end

---
-- Sets the ItemRenderer class.
-- @param clazz ItemRenderer class
function ListView:setItemRendererClass(clazz)
    self:setItemRendererFactory(clazz and ClassFactory(clazz))
end

---
-- Sets the ItemRenderer properties.
-- @param properties ItemRenderer properties
function ListView:setItemProperties(properties)
    if self._itemProperties ~= properties then
        self._itemProperties = properties
        self:invalidateItemRenderers()
    end
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
        self:_updateViewHeightByRowCount()
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
-- Set the rowCount.
-- @param value rowCount
function ListView:setRowCount(value)
    if self:getRowCount() ~= value then
        self:setStyle(ListView.STYLE_ROW_COUNT, value)
        self:_updateViewHeightByRowCount()
        self:invalidateLayout()
    end
end

---
-- Return the rowCount.
-- @return rowCount
function ListView:getRowCount()
    return self:getStyle(ListView.STYLE_ROW_COUNT)
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
-- Set the visible of the background.
-- @param visible visible
function ListView:setBackgroundVisible(visible)
    ListView.__super.setBackgroundVisible(self, visible)
    self:_updateViewHeightByRowCount()
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
-- Set the event listener that is called when the item click.
-- @param func selected changed event handler
function ListView:setOnItemEnter(func)
    self:setEventListener(ListView.EVENT_ITEM_ENTER, func)
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
        self._touchedOldSelectedItem = self:getSelectedItem()

        renderer:setPressed(true)
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

        if self._touchedOldSelectedItem == renderer:getData() then
            self:dispatchEvent(ListView.EVENT_ITEM_ENTER, renderer:getData())
        end
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