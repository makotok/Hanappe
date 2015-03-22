----------------------------------------------------------------------------------------------------
-- Class for drawing using the MOAIDraw.
--
-- <h4>Extends:</h4>
-- <ul>
--   <li><a href="flower.DisplayObject.html">DisplayObject</a><l/i>
-- </ul>
--
-- @author Makoto
-- @release V3.0.0
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.class"
local table = require "flower.table"
local Config = require "flower.Config"
local DisplayObject = require "flower.DisplayObject"

-- class
local DrawableObject = class(DisplayObject)

---
-- Constructor.
-- @param width Width
-- @param height Height
function DrawableObject:init(width, height)
    DrawableObject.__super.init(self)

    local deck = MOAIScriptDeck.new()
    deck:setRect(0, 0, width, height)

    self:setDeck(deck)
    self.deck = deck

    deck:setDrawCallback(
    function(index, xOff, yOff, xFlip, yFlip)
        self:onDraw(index, xOff, yOff, xFlip, yFlip)
    end
    )
end

---
-- This is the function called when drawing.
-- @param index index of DrawCallback.
-- @param xOff xOff of DrawCallback.
-- @param yOff yOff of DrawCallback.
-- @param xFlip xFlip of DrawCallback.
-- @param yFlip yFlip of the Prop.
function DrawableObject:onDraw(index, xOff, yOff, xFlip, yFlip)
-- Nop
end

---
-- Sets the size.
-- @param width Width
-- @param height Height
function DrawableObject:setSize(width, height)
    self.deck:setRect(0, 0, width, height)
end

return DrawableObject