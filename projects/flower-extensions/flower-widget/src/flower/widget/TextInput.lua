----------------------------------------------------------------------------------------------------
-- This class is a line of text can be entered.
-- Does not correspond to a multi-line input.
--
-- TODO: TextInput does not support multi-byte.
-- TODO: TextInput can not move the cursor.
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
local KeyCode = require "flower.KeyCode"
local Executors = require "flower.Executors"
local InputMgr = require "flower.InputMgr"
local Label = require "flower.Label"
local DrawableRect = require "flower.DrawableRect"
local UIEvent = require "flower.widget.UIEvent"
local TextBox = require "flower.widget.TextBox"
local MOAIKeyboard = MOAIKeyboardAndroid or MOAIKeyboardIOS

-- class
local TextInput = class(TextBox)

--- Style: focusTexture
TextInput.STYLE_FOCUS_TEXTURE = "focusTexture"

--- Style: maxLength
TextInput.STYLE_MAX_LENGTH = "maxLength"

---
-- Initialize a variables
function TextInput:_initInternal()
    TextInput.__super._initInternal(self)
    self._themeName = "TextInput"
    self._onKeyboardInput = function(start, length, text)
        self:onKeyboardInput(start, length, text)
    end
    self._onKeyboardReturn = function()
        self:onKeyboardReturn()
    end
end

---
-- Initialize the event listeners.
function TextInput:_initEventListeners()
    TextInput.__super._initEventListeners(self)
end

---
-- Create the children.
function TextInput:_createChildren()
    TextInput.__super._createChildren(self)

    self._textAllow = DrawableRect(1, self:getTextSize())
    self._textAllow:setColor(0, 0, 0, 1)
    self._textAllow:setVisible(false)
    self:addChild(self._textAllow)
end

---
-- Draw the focus object.
-- @param focus focus
function TextInput:drawFocus(focus)
    TextInput.__super.drawFocus(self, focus)
    self._backgroundImage:setImage(self:getBackgroundTexture())
    self:drawTextAllow()
end

---
-- Draw an arrow in the text.
function TextInput:drawTextAllow()
    if not self:isFocus() then
        self._textAllow:setVisible(false)
        return
    end

    local textLabel = self._textLabel
    local tLen = #self._text
    local txMin, tyMin, txMax, tyMax = textLabel:getStringBounds(1, tLen)
    local tLeft, tTop = textLabel:getPos()
    local tWidth, tHeight = textLabel:getSize()
    local textSize = self:getTextSize()
    txMin, tyMin, txMax, tyMax = txMin or 0, tyMin or 0, txMax or 0, tyMax or 0

    local textAllow = self._textAllow
    local allowLeft, allowTop = txMax + tLeft, (tHeight - textSize) / 2 + tTop
    textAllow:setSize(1, self:getTextSize())
    textAllow:setPos(allowLeft, allowTop)
    textAllow:setVisible(self:isFocus())
end

---
-- Returns the background texture path.
-- @return background texture path
function TextInput:getBackgroundTexture()
    if self:isFocus() then
        return self:getStyle(TextInput.STYLE_FOCUS_TEXTURE)
    end
    return TextInput.__super.getBackgroundTexture(self)
end

---
-- Returns the input max length.
-- @return max length
function TextInput:getMaxLength()
    return self:getStyle(TextInput.STYLE_MAX_LENGTH) or 0
end

---
-- Set the input max length.
-- @param maxLength max length.
function TextInput:setMaxLength(maxLength)
    self:setStyle(TextInput.STYLE_MAX_LENGTH, maxLength)
end

---
-- This event handler is called when focus in.
-- @param e event
function TextInput:onFocusIn(e)
    TextInput.__super.onFocusIn(self, e)

    if MOAIKeyboard then
        MOAIKeyboard.setListener(MOAIKeyboard.EVENT_INPUT, self._onKeyboardInput)
        MOAIKeyboard.setListener(MOAIKeyboard.EVENT_RETURN, self._onKeyboardReturn)
        if MOAIKeyboard.setText then
            MOAIKeyboard.setText(self:getText())
        end
        if MOAIKeyboard.setMaxLength then
            MOAIKeyboard.setMaxLength(self:getMaxLength())
        end
        MOAIKeyboard.showKeyboard(self:getText())
    else
        InputMgr:addEventListener(UIEvent.KEY_DOWN, self.onKeyDown, self)
        InputMgr:addEventListener(UIEvent.KEY_UP, self.onKeyUp, self)
    end
end

---
-- This event handler is called when focus in.
-- @param e event
function TextInput:onFocusOut(e)
    TextInput.__super.onFocusOut(self, e)

    if MOAIKeyboard then
        MOAIKeyboard.setListener(MOAIKeyboard.EVENT_INPUT, nil)
        MOAIKeyboard.setListener(MOAIKeyboard.EVENT_RETURN, nil)
        if MOAIKeyboard.hideKeyboard then
            MOAIKeyboard.hideKeyboard()
        end
    else
        InputMgr:removeEventListener(UIEvent.KEY_DOWN, self.onKeyDown, self)
        InputMgr:removeEventListener(UIEvent.KEY_UP, self.onKeyUp, self)
    end
end

---
-- This event handler is called when focus in.
-- @param e event
function TextInput:onKeyDown(e)
    local key = e.key

    if key == KeyCode.KEY_DELETE or key == KeyCode.KEY_BACKSPACE then
        local text = self:getText()
        text = #text > 0 and text:sub(1, #text - 1) or text
        self:setText(text)
    elseif key == KeyCode.KEY_ENTER then
    -- TODO: LF
    else
        if self:getMaxLength() == 0 or self:getTextLength() < self:getMaxLength() then
            self:addText(string.char(key))
        end
    end

    self:drawTextAllow()
end

---
-- This event handler is called when key up.
-- @param e event
function TextInput:onKeyUp(e)
end

---
-- This event handler is called when keyboard input.
-- @param start start
-- @param length length
-- @param text text
function TextInput:onKeyboardInput(start, length, text)
    -- There is the input for the UITextField is not reflected.
    Executors.callLaterFrame(1, function()
        self:setText(MOAIKeyboard.getText())
        self:drawTextAllow()
    end)
end

---
-- This event handler is called when keyboard input.
function TextInput:onKeyboardReturn()
    self:setText(MOAIKeyboard.getText())
    self:setFocus(false)
end

return TextInput