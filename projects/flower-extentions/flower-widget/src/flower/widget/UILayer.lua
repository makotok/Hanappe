----------------------------------------------------------------------------------------------------
-- Layer class for the Widget.
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.class"
local table = require "flower.table"
local Layer = require "flower.Layer"
local UIEvent = require "flower.widget.UIEvent"
local TextAlign = require "flower.widget.TextAlign"
local UIComponent = require "flower.widget.UIComponent"
local FocusMgr = require "flower.widget.FocusMgr"

-- class
local UILayer = class(Layer)

---
-- The constructor.
-- @param viewport (option)viewport
function UILayer:init(viewport)
    UILayer.__super.init(self, viewport)
    self.focusOutEnabled = true
    self.focusMgr = FocusMgr.getInstance()

    self:setSortMode(MOAILayer.SORT_PRIORITY_ASCENDING)
    self:setTouchEnabled(true)
    self:addEventListener(UIEvent.TOUCH_DOWN, self.onTouchDown, self, 10)
end

---
-- Sets the scene for layer.
-- @param scene scene
function UILayer:setScene(scene)
    if self.scene == scene then
        return
    end

    if self.scene then
        self.scene:removeEventListener(UIEvent.STOP, self.onSceneStop, self, -10)
    end

    UILayer.__super.setScene(self, scene)

    if self.scene then
        self.scene:addEventListener(UIEvent.STOP, self.onSceneStop, self, -10)
    end
end

function UILayer:onTouchDown(e)
    if self.focusOutEnabled then
        self.focusMgr:setFocusObject(nil)
    end
end

---
-- This event handler is called when you start the scene.
-- @param e Scene Event
function UILayer:onSceneStart(e)
    -- TODO:
end

---
-- This event handler is called when you stop the scene.
-- @param e Scene Event
function UILayer:onSceneStop(e)
    self.focusMgr:setFocusObject(nil)
end

return UILayer