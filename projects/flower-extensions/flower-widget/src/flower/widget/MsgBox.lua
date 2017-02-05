----------------------------------------------------------------------------------------------------
-- It is a class that displays the message.
-- Displays the next page of the message when selected.
--
-- <h4>Extends:</h4>
-- <ul>
--   <li><a href="flower.widget.TextBox.html">TextBox</a><l/i>
-- </ul>
--
-- @author Makoto
-- @release V3.0.0
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.class"
local table = require "flower.table"
local Executors = require "flower.Executors"
local UIEvent = require "flower.widget.UIEvent"
local TextBox = require "flower.widget.TextBox"

-- class
local MsgBox = class(TextBox)

--- Style: animShowFunction
MsgBox.STYLE_ANIM_SHOW_FUNCTION = "animShowFunction"

--- Style: animHideFunction
MsgBox.STYLE_ANIM_HIDE_FUNCTION = "animHideFunction"

--- Default: Show Animation function
MsgBox.ANIM_SHOW_FUNCTION = function(self)
    self:setColor(0, 0, 0, 0)
    self:setScl(0.8, 0.8, 1)

    local action1 = self:seekColor(1, 1, 1, 1, 0.5)
    local action2 = self:seekScl(1, 1, 1, 0.5)
    MOAICoroutine.blockOnAction(action1)
end

--- Default: Hide Animation function
MsgBox.ANIM_HIDE_FUNCTION = function(self)
    local action1 = self:seekColor(0, 0, 0, 0, 0.5)
    local action2 = self:seekScl(0.8, 0.8, 1, 0.5)
    MOAICoroutine.blockOnAction(action1)
end

---
-- Initialize a internal variables.
function MsgBox:_initInternal()
    MsgBox.__super._initInternal(self)
    self._themeName = "MsgBox"
    self._popupShowing = false
    self._spoolingEnabled = true

    -- TODO: inherit visibility
    self:setColor(0, 0, 0, 0)
end

---
-- Initialize the event listeners.
function MsgBox:_initEventListeners()
    MsgBox.__super._initEventListeners(self)
    self:addEventListener(UIEvent.TOUCH_DOWN, self.onTouchDown, self)
end

---
-- Show MsgBox.
function MsgBox:showPopup()
    if self:isPopupShowing() then
        return
    end
    self._popupShowing = true

    -- text label setting
    self:setText(self._text)
    self:validate()
    if self._spoolingEnabled then
        self._textLabel:setReveal(0)
    else
        self._textLabel:revealAll()
    end

    -- show animation
    Executors.callOnce(function()
        local showFunc = self:getStyle(MsgBox.STYLE_ANIM_SHOW_FUNCTION)
        showFunc(self)

        if self._spoolingEnabled then
            self._textLabel:spool()
        end

        self:dispatchEvent(UIEvent.MSG_SHOW)
    end)
end

---
-- Hide MsgBox.
function MsgBox:hidePopup()
    if not self:isPopupShowing() then
        return
    end
    self._textLabel:stop()

    Executors.callOnce(function()
        local hideFunc = self:getStyle(MsgBox.STYLE_ANIM_HIDE_FUNCTION)
        hideFunc(self)

        self:dispatchEvent(UIEvent.MSG_HIDE)
        self._popupShowing = false
    end)
end

---
-- Displays the next page.
function MsgBox:nextPage()
    self._textLabel:nextPage()
    if self._spoolingEnabled then
        self._textLabel:spool()
    end
end

---
-- Return true if showing.
-- @return true if showing
function MsgBox:isPopupShowing()
    return self._popupShowing
end

---
-- Return true if textLabel is busy.
function MsgBox:isSpooling()
    return self._textLabel:isBusy()
end

---
-- Returns true if there is a next page.
-- @return True if there is a next page
function MsgBox:hasNextPase()
    return self._textLabel:more()
end

---
-- Turns spooling ON or OFF.
-- If self is currently spooling and enable is false, stop spooling and reveal
-- entire page.
-- @param enabled Boolean for new state
function MsgBox:setSpoolingEnabled(enabled)
    self._spoolingEnabled = enabled
    if not self._spoolingEnabled and self:isSpooling() then
        self._textLabel:stop()
        self._textLabel:revealAll()
    end
end

---
-- Set the event listener that is called when show popup.
-- @param func msgHide event handler
function MsgBox:setOnMsgShow(func)
    self:setEventListener(UIEvent.MSG_SHOW, func)
end

---
-- Set the event listener that is called when hide popup.
-- @param func msgHide event handler
function MsgBox:setOnMsgHide(func)
    self:setEventListener(UIEvent.MSG_HIDE, func)
end

---
-- This event handler is called when you touch the component.
-- @param e touch event
function MsgBox:onTouchDown(e)
    if self:isSpooling() then
        self._textLabel:stop()
        self._textLabel:revealAll()
    elseif self:hasNextPase() then
        self:nextPage()
    else
        self:dispatchEvent(UIEvent.MSG_END)
        self:hidePopup()
    end
end

return MsgBox