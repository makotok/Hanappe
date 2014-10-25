----------------------------------------------------------------
-- This is the class that displays a message in the panel.
----------------------------------------------------------------

-- import
local table             = require "hp/lang/table"
local class             = require "hp/lang/class"
local NinePatch         = require "hp/display/NinePatch"
local TextLabel         = require "hp/display/TextLabel"
local Animation         = require "hp/display/Animation"
local Event             = require "hp/event/Event"
local Component         = require "hp/gui/Component"
local Panel             = require "hp/gui/Panel"

-- class
local M                 = class(Panel)
local super             = Panel

-- Events
M.EVENT_MESSAGE_SHOW    = "messageShow"
M.EVENT_MESSAGE_END     = "messageEnd"
M.EVENT_MESSAGE_HIDE    = "messageHide"

--------------------------------------------------------------------------------
-- Initializes the internal variables.
--------------------------------------------------------------------------------
function M:initInternal()
    super.initInternal(self)
    
    self._themeName = "MessageBox"
    self._messageHideEnabled = true
    self._spoolingEnabled = true
    
    self._popInAnimation = Animation():parallel(
        Animation(self, 0.5):setScl(0.8, 0.8, 1):seekScl(1, 1, 1),
        Animation(self, 0.5):setColor(0, 0, 0, 0):seekColor(1, 1, 1, 1)
    )
    self._popOutAnimation = Animation():parallel(
        Animation(self, 0.5):seekScl(0.8, 0.8, 1),
        Animation(self, 0.5):seekColor(0, 0, 0, 0)
    )
end

--------------------------------------------------------------------------------
-- Create a child objects.
--------------------------------------------------------------------------------
function M:createChildren()
    super.createChildren(self)
    
    self._textLabel = TextLabel()
    self._textLabel:setWordBreak(MOAITextBox.WORD_BREAK_CHAR)
    self:addChild(self._textLabel)
    
    self:setColor(0, 0, 0, 0)
end

--------------------------------------------------------------------------------
-- Update the display.
--------------------------------------------------------------------------------
function M:updateDisplay()
    super.updateDisplay(self)

    local pLeft, pTop, pRight, pBottom = unpack(self:getStyle("textPadding"))
    local tWidth = self:getWidth() - pLeft - pRight
    local tHeight = self:getHeight() - pTop - pBottom
    
    self._textLabel:setSize(tWidth, tHeight)
    self._textLabel:setPos(pLeft, pTop)
    self._textLabel:setColor(unpack(self:getStyle("textColor")))
    self._textLabel:setTextSize(self:getStyle("textSize"))
    self._textLabel:setFont(self:getStyle("font"))
end

--------------------------------------------------------------------------------
-- Turns spooling ON or OFF.
-- If self is currently spooling and enable is false, stop spooling and reveal 
-- entire page. 
-- @param enable Boolean for new state
-- @return none
-------------------------------------------------------------------------------
function M:spoolingEnabled(enable)
    self._spoolingEnabled = enable and true or false
    if self._spoolingEnabled == false and self:isBusy() then
        self._textLabel:stop()
        self._textLabel:revealAll()
    end
end

--------------------------------------------------------------------------------
-- Displays a message box in the pop-up effect.
--------------------------------------------------------------------------------
function M:show()
    self:setVisible(true)
    self:setCenterPiv()
    self:setText(self:getText())

    if self._spoolingEnabled then
        self._textLabel:setReveal(0)
    end
    self._popInAnimation:play {onComplete =
        function()
            if self._spoolingEnabled then
                self:spool()
            end
            self:dispatchEvent(M.EVENT_MESSAGE_SHOW)
        end
    }
end

--------------------------------------------------------------------------------
-- To hide the message box in the pop-up effect.
--------------------------------------------------------------------------------
function M:hide()
    if self._popInAnimation:isRunning() then
        return
    end
    
    self._popOutAnimation:play {onComplete = 
        function()
            self:setVisible(false)
            self:dispatchEvent(M.EVENT_MESSAGE_HIDE)
        end
    }
end

--------------------------------------------------------------------------------
-- Spools the text.
--------------------------------------------------------------------------------
function M:spool()
    self:spoolingEnabled(true)
    return self._textLabel:spool()
end

--------------------------------------------------------------------------------
-- Displays the next page.
--------------------------------------------------------------------------------
function M:nextPage()
    return self._textLabel:nextPage()
end

--------------------------------------------------------------------------------
-- Returns the next page if exists.
-- @return If the next page there is a true
--------------------------------------------------------------------------------
function M:more()
    return self._textLabel:more()
end

--------------------------------------------------------------------------------
-- Returns in the process whether messages are displayed.
-- @return busy
--------------------------------------------------------------------------------
function M:isBusy()
    return self._textLabel:isBusy()
end

--------------------------------------------------------------------------------
-- Sets the text.
-- @param text text
--------------------------------------------------------------------------------
function M:setText(text)
    self._text = text
    self._textLabel:setText(text)
end

--------------------------------------------------------------------------------
-- Sets the text.
-- @return text
--------------------------------------------------------------------------------
function M:getText()
    return self._text
end

--------------------------------------------------------------------------------
-- Sets the color of the text.
-- @param r red
-- @param g green
-- @param b blue
-- @param a alpha
--------------------------------------------------------------------------------
function M:setTextColor(r, g, b, a)
    self:setStyle(M.STATE_NORMAL, "textColor", {r, g, b, a})
end

--------------------------------------------------------------------------------
-- Set the size of the text.
-- @param points points
--------------------------------------------------------------------------------
function M:setTextSize(points)
    self:setStyle(M.STATE_NORMAL, "textSize", points)
end

--------------------------------------------------------------------------------
-- Set the event listener was called to display a message box.
-- @param func event listener
--------------------------------------------------------------------------------
function M:setOnMessageShow(func)
    self:setEventListener(M.EVENT_MESSAGE_SHOW, func)
end

--------------------------------------------------------------------------------
-- Set the event listener was called to hide a message box.
-- @param func event listener
--------------------------------------------------------------------------------
function M:setOnMessageHide(func)
    self:setEventListener(M.EVENT_MESSAGE_HIDE, func)
end

--------------------------------------------------------------------------------
-- Set the event listener was called to end a message box.
-- @param func event listener
--------------------------------------------------------------------------------
function M:setOnMessageEnd(func)
    self:setEventListener(M.EVENT_MESSAGE_END, func)
end

----------------------------------------------------------------------------------------------------
-- Event Handler
----------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- This event handler is called when you touch the component.
-- @param e touch event
--------------------------------------------------------------------------------
function M:touchDownHandler(e)
    if self:isBusy() then
        self._textLabel:stop()
        self._textLabel:revealAll()
    elseif self:more() then
        self:nextPage()
        if self._spoolingEnabled then
            self:spool()
        end
    else
        self:enterMessageEnd()
    end
end

--------------------------------------------------------------------------------
-- This is called when a message has been completed.
--------------------------------------------------------------------------------
function M:enterMessageEnd()
    self:dispatchEvent(M.EVENT_MESSAGE_END)

    if self._messageHideEnabled then
        self:hide()
    end
end

return M