----------------------------------------------------------------------------------------------------
-- It is a class that displays multiple items.
-- You can choose to scroll through the items.
--
-- @author Makoto
-- @release V3.0.0
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.lang.class"
local table = require "flower.lang.table"
local KeyCode = require "flower.core.KeyCode"
local InputMgr = require "flower.core.InputMgr"
local NineImage = require "flower.core.NineImage"
local UIEvent = require "flower.widget.UIEvent"
local Panel = require "flower.widget.Panel"

-- class
local ListBox = class(Panel)

--- Style: listItemFactory
ListBox.STYLE_LIST_ITEM_FACTORY = "listItemFactory"

--- Style: rowHeight
ListBox.STYLE_ROW_HEIGHT = "rowHeight"

--- Style: scrollBarTexture
ListBox.STYLE_SCROLL_BAR_TEXTURE = "scrollBarTexture"

---
-- Initialize a variables
function ListBox:_initInternal()
    ListBox.__super._initInternal(self)
    self._themeName = "ListBox"
    self._listItems = {}
    self._listData = {}
    self._freeListItems = {}
    self._selectedIndex = nil
    self._rowCount = 5
    self._columnCount = 1
    self._verticalScrollPosition = 0
    self._scrollBar = nil
    self._scrollBarVisible = true
    self._labelField = nil
    self._touchedIndex = nil
    self._keyMoveEnabled = true
    self._keyEnterEnabled = true
end

---
-- Initialize the event listeners.
function ListBox:_initEventListeners()
    ListBox.__super._initEventListeners(self)
    self:addEventListener(UIEvent.TOUCH_DOWN, self.onTouchDown, self)
    self:addEventListener(UIEvent.TOUCH_UP, self.onTouchUp, self)
    self:addEventListener(UIEvent.TOUCH_MOVE, self.onTouchMove, self)
    self:addEventListener(UIEvent.TOUCH_CANCEL, self.onTouchCancel, self)
end

---
-- Create the children.
function ListBox:_createChildren()
    ListBox.__super._createChildren(self)
    self:_createScrollBar()
end

---
-- Create the scrollBar
function ListBox:_createScrollBar()
    self._scrollBar = NineImage(self:getStyle(ListBox.STYLE_SCROLL_BAR_TEXTURE))
    self:addChild(self._scrollBar)
end

---
-- Update the rowCount
function ListBox:_updateRowCount()
    local xMin, yMin, xMax, yMax = self._backgroundImage:getContentRect()
    local contentWidth, contentHeight = xMax - xMin, yMax - yMin
    local rowHeight = self:getRowHeight()
    self._rowCount = math.floor(contentHeight / rowHeight)
end

---
-- Update the ListItems
function ListBox:_updateListItems()

    -- listItems
    local vsp = self:getVerticalScrollPosition()
    local rowCount = self:getRowCount()
    local colCount = self:getColumnCount()
    local minIndex = vsp * colCount + 1
    local maxIndex = vsp * colCount + rowCount * colCount
    local listSize = self:getListSize()
    for i = 1, listSize do
        if i < minIndex or maxIndex < i then
            self:_deleteListItem(i)
        else
            self:_createListItem(i)
        end
    end
end

---
-- Create the ListItem.
-- @param index index of the listItems
-- @return listItem
function ListBox:_createListItem(index)
    if not self._listItems[index] then
        local factory = self:getListItemFactory()
        local freeItems = self._freeListItems
        local listItem = #freeItems > 0 and table.remove(freeItems, 1) or factory:newInstance()
        self:addChild(listItem)
        self._listItems[index] = listItem
    end

    local vsp = self:getVerticalScrollPosition()
    local colCount = self:getColumnCount()
    local xMin, yMin, xMax, yMax = self._backgroundImage:getContentRect()
    local itemWidth = (xMax - xMin) / colCount
    local itemHeight = self:getRowHeight()
    local itemX = xMin + itemWidth * ((index - 1) % colCount)
    local itemY = yMin + (math.floor((index - 1) / colCount) - vsp) * itemHeight

    local listItem = self._listItems[index]
    listItem:setData(self._listData[index], index)
    listItem:setSize(itemWidth, itemHeight)
    listItem:setPos(itemX, itemY)
    listItem:setSelected(index == self._selectedIndex)
    listItem:setListComponent(self)

    return listItem
end

---
-- Delete the ListItem.
-- @param index index of the listItems
function ListBox:_deleteListItem(index)
    local listItem = self._listItems[index]
    if listItem then
        listItem:setSelected(false)
        self:removeChild(listItem)
        table.insert(self._freeListItems, listItem)
        self._listItems[index] = nil
    end
end

---
-- Clears the ListItems.
function ListBox:_clearListItems()
    for i = 1, #self._listItems do
        self:_deleteListItem(i)
    end
    self._freeListItems = {}
end

---
-- Update the scroll bar.
function ListBox:_updateScrollBar()
    local bar = self._scrollBar
    local xMin, yMin, xMax, yMax = self._backgroundImage:getContentRect()
    local vsp = self:getVerticalScrollPosition()
    local maxVsp = self:getMaxVerticalScrollPosition()
    local step = (yMax - yMin) / (maxVsp + 1)

    bar:setSize(bar:getWidth(), math.floor(math.max(step, bar.displayHeight)))

    step = step >= bar.displayHeight and step or (yMax - yMin - bar.displayHeight) / (maxVsp + 1)
    bar:setPos(xMax - bar:getWidth(), yMin + math.floor(step * vsp))
    bar:setVisible(maxVsp > 0 and self._scrollBarVisible)
end

---
-- Update the height by rowCount.
function ListBox:_updateHeightByRowCount()
    local rowCount = self:getRowCount()
    local rowHeight = self:getRowHeight()
    local pLeft, pTop, pRight, pBottom = self._backgroundImage:getContentPadding()

    self:setHeight(rowCount * rowHeight + pTop + pBottom)
end

---
-- Update the display.
function ListBox:updateDisplay()
    ListBox.__super.updateDisplay(self)

    self:_updateRowCount()
    self:_updateListItems()
    self:_updateScrollBar()
end

---
-- Update the priority.
-- @param priority priority
-- @return last priority
function ListBox:updatePriority(priority)
    priority = ListBox.__super.updatePriority(self, priority)
    self._scrollBar:setPriority(priority + 1)
    return priority + 10
end

---
-- Sets the list data.
-- @param listData listData
function ListBox:setListData(listData)
    self._listData = listData or {}
    self:_clearListItems()
    self:invalidateDisplay()
end

---
-- Returns the list data.
-- @return listData
function ListBox:getListData()
    return self._listData
end

---
-- Returns the list size.
-- @return size
function ListBox:getListSize()
    return #self._listData
end

---
-- Returns the ListItems.
-- Care must be taken to use the ListItems.
-- ListItems is used to cache internally rotate.
-- Therefore, ListItems should not be accessed from outside too.
-- @return listItems
function ListBox:getListItems()
    return self._listItems
end

---
-- Returns the ListItem.
-- @param index index of the listItems
-- @return listItem
function ListBox:getListItemAt(index)
    return self._listItems[index]
end

---
-- Sets the ListItemFactory.
-- @param factory ListItemFactory
function ListBox:setListItemFactory(factory)
    self:setStyle(ListBox.STYLE_LIST_ITEM_FACTORY, factory)
    self:_clearListItems()
    self:invalidateDisplay()
end

---
-- Returns the ListItemFactory.
-- @return ListItemFactory
function ListBox:getListItemFactory()
    return self:getStyle(ListBox.STYLE_LIST_ITEM_FACTORY)
end

---
-- Sets the selectedIndex.
-- @param index selectedIndex
function ListBox:setSelectedIndex(index)
    if index == self._selectedIndex then
        return
    end

    local oldItem = self:getSelectedItem()
    if oldItem then
        oldItem:setSelected(false)
    end

    self._selectedIndex = index

    local newItem = self:getSelectedItem()
    if newItem then
        newItem:setSelected(true)
    end

    local data = self._selectedIndex and self._listData[self._selectedIndex] or nil
    self:dispatchEvent(UIEvent.ITEM_CHANGED, data)
end

---
-- Returns the selectedIndex.
-- @return selectedIndex
function ListBox:getSelectedIndex()
    return self._selectedIndex
end

---
-- Returns the selected row index.
-- @return selected row index
function ListBox:getSelectedRowIndex()
    return self._selectedIndex and math.ceil(self._selectedIndex / self._columnCount) or nil
end

---
-- Returns the selected row index.
-- @return selected row index
function ListBox:getSelectedColumnIndex()
    return self._selectedIndex and (self._selectedIndex - 1) % self._columnCount + 1 or nil
end

---
-- Set the selected item.
-- @param item selected item
function ListBox:setSelectedItem(item)
    if item then
        self:setSelectedIndex(item:getDataIndex())
    else
        self:setSelectedIndex(nil)
    end
end

---
-- Set the scrollBar visible.
-- @param visible scrollBar visible
function ListBox:setScrollBarVisible(visible)
    self._scrollBarVisible = visible
    self._scrollBar:setVisible(maxVsp > 0 and self._scrollBarVisible)
end

---
-- Return the selected item.
-- @return selected item
function ListBox:getSelectedItem()
    if self._selectedIndex then
        return self._listItems[self._selectedIndex]
    end
end

---
-- Set the labelField.
-- @param labelField labelField
function ListBox:setLabelField(labelField)
    self._labelField = labelField
    self:invalidateDisplay()
end

---
-- Return the labelField.
-- @return labelField
function ListBox:getLabelField()
    return self._labelField
end

---
-- Set the verticalScrollPosition.
-- @param pos verticalScrollPosition
function ListBox:setVerticalScrollPosition(pos)
    if self._verticalScrollPosition == pos then
        return
    end
    self._verticalScrollPosition = math.max(0, math.min(self:getMaxVerticalScrollPosition(), pos))
    self:invalidateDisplay()
end

---
-- Return the verticalScrollPosition.
-- @return verticalScrollPosition
function ListBox:getVerticalScrollPosition()
    return self._verticalScrollPosition
end

---
-- Return the maxVerticalScrollPosition.
-- @return maxVerticalScrollPosition
function ListBox:getMaxVerticalScrollPosition()
    return math.max(math.floor(self:getListSize() / self:getColumnCount()) - self:getRowCount(), 0)
end

---
-- Set the height of the row.
-- @param rowHeight height of the row
function ListBox:setRowHeight(rowHeight)
    self:setStyle(ListBox.STYLE_ROW_HEIGHT, rowHeight)
    self:invalidateDisplay()
end

---
-- Return the height of the row.
-- @return rowHeight
function ListBox:getRowHeight()
    return self:getStyle(ListBox.STYLE_ROW_HEIGHT)
end

---
-- Set the count of the rows.
-- @param rowCount count of the rows
function ListBox:setRowCount(rowCount)
    self._rowCount = rowCount
    self:_updateHeightByRowCount()
    self:invalidateDisplay()
end

---
-- Return the count of the rows.
-- @return rowCount
function ListBox:getRowCount()
    return self._rowCount
end

---
-- Set the count of the columns.
-- @param columnCount count of the columns
function ListBox:setColumnCount(columnCount)
    assert(columnCount >= 1, "columnCount property error!")

    self._columnCount = columnCount
    self:invalidateDisplay()
end

---
-- Return the count of the columns.
-- @return columnCount
function ListBox:getColumnCount()
    return self._columnCount
end

---
-- Returns true if the component has been touched.
-- @return touching
function ListBox:isTouching()
    return self._touchedIndex ~= nil
end

---
-- Set the texture path of the scroll bar.
-- Needs to be NinePatch.
-- @param texture texture path.
function ListBox:setScrollBarTexture(texture)
    self:setStyle(ListBox.STYLE_SCROLL_BAR_TEXTURE, texture)
    self._scrollBar:setImage(texture)
    self:_updateScrollBar()
end

---
-- Set the event listener that is called when the user item changed.
-- @param func event handler
function ListBox:setOnItemChanged(func)
    self:setEventListener(UIEvent.ITEM_CHANGED, func)
end

---
-- Set the event listener that is called when the user item changed.
-- @param func event handler
function ListBox:setOnItemEnter(func)
    self:setEventListener(UIEvent.ITEM_ENTER, func)
end

---
-- Set the event listener that is called when the user item changed.
-- @param func event handler
function ListBox:setOnItemClick(func)
    self:setEventListener(UIEvent.ITEM_CLICK, func)
end

---
-- TODO:Doc
function ListBox:findListItemByPos(x, y)
    local listSize = self:getListSize()

    for i = 1, listSize do
        local item = self:getListItemAt(i)
        if item and item:inside(x, y, 0) then
            return item
        end
    end
end

---
-- This event handler is called when focus in.
-- @param e event
function ListBox:onFocusIn(e)
    ListBox.__super.onFocusIn(self, e)

    InputMgr:addEventListener(UIEvent.KEY_DOWN, self.onKeyDown, self)
    InputMgr:addEventListener(UIEvent.KEY_UP, self.onKeyUp, self)
end

---
-- This event handler is called when focus in.
-- @param e event
function ListBox:onFocusOut(e)
    ListBox.__super.onFocusOut(self, e)

    InputMgr:removeEventListener(UIEvent.KEY_DOWN, self.onKeyDown, self)
    InputMgr:removeEventListener(UIEvent.KEY_UP, self.onKeyUp, self)
end

---
-- This event handler is called when touch.
-- @param e Touch Event
function ListBox:onTouchDown(e)
    if self._touchedIndex ~= nil and self._touchedIndex ~= e.idx then
        return
    end
    self._touchedIndex = e.idx
    self._touchedY = e.wy
    self._touchedVsp = self:getVerticalScrollPosition()
    self._touchedOldItem = self:getSelectedItem()
    self._itemClickCancelFlg = false

    local item = self:findListItemByPos(e.wx, e.wy)
    self:setSelectedItem(item)
end

---
-- This event handler is called when touch.
-- @param e Touch Event
function ListBox:onTouchUp(e)
    if self._touchedIndex ~= e.idx then
        return
    end

    local item = self:getSelectedItem()
    local oldVsp = self._touchedVsp
    local nowVsp = self:getVerticalScrollPosition()

    if item and item:getData() and not self._itemClickCancelFlg then
        self:dispatchEvent(UIEvent.ITEM_CLICK, item:getData())

        if self._touchedOldItem == item then
            self:dispatchEvent(UIEvent.ITEM_ENTER, item:getData())
        end
    end

    self._touchedIndex = nil
    self._touchedY = nil
    self._touchedVsp = nil
    self._itemClickCancelFlg = false
end

---
-- This event handler is called when touch.
-- @param e Touch Event
function ListBox:onTouchMove(e)
    if self._touchedIndex ~= e.idx then
        return
    end
    local rowHeight = self:getRowHeight()
    local delta = self._touchedY - e.wy
    local oldVsp = self:getVerticalScrollPosition()
    local newVsp = self._touchedVsp + math.floor(delta / rowHeight)

    if oldVsp ~= newVsp then
        self._itemClickCancelFlg = true
        self:setVerticalScrollPosition(newVsp)
    end
end

---
-- This event handler is called when touch.
-- @param e Touch Event
function ListBox:onTouchCancel(e)
    self:onTouchUp(e)
end

---
-- This event handler is called when key down.
-- @param e event
function ListBox:onKeyDown(e)

    -- move selectedIndex
    if self._keyMoveEnabled then
        local selectedIndex = self:getSelectedIndex()
        local columnCount = self:getColumnCount()
        if e.key == KeyCode.KEY_UP then
            selectedIndex = selectedIndex and math.max(1, selectedIndex - columnCount) or 1
            self:setSelectedIndex(selectedIndex)

            local rowIndex = self:getSelectedRowIndex()
            if rowIndex <= self:getVerticalScrollPosition() then
                self:setVerticalScrollPosition(self:getVerticalScrollPosition() - 1)
            end
        elseif e.key == KeyCode.KEY_DOWN then
            selectedIndex = selectedIndex and math.min(self:getListSize(), selectedIndex + columnCount) or 1
            self:setSelectedIndex(selectedIndex)

            local rowIndex = self:getSelectedRowIndex()
            if rowIndex > self:getVerticalScrollPosition() + self:getRowCount() then
                self:setVerticalScrollPosition(self:getVerticalScrollPosition() + 1)
            end
        elseif e.key == KeyCode.KEY_LEFT then
            local rowIndex = selectedIndex and self:getSelectedRowIndex() or 1
            local minIndex = (rowIndex - 1) * columnCount + 1
            selectedIndex = selectedIndex and math.max(minIndex, selectedIndex - 1) or 1
            self:setSelectedIndex(selectedIndex)
        elseif e.key == KeyCode.KEY_RIGHT then
            local rowIndex = selectedIndex and self:getSelectedRowIndex() or 1
            local maxIndex = rowIndex * columnCount
            selectedIndex = selectedIndex and math.min(maxIndex, selectedIndex + 1) or 1
            self:setSelectedIndex(selectedIndex)
        end
    end

    -- dispatch itemClick event
    if self._keyEnterEnabled then
        if e.key == KeyCode.KEY_ENTER then
            local selectedItem = self:getSelectedItem()
            if selectedItem then
                self:dispatchEvent(UIEvent.ITEM_CLICK, selectedItem:getData())
            end
        end
    end

end

---
-- This event handler is called when key up.
-- @param e event
function ListBox:onKeyUp(e)

end

return ListBox