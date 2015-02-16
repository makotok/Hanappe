----------------------------------------------------------------------------------------------------
-- This is a singleton class that manages the rendering object.
--
-- <h4>Extends:</h4>
-- <ul>
--   <li><a href="flower.core.EventDispatcher.html">EventDispatcher</a><l/i>
-- </ul>
--
-- @author Makoto
-- @release V3.0.0
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.lang.class"
local table = require "flower.lang.table"
local Runtime = require "flower.core.Runtime"
local Event = require "flower.core.Event"
local EventDispatcher = require "flower.core.EventDispatcher"

-- class
local RenderMgr = EventDispatcher()

-- variables
RenderMgr.renders = {}

---
-- Initialize the RenderMgr.
function RenderMgr:initialize()
    Runtime:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
end

---
-- Add a Render object.
-- @param render Render object
function RenderMgr:addChild(render)
    table.insertIfAbsent(self.renders, render)
    self:invalidate()
end

---
-- Remove a Render object.
-- @param render Render object
function RenderMgr:removeChild(render)
    table.removeElement(self.renders, render)
    self:invalidate()
end

---
-- Update Moai's RenderTable with flower's render list.
function RenderMgr:updateRenderTable()
    local renderTable = {}
    for i, v in ipairs(self.renders) do
        local render = v.getRenderTable and v:getRenderTable() or v
        table.insertElement(renderTable, render)
    end
    MOAIRenderMgr.setRenderTable(renderTable)
end

---
-- Invalidate the renderTable.
function RenderMgr:invalidate()
    self.invalidFlag = true
end

---
-- Event handler for the enter frame.  Revalidates the render table if it has
-- been changed since the last frame.
function RenderMgr:onEnterFrame()
    if self.invalidFlag then
        self:updateRenderTable()
        self.invalidFlag = false
    end
end

RenderMgr:initialize()

return RenderMgr