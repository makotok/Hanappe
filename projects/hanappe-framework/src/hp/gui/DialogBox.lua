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
M.EVENT_MESSAGE_RESULT  = "messageResult"

-- Types
M.TYPE_INFO             = "Info"
M.TYPE_CONFIRM          = "Confirm"
M.TYPE_WARNING          = "Warning"
M.TYPE_ERROR            = "Error"

--------------------------------------------------------------------------------
-- Initializes the internal variables.
--------------------------------------------------------------------------------
function M:initInternal()
    super.initInternal(self)
    
    self._themeName = "DialogBox"
    self._messageHideEnabled = false
    self._spoolingEnabled = false
    self._existingButtons = {}
    self._title = "Message title"
    self._text = "Message text"
    self._type = M.TYPE_INFO
    
    self._popInAnimation = Animation():parallel(
        Animation(self, 0.25):setScl(0.8, 0.8, 1):seekScl(1, 1, 1),
        Animation(self, 0.25):setColor(0, 0, 0, 0):seekColor(1, 1, 1, 1)
    )
    self._popOutAnimation = Animation():parallel(
        Animation(self, 0.25):seekScl(0.8, 0.8, 1),
        Animation(self, 0.25):seekColor(0, 0, 0, 0)
    )
end

--------------------------------------------------------------------------------
-- Create a child objects.
--------------------------------------------------------------------------------
function M:createChildren()
    super.createChildren(self)
    
    self._titleLabel = TextLabel(self._title)
    self:addChild(self._titleLabel)

    self._typeIcon = Sprite(self:getStyle("icon" .. self._type))
    self:addChild(self._typeIcon)
    
    self._textLabel = TextLabel(self._text)
    self._textLabel:setWordBreak(MOAITextBox.WORD_BREAK_CHAR)
    self:addChild(self._textLabel)
    
    self:setColor(0, 0, 0, 0)
end

--------------------------------------------------------------------------------
-- Update the display.
--------------------------------------------------------------------------------
function M:updateDisplay()
    super.updateDisplay(self)
    
    -- create requested buttons
    for _,v in ipairs(self._existingButtons) do
        self:removeChild(v)
        v:dispose()
    end
    self._existingButtons = {}
    if not self._buttons then
        self._buttons = {"OK"}
    end
    for i,v in ipairs(self._buttons) do
        local btn = Button {
            parent=self,
            text=v,
            onClick = function()
                self:hide()
                local e = Event(M.EVENT_MESSAGE_RESULT)
                e.result = v
                e.resultIndex = i
                self:dispatchEvent(e)
            end,
        }
        table.insert(self._existingButtons, btn)
    end
    
    -- calculate buttons width
    local bLeft, bTop, bRight, bBottom = unpack(self:getStyle("buttonsPadding"))
    local bw = 0
    local bh = 0
    for _,v in ipairs(self._existingButtons) do
        bw = bw + v:getWidth() + bLeft + bRight
        bh = v:getHeight() > bh and v:getHeight() or bh
    end
    -- adjust button size if total exceeds size of dialog
    local allowedButtonsWidth = self:getWidth() - bLeft - bRight
    if bw >= allowedButtonsWidth then
        bw = allowedButtonsWidth
        local bwidth = (bw / #self._existingButtons) - bLeft - bRight
        for _,v in ipairs(self._existingButtons) do
            v:setSize(bwidth, bh)
        end
    end
    
    local tLeft, tTop, tRight, tBottom = unpack(self:getStyle("titlePadding"))
    self._titleLabel:fitSize()
    self._titleLabel:setSize(self:getWidth() - tLeft - tRight, self._titleLabel:getHeight())
    self._titleLabel:setPos(tLeft, tTop)
    self._titleLabel:setAlign("center", "center")
    self._titleLabel:setColor(unpack(self:getStyle("titleColor")))
    self._titleLabel:setTextSize(self:getStyle("titleSize"))
    self._titleLabel:setFont(self:getStyle("titleFont"))
    
    local yoff = tTop + self._titleLabel:getHeight() + tBottom

    local iLeft, iTop, iRight, iBottom = unpack(self:getStyle("iconPadding"))
    self._typeIcon:setTexture(self:getStyle("icon" .. (self._type or M.ICON_INFO)))
    local iw, ih = self._typeIcon:getSize()
    local iconScaleFactor = self:getStyle("iconScaleFactor") or 1
    if iconScaleFactor ~= 1 then
        iw = iw * iconScaleFactor
        ih = ih * iconScaleFactor
        self._typeIcon:setSize(iw, ih)
    end
    self._typeIcon:setPos(iLeft, yoff + iTop)

    local pLeft, pTop, pRight, pBottom = unpack(self:getStyle("textPadding"))
    local tWidth = self:getWidth() - iLeft - iw - iRight - pLeft - pRight
    local tHeight = self:getHeight() - yoff - pTop - pBottom - bh - bTop - bBottom
    self._textLabel:setSize(tWidth, tHeight)
    self._textLabel:setPos(iLeft + iw + iRight + pLeft, yoff + pTop)
    self._textLabel:setAlign("left", "top")
    self._textLabel:setColor(unpack(self:getStyle("textColor")))
    self._textLabel:setTextSize(self:getStyle("textSize"))
    self._textLabel:setFont(self:getStyle("font"))
    
    yoff = yoff + pTop + tHeight + pBottom
    
    local xoff = (self:getWidth() - bw) * 0.5
    for _,v in ipairs(self._existingButtons) do
        v:setPos(xoff + bLeft, yoff + bTop)
        xoff = xoff + bLeft + bRight + v:getWidth()
    end
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
    self:setTitle(self:getTitle())
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
-- Sets the type.
-- @param type type
--------------------------------------------------------------------------------
function M:setType(typ)
    self._type = typ
end

--------------------------------------------------------------------------------
-- Sets the type
-- @return type
--------------------------------------------------------------------------------
function M:getType()
    return self._type
end

--------------------------------------------------------------------------------
-- Sets the type.
-- @param type type
--------------------------------------------------------------------------------
function M:setButtons(...)
    self._buttons = {...}
end

--------------------------------------------------------------------------------
-- Sets the type
-- @return type
--------------------------------------------------------------------------------
function M:getButtons()
    return self._buttons
end

--------------------------------------------------------------------------------
-- Sets the title.
-- @param title title
--------------------------------------------------------------------------------
function M:setTitle(title)
    self._title = title
    self._titleLabel:setText(title)
end

--------------------------------------------------------------------------------
-- Sets the title
-- @return title
--------------------------------------------------------------------------------
function M:getTitle()
    return self._title
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

--------------------------------------------------------------------------------
-- Set the event listener was called to end a message box.
-- @param func event listener
--------------------------------------------------------------------------------
function M:setOnMessageResult(func)
    self:setEventListener(M.EVENT_MESSAGE_RESULT, func)
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