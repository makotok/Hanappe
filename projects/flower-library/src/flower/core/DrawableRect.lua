----------------------------------------------------------------------------------------------------
-- Class to fill a rectangle. <br>
-- NOTE: This uses immediate mode drawing and so has a high performance impact when
-- used on mobile devices.  You may wish to use a 1-pixel high Image instead if you
-- wish to minimize draw calls.
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.lang.class"
local DrawableObject = require "flower.core.DrawableObject"

-- class
local DrawableRect = class(DrawableObject)

---
-- This is the function called when drawing.
-- @param index index of DrawCallback.
-- @param xOff xOff of DrawCallback.
-- @param yOff yOff of DrawCallback.
-- @param xFlip xFlip of DrawCallback.
-- @param yFlip yFlip of the Prop.
function DrawableRect:onDraw(index, xOff, yOff, xFlip, yFlip)
    local w, h, d = self:getSize()

    MOAIGfxDevice.setPenColor(self:getColor())
    MOAIDraw.fillRect(0, 0, w, h)
end

return DrawableRect