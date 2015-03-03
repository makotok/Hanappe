----------------------------------------------------------------------------------------------------
-- This is the class that displays a message in the panel.
--
-- @author Makoto
-- @release V3.0.0
----------------------------------------------------------------------------------------------------

-- import
local table = require "flower.table"
local class = require "flower.class"
local Image = require "flower.Image"
local NineImage = require "flower.NineImage"
local Label = require "flower.Label"
local Animation = require "flower.Animation"
local Event = require "flower.Event"
local DrawableRect = require "flower.DrawableRect"
local UIComponent = require "flower.widget.UIComponent"
local UIView = require "flower.widget.UIView"
local BoxLayout = require "flower.widget.BoxLayout"
local Button = require "flower.widget.Button"
local Panel = require "flower.widget.Panel"
local TextAlign = require "flower.widget.TextAlign"

-- class
local DialogBox = class(Panel)

--- Style: fontName
DialogBox.STYLE_FONT_NAME = "fontName"

--- Style : textColor
DialogBox.STYLE_TEXT_COLOR = "textColor"

--- Style : textSize
DialogBox.STYLE_TEXT_SIZE = "textSize"

--- Style : buttonsPadding
DialogBox.STYLE_BUTTONS_PADDING = "buttonsPadding"

--- Style : titlePadding
DialogBox.STYLE_TITLE_PADDING = "titlePadding"

--- Style : titleColor
DialogBox.STYLE_TITLE_COLOR = "titleColor"

--- Style : titleSize
DialogBox.STYLE_TITLE_SIZE = "titleSize"

--- Style : titleFontName
DialogBox.STYLE_TITLE_FONT_NAME = "titleFontName"

--- Style : iconPadding
DialogBox.STYLE_ICON_PADDING = "iconPadding"

--- Style : iconScaleFactor
DialogBox.STYLE_ICON_SCALE_FACTOR = "iconScaleFactor"

--- Event: show
DialogBox.EVENT_SHOW = "show"

--- Event: hide
DialogBox.EVENT_HIDE = "hide"

--- Event: result
DialogBox.EVENT_RESULT = "result"

--- Type : Info
DialogBox.TYPE_INFO = "Info"

--- Type : Confirm
DialogBox.TYPE_CONFIRM = "Confirm"

--- Type : Warning
DialogBox.TYPE_WARNING = "Warning"

--- Type : Error
DialogBox.TYPE_ERROR = "Error"

---
-- Initializes the internal variables.
function DialogBox:_initInternal()
    DialogBox.__super._initInternal(self)
    
    self._themeName = "DialogBox"
    self._messageHideEnabled = false
    self._spoolingEnabled = false
    self._existingButtons = {}
    self._title = "title"
    self._text = "text"
    self._type = DialogBox.TYPE_INFO
end

---
-- Create a child objects.
function DialogBox:_createChildren()
    DialogBox.__super._createChildren(self)
    
    self._titleLabel = Label(self._title)
    self:addChild(self._titleLabel)

    self._typeIcon = Image(self:getStyle("icon" .. self._type))
    self:addChild(self._typeIcon)
    
    self._textLabel = Label(self._text)
    self._textLabel:setWordBreak(MOAITextBox.WORD_BREAK_CHAR)
    self:addChild(self._textLabel)

    self._dialogView = UIView {
        layout = BoxLayout {
            align = {"center", "center"},
        }
    }

    self._backgroundRect = DrawableRect(self._dialogView:getSize())
    self._backgroundRect._excludeLayout = true
    self._backgroundRect:setColor(0, 0, 0, 0)

    self._dialogView:addChild(self._backgroundRect)
    self._dialogView:addChild(self)

    self:setColor(0, 0, 0, 0)
    self:setSize(self._dialogView:getWidth() * 0.95, 180)

    self:_createAnimations()
end

---
-- Create a animation objects.
function DialogBox:_createAnimations()
    self._popInAnimation = Animation():parallel(
        Animation(self, 0.25):setScl(0.8, 0.8, 1):seekScl(1, 1, 1),
        Animation(self, 0.25):setColor(0, 0, 0, 0):seekColor(1, 1, 1, 1),
        Animation(self._backgroundRect, 0.5):setColor(0, 0, 0, 0):seekColor(0, 0, 0, 0.5)
    )
    self._popOutAnimation = Animation():parallel(
        Animation(self, 0.25):seekScl(0.8, 0.8, 1),
        Animation(self, 0.25):seekColor(0, 0, 0, 0),
        Animation(self._backgroundRect, 0.5):seekColor(0, 0, 0, 0)
    )
end

---
-- Update the display.
function DialogBox:updateDisplay()
    DialogBox.__super.updateDisplay(self)
    
    -- create requested buttons
    for _, button in ipairs(self._existingButtons) do
        self:removeChild(v)
        button:dispose()
    end
    self._existingButtons = {}
    if not self._buttons then
        self._buttons = {"OK"}
    end
    for i,text in ipairs(self._buttons) do
        local btn = Button {
            parent = self,
            size = {100, 50},
            text = text,
            onClick = function()
                self:hide()
                local e = Event(DialogBox.EVENT_RESULT)
                e.result = text
                e.resultIndex = i
                self:dispatchEvent(e)
            end,
        }
        table.insert(self._existingButtons, btn)
    end
    
    -- calculate buttons width
    local bLeft, bTop, bRight, bBottom = unpack(self:getStyle(DialogBox.STYLE_BUTTONS_PADDING))
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
    
    local tLeft, tTop, tRight, tBottom = unpack(self:getStyle(DialogBox.STYLE_TITLE_PADDING))
    self._titleLabel:fitSize()
    self._titleLabel:setSize(self:getWidth() - tLeft - tRight, self._titleLabel:getHeight())
    self._titleLabel:setPos(tLeft, tTop)
    self._titleLabel:setAlignment(TextAlign.center, TextAlign.center)
    self._titleLabel:setColor(unpack(self:getStyle(DialogBox.STYLE_TITLE_COLOR)))
    self._titleLabel:setTextSize(self:getStyle(DialogBox.STYLE_TITLE_SIZE))
    self._titleLabel:setFont(self:getStyle(DialogBox.STYLE_TITLE_FONT_NAME))
    
    local yoff = tTop + self._titleLabel:getHeight() + tBottom

    local iLeft, iTop, iRight, iBottom = unpack(self:getStyle(DialogBox.STYLE_ICON_PADDING))
    self._typeIcon:setTexture(self:getStyle("icon" .. (self._type or DialogBox.ICON_INFO)))
    local iw, ih = self._typeIcon:getSize()
    local iconScaleFactor = self:getStyle(DialogBox.STYLE_ICON_SCALE_FACTOR) or 1
    if iconScaleFactor ~= 1 then
        iw = iw * iconScaleFactor
        ih = ih * iconScaleFactor
        self._typeIcon:setSize(iw, ih)
    end
    self._typeIcon:setPos(iLeft, yoff + iTop)

    local pLeft, pTop, pRight, pBottom = unpack(self:getStyle(DialogBox.STYLE_TITLE_PADDING))
    local tWidth = self:getWidth() - iLeft - iw - iRight - pLeft - pRight
    local tHeight = self:getHeight() - yoff - pTop - pBottom - bh - bTop - bBottom
    self._textLabel:setSize(tWidth, tHeight)
    self._textLabel:setPos(iLeft + iw + iRight + pLeft, yoff + pTop)
    self._textLabel:setAlignment(TextAlign.left, TextAlign.top)
    self._textLabel:setColor(unpack(self:getStyle(DialogBox.STYLE_TEXT_COLOR)))
    self._textLabel:setTextSize(self:getStyle(DialogBox.STYLE_TEXT_SIZE))
    self._textLabel:setFont(self:getStyle(DialogBox.STYLE_FONT_NAME))
    
    yoff = yoff + pTop + tHeight + pBottom
    
    local xoff = (self:getWidth() - bw) * 0.5
    for _, button in ipairs(self._existingButtons) do
        button:setPos(xoff + bLeft, yoff + bTop)
        xoff = xoff + bLeft + bRight + button:getWidth()
    end
end

---
-- Turns spooling ON or OFF.
-- If self is currently spooling and enable is false, stop spooling and reveal 
-- entire page. 
-- @param enable Boolean for new state
-- @return none
function DialogBox:spoolingEnabled(enable)
    self._spoolingEnabled = enable and true or false
    if self._spoolingEnabled == false and self:isBusy() then
        self._textLabel:stop()
        self._textLabel:revealAll()
    end
end

---
-- Displays a message box in the pop-up effect.
function DialogBox:show(scene)
    self._dialogView:setScene(scene)
    self:setVisible(true)
    self:setPivToCenter()
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
            self:dispatchEvent(DialogBox.EVENT_SHOW)
        end
    }
end

---
-- To hide the message box in the pop-up effect.
function DialogBox:hide()
    if self._popInAnimation:isRunning() then
        return
    end
    
    self._popOutAnimation:play {onComplete = 
        function()
            self._dialogView:setScene(nil)
            self:setVisible(false)
            self:dispatchEvent(DialogBox.EVENT_HIDE)
        end
    }
end

---
-- Spools the text.
function DialogBox:spool()
    self:spoolingEnabled(true)
    return self._textLabel:spool()
end

---
-- Displays the next page.
function DialogBox:nextPage()
    return self._textLabel:nextPage()
end

---
-- Returns the next page if exists.
-- @return If the next page there is a true
function DialogBox:more()
    return self._textLabel:more()
end

---
-- Returns in the process whether messages are displayed.
-- @return busy
function DialogBox:isBusy()
    return self._textLabel:isBusy()
end

---
-- Set the type.
-- @param type type
function DialogBox:setType(typ)
    self._type = typ
end

---
-- Return the type
-- @return type
function DialogBox:getType()
    return self._type
end

---
-- Sets the Buttons.
-- @param ... button
function DialogBox:setButtons(...)
    self._buttons = {...}
end

---
-- Set the type
-- @return type
function DialogBox:getButtons()
    return self._buttons
end

---
-- Set the title.
-- @param title title
function DialogBox:setTitle(title)
    self._title = title
    self._titleLabel:setString(title)
end

---
-- Return the title
-- @return title
function DialogBox:getTitle()
    return self._title
end

---
-- Set the text.
-- @param text text
function DialogBox:setText(text)
    self._text = text
    self._textLabel:setString(text)
end

---
-- Return the text.
-- @return text
function DialogBox:getText()
    return self._text
end

---
-- Sets the color of the text.
-- @param r red
-- @param g green
-- @param b blue
-- @param a alpha
function DialogBox:setTextColor(r, g, b, a)
    self:setStyle(DialogBox.STYLE_TEXT_COLOR, {r or 1, g or 1, b or 1, a or 1})
    self:invalidateDisplay()
end

---
-- Set the size of the text.
-- @param points points
function DialogBox:setTextSize(points)
    self:setStyle(DialogBox.STYLE_TEXT_SIZE, points)
    self:invalidateDisplay()
end

---
-- Set the event listener was called to display a message box.
-- @param func event listener
function DialogBox:setOnShow(func)
    self:setEventListener(DialogBox.EVENT_SHOW, func)
end

---
-- Set the event listener was called to hide a message box.
-- @param func event listener
function DialogBox:setOnHide(func)
    self:setEventListener(DialogBox.EVENT_HIDE, func)
end

---
-- Set the event listener was called to end a message box.
-- @param func event listener
function DialogBox:setOnResult(func)
    self:setEventListener(DialogBox.EVENT_RESULT, func)
end

return DialogBox