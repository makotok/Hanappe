--------------------------------------------------------------------------------
-- Layout class for the ListView.
--
-- @author Makoto
-- @release V3.0.0
--------------------------------------------------------------------------------

-- import
local class = require "flower.class"
local table = require "flower.table"
local UILayout = require "flower.widget.UILayout"

-- class
local ListViewLayout = class(UILayout)

---
-- Initializes the internal variables.
function ListViewLayout:_initInternal()
    self._columnCount = 1
    self._rowHeight = 20
end

---
-- Update the layout.
-- @param parent parent
function ListViewLayout:update(parent)
    local children = self:getLayoutChildren(parent.children)
    local columnCount = self._columnCount
    local rowHeight = self._rowHeight
    local rowCount = math.floor(#children / columnCount)
    local parentWidth = parent.parent:getWidth()
    local parentHeight = rowHeight * rowCount

    for i, child in ipairs(children) do
        local childWidth = math.floor((parentWidth) / columnCount)
        local childHeight = rowHeight
        local childX = childWidth * ((i - 1) % columnCount)
        local childY = childHeight * math.floor((i - 1) / columnCount)

        child:setSize(childWidth, childHeight)
        child:setPos(childX, childY)
    end
end

function ListViewLayout:getLayoutChildren(children)
    local targets = {}
    for i, child in ipairs(children) do
        if not child._excludeLayout then
            table.insert(targets, child)
        end
    end
    return targets
end

function ListViewLayout:setColumnCount(columnCount)
    self._columnCount = assert(columnCount)
end

function ListViewLayout:setRowHeight(rowHeight)
    self._rowHeight = assert(rowHeight)
end

return ListViewLayout