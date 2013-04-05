----------------------------------------------------------------------------------------------------
-- GUI Library.
-- 
-- @author Makoto
----------------------------------------------------------------------------------------------------

-- module
local M = {}

-- import
local flower = require "flower"
local class = flower.class
local table = flower.table
local Executors = flower.Executors
local Resources = flower.Resources
local PropertyUtils = flower.PropertyUtils
local InputMgr = flower.InputMgr
local ClassFactory = flower.ClassFactory
local Event = flower.Event
local DisplayObject = flower.DisplayObject
local Layer = flower.Layer
local Group = flower.Group
local Image = flower.Image
local NineImage = flower.NineImage
local MovieClip = flower.MovieClip
local Label = flower.Label
local Rect = flower.Rect
local TouchHandler = flower.TouchHandler
local MOAIKeyboard = MOAIKeyboardAndroid or MOAIKeyboardIOS

-- classes
local ThemeMgr
local FocusMgr
local TextAlign
local KeyCode
local UIEvent
local UIComponent
local UIGroup
local UILayer
local UITouchHandler
local UIView
local TextSupport
local Button
local Joystick
local Panel
local TextBox
local TextInput
local MsgBox
local ListBox
local ListItem
local PictureBox
local TileList
local BaseLayout
local BoxLayout
local TileLayout

-- interfaces
local MOAIPropInterface = MOAIProp.getInterfaceTable()

----------------------------------------------------------------------------------------------------
-- Local functions
----------------------------------------------------------------------------------------------------

local function buildTheme()
    return {
        Button = {
            normalTexture = "skins/button_normal.9.png",
            selectedTexture = "skins/button_selected.9.png",
            disabledTexture = "skins/button_normal.9.png",
            fontName = "VL-PGothic.ttf",
            textSize = 20,
            textColor = {0, 0, 0, 1},
            textDisabledColor = {0.5, 0.5, 0.5, 1},
            textAlign = {"center", "center"},
        },
        Joystick = {
            baseTexture = "skins/joystick_base.png",
            knobTexture = "skins/joystick_knob.png",
        },
        Panel = {
            backgroundTexture = "skins/panel.9.png",
        },
        TextBox = {
            backgroundTexture = "skins/panel.9.png",
            fontName = "VL-PGothic.ttf",
            textSize = 18,
            textColor = {1, 1, 1, 1},
            textAlign = {"left", "top"},
        },
        TextInput = {
            backgroundTexture = "skins/textinput_normal.9.png",
            focusTexture = "skins/textinput_focus.9.png",
            fontName = "VL-PGothic.ttf",
            textSize = 20,
            textColor = {0, 0, 0, 1},
            textAlign = {"left", "center"},
        },
        MsgBox = {
            backgroundTexture = "skins/panel.9.png",
            pauseTexture = "skins/msgbox_pause.png",
            fontName = "VL-PGothic.ttf",
            textSize = 18,
            textColor = {1, 1, 1, 1},
            textAlign = {"left", "top"},
            animShowFunction = MsgBox.ANIM_SHOW_FUNCTION,
            animHideFunction = MsgBox.ANIM_HIDE_FUNCTION,
        },
        ListBox = {
            backgroundTexture = "skins/panel.9.png",
            listItemFactory = ClassFactory(ListItem),
        },
        ListItem = {
            
        },
        PictureBox = {
            backgroundTexture = "skins/panel.9.png",
        },
    }
end

----------------------------------------------------------------------------------------------------
-- Public functions
----------------------------------------------------------------------------------------------------

function M.initialize()
    if M.initialized then
        return
    end

    M.themeMgr = ThemeMgr()
    M.focusMgr = FocusMgr()
    
    M.initialized = true
end

function M.setTheme(theme)
    M.themeMgr:setTheme(theme)
end

function M.getTheme()
    return M.themeMgr:getTheme()
end

function M.getThemeMgr()
    return M.themeMgr
end

function M.getFocusMgr()
    return M.focusMgr
end


----------------------------------------------------------------------------------------------------
-- @type ThemeMgr
----------------------------------------------------------------------------------------------------
ThemeMgr = class()
M.ThemeMgr = ThemeMgr

function ThemeMgr:init()
    self.theme = buildTheme()
end

function ThemeMgr:setTheme(theme)
    if self.theme ~= theme then
        self.theme = theme
        self:dispatchEvent(UIEvent.THEME_CHANGED)
    end
end

function ThemeMgr:getTheme()
    return self.theme
end

----------------------------------------------------------------------------------------------------
-- @type FocusMgr
----------------------------------------------------------------------------------------------------
FocusMgr = class()
M.FocusMgr = FocusMgr

function FocusMgr:init()
    self.focusObject = nil
end

function FocusMgr:setFocusObject(object)
    if self.focusObject == object then
        return
    end
    
    local oldFocusObject = self.focusObject
    self.focusObject = object
    
    if oldFocusObject then
        oldFocusObject:dispatchEvent(UIEvent.FOCUS_OUT)
    end
    if self.focusObject then
        self.focusObject:dispatchEvent(UIEvent.FOCUS_IN)
    end
end

function FocusMgr:getFocusObject()
    return self.focusObject
end

----------------------------------------------------------------------------------------------------
-- @type TextAlign
----------------------------------------------------------------------------------------------------
TextAlign = {}
M.TextAlign = TextAlign

--- left: MOAITextBox.LEFT_JUSTIFY
TextAlign["left"] = MOAITextBox.LEFT_JUSTIFY

--- center: MOAITextBox.CENTER_JUSTIFY
TextAlign["center"] = MOAITextBox.CENTER_JUSTIFY

--- right: MOAITextBox.RIGHT_JUSTIFY
TextAlign["right"] = MOAITextBox.RIGHT_JUSTIFY

--- top: MOAITextBox.LEFT_JUSTIFY
TextAlign["top"] = MOAITextBox.LEFT_JUSTIFY

--- bottom: MOAITextBox.RIGHT_JUSTIFY
TextAlign["bottom"] = MOAITextBox.RIGHT_JUSTIFY

----------------------------------------------------------------------------------------------------
-- @type KeyCode
----------------------------------------------------------------------------------------------------
KeyCode = {}
M.KeyCode = KeyCode

KeyCode.DEL = 127 -- TODO:Code
KeyCode.BACKSPACE = 127
KeyCode.SPACE = 32
KeyCode.ENTER = 13
KeyCode.TAB = 9


----------------------------------------------------------------------------------------------------
-- @type UIEvent
----------------------------------------------------------------------------------------------------
UIEvent = class(Event)
M.UIEvent = UIEvent

--- UIComponent: Resize Event
UIEvent.RESIZE = "resize"

--- UIComponent: Theme changed Event
UIEvent.THEME_CHANGED = "themeChanged"

--- UIComponent: Style changed Event
UIEvent.STYLE_CHANGED = "styleChanged"

--- UIComponent: Enabled changed Event
UIEvent.ENABLED_CHANGED = "enabledChanged"

--- UIComponent: FocusIn Event
UIEvent.FOCUS_IN = "focusIn"

--- UIComponent: FocusOut Event
UIEvent.FOCUS_OUT = "focusOut"

--- Button: Click Event
UIEvent.CLICK = "click"

--- Button: down Event
UIEvent.DOWN = "down"

--- Button: up Event
UIEvent.UP = "up"

--- Button: up Event
UIEvent.UP = "up"

--- Joystick: Event type when you change the position of the stick
UIEvent.STICK_CHANGED   = "stickChanged"

--- MsgBox: msgShow Event
UIEvent.MSG_SHOW = "msgShow"

--- MsgBox: msgHide Event
UIEvent.MSG_HIDE = "msgHide"

--- MsgBox: msgEnd Event
UIEvent.MSG_END = "msgEnd"

--- MsgBox: spoolStop Event
UIEvent.SPOOL_STOP = "spoolStop"

----------------------------------------------------------------------------------------------------
-- @type UIComponent
-- This class is an image that can be pressed.
-- It is a simple button.
----------------------------------------------------------------------------------------------------
UIComponent = class(Group)
M.UIComponent = UIComponent

--------------------------------------------------------------------------------
-- Constructor.
-- Please do not inherit this constructor.
-- Please have some template functions are inherited.
-- @param params Parameter table
--------------------------------------------------------------------------------
function UIComponent:init(params)
    Group.init(self)
    self:_initInternal()
    self:_initEventListeners()
    self:_createChildren()
    
    self:setProperties(params)
    self:updateDisplay()
    self:setPivToCenter()
end

--------------------------------------------------------------------------------
-- Initialization is the process of internal variables.
-- Please to inherit this function if the definition of the variable.
--------------------------------------------------------------------------------
function UIComponent:_initInternal()
    self.isUIComponent = true
    
    self._enabled = true
    self._focusEnabled = true
    self._theme = nil
    self._styles = {}
    self._excludeLayout = false
end

--------------------------------------------------------------------------------
-- Performing the initialization processing of the event listener.
-- Please to inherit this function if you want to initialize the event listener.
--------------------------------------------------------------------------------
function UIComponent:_initEventListeners()
    self:addEventListener(UIEvent.ENABLED_CHANGED, self.onEnabledChanged, self)
    self:addEventListener(UIEvent.FOCUS_IN, self.onFocusIn, self)
    self:addEventListener(UIEvent.FOCUS_OUT, self.onFocusOut, self)
    self:addEventListener(Event.TOUCH_DOWN, self.onTouchCommon, self, -10)
    self:addEventListener(Event.TOUCH_UP, self.onTouchCommon, self, -10)
    self:addEventListener(Event.TOUCH_MOVE, self.onTouchCommon, self, -10)
    self:addEventListener(Event.TOUCH_CANCEL, self.onTouchCommon, self, -10)
end

--------------------------------------------------------------------------------
-- Performing the initialization processing of the component.
-- Please to inherit this function if you want to change the behavior of the component.
--------------------------------------------------------------------------------
function UIComponent:_createChildren()

end

--------------------------------------------------------------------------------
-- Update the display.
--------------------------------------------------------------------------------
function UIComponent:updateDisplay()

end

--------------------------------------------------------------------------------
-- Draw focus object.
--------------------------------------------------------------------------------
function UIComponent:drawFocus(focus)

end

----------------------------------------------------------------
-- Returns the children object.
-- If you want to use this function with caution.
-- @return children
----------------------------------------------------------------
function UIComponent:getChildren()
    return self.children
end

--------------------------------------------------------------------------------
-- Adds the specified child.
-- @param child DisplayObject
--------------------------------------------------------------------------------
function UIComponent:addChild(child)
    if Group.addChild(self, child) then
        child:setPriority(self:getPriority())
        return true
    end
    return false
end

--------------------------------------------------------------------------------
-- Adds the specified child.
-- @param child DisplayObject
-- @param index insert index
--------------------------------------------------------------------------------
function UIComponent:addChildAt(child, index)
    if Group.addChild(self, child) then
        child:setPriority(self:getPriority())
        return true
    end
    return false
end

--------------------------------------------------------------------------------
-- Returns the nest level.
-- @return nest level
--------------------------------------------------------------------------------
function UIComponent:getNestLevel()
    local parent = self.parent
    if parent and parent.getNestLevel then
        return parent:getNestLevel() + 1
    end
    return 1
end

--------------------------------------------------------------------------------
-- Sets the properties
-- @param properties properties
--------------------------------------------------------------------------------
function UIComponent:setProperties(properties)
    if properties then
        PropertyUtils.setProperties(self, properties, true)
    end
end

--------------------------------------------------------------------------------
-- Sets the size.
-- @param width Width
-- @param height Height
--------------------------------------------------------------------------------
function UIComponent:setSize(width, height)
    width  = width  < 0 and 0 or width
    height = height < 0 and 0 or height

    local oldWidth, oldHeight =  self:getSize()
    
    if oldWidth ~= width or oldHeight ~= height then
        Group.setSize(self, width, height)
        self:dispatchEvent(UIEvent.RESIZE)
    end
end

--------------------------------------------------------------------------------
-- Sets the object's parent, inheriting its color and transform.
-- @param parent parent
--------------------------------------------------------------------------------
function UIComponent:setParent(parent)
    if parent == self.parent then
        return
    end
    
    -- remove
    if self.parent and self.parent.isGroup then
        self.parent:removeChild(self)
    end
    
    -- set
    Group.setParent(self, parent)
    
    -- add
    if parent and parent.isGroup then
        parent:addChild(self)
    end
end

--------------------------------------------------------------------------------
-- Set the enabled state.
-- @param value enabled
--------------------------------------------------------------------------------
function UIComponent:setEnabled(enabled)
    if self._enabled ~= enabled then
        self._enabled = enabled
        self:dispatchEvent(UIEvent.ENABLED_CHANGED)
    end    
end

--------------------------------------------------------------------------------
-- Returns the enabled.
-- @return enabled
--------------------------------------------------------------------------------
function UIComponent:isEnabled()
    return self._enabled
end

--------------------------------------------------------------------------------
-- Returns the parent enabled.
-- @return enabled
--------------------------------------------------------------------------------
function UIComponent:isParentEnabled()
    local parent = self.parent
    if parent and parent.isParentEnabled then
        return parent:isParentEnabled()
    end
    return self._enabled
end

--------------------------------------------------------------------------------
-- Set the focus.
-- @param focus focus
--------------------------------------------------------------------------------
function UIComponent:setFocus(focus)
    if self:isFocus() ~= focus then
        local focusMgr = self:getFocusMgr()
        if focus then
            focusMgr:setFocusObject(self)
        else
            focusMgr:setFocusObject(nil)
        end
    end
end

--------------------------------------------------------------------------------
-- Returns the focus.
-- @return focus
--------------------------------------------------------------------------------
function UIComponent:isFocus()
    local focusMgr = self:getFocusMgr()
    return focusMgr:getFocusObject() == self
end

--------------------------------------------------------------------------------
-- Sets the focus.
-- @param focus
--------------------------------------------------------------------------------
function UIComponent:setFocusEnabled(focusEnabled)
    if self._focusEnabled ~= focusEnabled then
        self._focusEnabled = focusEnabled
        if not self._focusEnabled then
            self:setFocus(false)
        end
    end    
end

--------------------------------------------------------------------------------
-- Returns the focus.
-- @return focus
--------------------------------------------------------------------------------
function UIComponent:isFocusEnabled()
    return self._focusEnabled
end

--------------------------------------------------------------------------------
-- Sets the theme.
-- @param theme theme
--------------------------------------------------------------------------------
function UIComponent:setTheme(theme)
    if self._theme ~= theme then
        self._theme = theme
        self:updateDisplay()
        self:dispatchEvent(UIEvent.THEME_CHANGED)
    end
end

--------------------------------------------------------------------------------
-- Returns the theme.
-- @return theme
--------------------------------------------------------------------------------
function UIComponent:getTheme()
    if self._theme then
        return self._theme
    end
    
    if self._themeName then
        local globalTheme = M.getTheme()
        return globalTheme[self._themeName]
    end
end

--------------------------------------------------------------------------------
-- Sets the style of the component.
-- @param name style name
-- @param value style value
--------------------------------------------------------------------------------
function UIComponent:setStyle(name, value)
    if self._styles[name] ~= value then
        self._styles[name] = value
        self:dispatchEvent(UIEvent.STYLE_CHANGED, {styleName = name, styleValue = value})
    end
end

--------------------------------------------------------------------------------
-- Returns the style.
-- @param name style name
-- @return style value
--------------------------------------------------------------------------------
function UIComponent:getStyle(name)
    if self._styles[name] ~= nil then
        return self._styles[name]
    end
    
    local theme = self:getTheme()
    if theme and theme[name] ~= nil then
        return theme[name]
    end
end

--------------------------------------------------------------------------------
-- Set the layout.
-- When you set the layout, the update process of layout class is called when resizing.
-- The position of the component is automatically updated.
-- @param layout layout object
--------------------------------------------------------------------------------
function UIComponent:setLayout(layout)
    self._layout = layout
end

--------------------------------------------------------------------------------
-- Returns a layout.
-- @return layout object
--------------------------------------------------------------------------------
function UIComponent:getLayout()
    return self._layout
end

--------------------------------------------------------------------------------
-- Set whether you want to update the position by the layout class.
--------------------------------------------------------------------------------
function UIComponent:setExcludeLayout(excludeLayout)
    self._excludeLayout = excludeLayout
end

--------------------------------------------------------------------------------
-- Return whether or not to set the layout automatically.
--------------------------------------------------------------------------------
function UIComponent:isExcludeLayout()
    return self._excludeLayout
end

--------------------------------------------------------------------------------
-- Set the event listener.
-- Event listener that you set in this function is one.
-- @param eventName event name
-- @param func event listener
--------------------------------------------------------------------------------
function UIComponent:setEventListener(eventName, func)
    local propertyName = "_event_" .. eventName

    if self[propertyName] == func then
        return
    end
    
    if self[propertyName] then
        self:removeEventListener(eventName, self[propertyName])
    end

    self[propertyName] = func
    
    if self[propertyName] then
        self:addEventListener(eventName, self[propertyName])
    end
end

--------------------------------------------------------------------------------
-- Returns the focusMgr.
-- @return focusMgr
--------------------------------------------------------------------------------
function UIComponent:getFocusMgr()
    return M.getFocusMgr()
end

--------------------------------------------------------------------------------
-- Returns the focusMgr.
-- @return focusMgr
--------------------------------------------------------------------------------
function UIComponent:getFocusMgr()
    return M.getFocusMgr()
end

--------------------------------------------------------------------------------
-- This event handler is called enabled changed.
-- @param e Touch Event
--------------------------------------------------------------------------------
function UIComponent:onEnabledChanged(e)
end

--------------------------------------------------------------------------------
-- This event handler is called when touch.
-- @param e Touch Event
--------------------------------------------------------------------------------
function UIComponent:onTouchCommon(e)
    if not self:isParentEnabled() then
        e:stop()
    end
    if e.type == Event.TOUCH_DOWN then
        if self:isFocusEnabled() then
            local focusMgr = self:getFocusMgr()
            focusMgr:setFocusObject(self)
        end
    end
end

--------------------------------------------------------------------------------
-- This event handler is called when focus.
-- @param e focus Event
--------------------------------------------------------------------------------
function UIComponent:onFocusIn(e)
    self:drawFocus(true)
end

--------------------------------------------------------------------------------
-- This event handler is called when focus.
-- @param e focus Event
--------------------------------------------------------------------------------
function UIComponent:onFocusOut(e)
    self:drawFocus(false)
end

----------------------------------------------------------------------------------------------------
-- @type UIGroup
-- This class is an image that can be pressed.
-- It is a simple button.
----------------------------------------------------------------------------------------------------
UIGroup = class(UIComponent)
M.UIGroup = UIGroup

--------------------------------------------------------------------------------
-- Initialization is the process of internal variables.
-- Please to inherit this function if the definition of the variable.
--------------------------------------------------------------------------------
function UIGroup:_initInternal()
    UIComponent._initInternal(self)
    self.isUIGroup = true
    self._focusEnabled = false
end

--------------------------------------------------------------------------------
-- Adds the specified child.
-- @param child DisplayObject
--------------------------------------------------------------------------------
function UIGroup:addChild(child)
    if UIComponent.addChild(self, child) then
        child:setPriority(self:getPriority())
        return true
    end
    return false
end

--------------------------------------------------------------------------------
-- Update the display.
--------------------------------------------------------------------------------
function UIGroup:updateDisplay()
    for i, child in ipairs(self:getChildren()) do
        if child.isComponent then
            child:updateDisplay()
        end
    end
end

----------------------------------------------------------------------------------------------------
-- @type UIView
-- This class is an image that can be pressed.
-- It is a simple button.
----------------------------------------------------------------------------------------------------
UIView = class(UIGroup)
M.UIView = UIView

UIView.PRIORITY_MARGIN = 100

--------------------------------------------------------------------------------
-- Initialization is the process of internal variables.
-- Please to inherit this function if the definition of the variable.
--------------------------------------------------------------------------------
function UIView:_initInternal()
    UIGroup._initInternal(self)
    self.isUIView = true
    self._scene = nil
    self._lastPriority = 0
    
    self:_initLayer()
end

function UIView:_initLayer()
    local layer = Layer()
    layer:setSortMode(MOAILayer.SORT_PRIORITY_ASCENDING)
    layer:setTouchEnabled(true)
    layer:addEventListener(Event.TOUCH_DOWN, self.onLayerTouchDown, self, 10)

    self:setLayer(layer)
end

function UIView:_initEventListeners()
    UIGroup._initEventListeners(self)
end

--------------------------------------------------------------------------------
-- Adds the specified child.
-- @param child DisplayObject
--------------------------------------------------------------------------------
function UIView:addChild(child)
    if UIGroup.addChild(self, child) then
        self._lastPriority = self._lastPriority + UIView.PRIORITY_MARGIN
        child:setPriority(self._lastPriority)
        return true
    end
    return false
end

--------------------------------------------------------------------------------
-- Sets the group's priority.
-- Also sets the priority of any children.
-- @param priority priority
--------------------------------------------------------------------------------
function UIView:setPriority(priority)
    priority = priority or 0
    MOAIPropInterface.setPriority(self, priority)
    
    for i, child in ipairs(self.children) do
        priority = priority + UIView.PRIORITY_MARGIN
        child:setPriority(priority)
    end
    
    self._lastPriority = priority
    return priority
end

--------------------------------------------------------------------------------
-- Sets the scene for layer.
-- @param scene scene
--------------------------------------------------------------------------------
function UIView:setScene(scene)
    if self.layer.scene then
        self.layer.scene:removeEventListener(Event.STOP, self.onSceneStop, self, -10)
    end
    
    self.layer:setScene(scene)
    
    if self.layer.scene then
        self.layer.scene:addEventListener(Event.STOP, self.onSceneStop, self, -10)
    end
end

--------------------------------------------------------------------------------
-- This event handler is called when you touch the layer.
-- @param e Touch Event
--------------------------------------------------------------------------------
function UIView:onLayerTouchDown(e)
    local focusMgr = self:getFocusMgr()
    focusMgr:setFocusObject(nil)
end

--------------------------------------------------------------------------------
-- This event handler is called when you stop the scene.
-- @param e Touch Event
--------------------------------------------------------------------------------
function UIView:onSceneStop(e)
    local focusMgr = self:getFocusMgr()
    focusMgr:setFocusObject(nil)
end


----------------------------------------------------------------------------------------------------
-- @type Button
-- This class is an image that can be pressed.
-- It is a simple button.
----------------------------------------------------------------------------------------------------
Button = class(UIComponent)
M.Button = Button

--- Style: selectedTexture
Button.STYLE_NORMAL_TEXTURE = "normalTexture"

--- Style: selectedTexture
Button.STYLE_SELECTED_TEXTURE = "selectedTexture"

--- Style: disabledTexture
Button.STYLE_DISABLED_TEXTURE = "disabledTexture"

--- Style: fontName
Button.STYLE_FONT_NAME = "fontName"

--- Style: textSize
Button.STYLE_TEXT_SIZE = "textSize"

--- Style: textSize
Button.STYLE_TEXT_COLOR = "textColor"

--- Style: horizotalAlign
Button.STYLE_TEXT_ALIGN = "textAlign"

--------------------------------------------------------------------------------
-- The constructor.
-- @param 
--------------------------------------------------------------------------------
function Button:_initInternal()
    UIComponent._initInternal(self)
    self._themeName = "Button"
    self._touchDownIdx = nil
    self._buttonImage = nil
    self._text = ""
    self._textLabel = nil
end

function Button:_initEventListeners()
    UIComponent._initEventListeners(self)
    self:addEventListener(Event.RESIZE, self.onResize, self)
    self:addEventListener(Event.TOUCH_DOWN, self.onTouchDown, self)
    self:addEventListener(Event.TOUCH_UP, self.onTouchUp, self)
    self:addEventListener(Event.TOUCH_MOVE, self.onTouchMove, self)
    self:addEventListener(Event.TOUCH_CANCEL, self.onTouchCancel, self)
end

function Button:_createChildren()
    UIComponent._createChildren(self)
    
    local imagePath = assert(self:getImagePath())
    self._buttonImage = NineImage(imagePath)
    self._textLabel = Label(self._text, 100, 30)

    self:addChild(self._buttonImage)
    self:addChild(self._textLabel)
    
    self:setSize(self._buttonImage:getSize())
end

--------------------------------------------------------------------------------
-- Update the display.
--------------------------------------------------------------------------------
function Button:updateDisplay()
    local buttonImage = self._buttonImage
    buttonImage:setImage(self:getImagePath())
    buttonImage:setSize(self:getSize())

    local textLabel = self._textLabel
    local xMin, yMin, xMax, yMax = buttonImage:getContentRect()
    local textWidth, textHeight = xMax - xMin, yMax - yMin    
    textLabel:setPos(xMin, yMin)
    textLabel:setSize(textWidth, textHeight)
    textLabel:setString(self:getText())
    textLabel:setTextSize(self:getTextSize())
    textLabel:setColor(self:getTextColor())
    textLabel:setAlignment(self:getAlignment())
    textLabel:setFont(self:getFont())
end

--------------------------------------------------------------------------------
-- Update the imageDeck.
--------------------------------------------------------------------------------
function Button:updateImageDeck()
    local buttonImage = self._buttonImage
    buttonImage:setImage(self:getImagePath())
end

--------------------------------------------------------------------------------
-- Returns the imageDeck.
-- @return imageDeck
--------------------------------------------------------------------------------
function Button:getImagePath()
    if not self:isEnabled() then
        return self:getStyle(Button.STYLE_DISABLED_TEXTURE)
    elseif self:isButtonDown() then
        return self:getStyle(Button.STYLE_SELECTED_TEXTURE)
    else
        return self:getStyle(Button.STYLE_NORMAL_TEXTURE)
    end
end

--------------------------------------------------------------------------------
-- If the user presses the button returns True.
-- @return If the user presses the button returns True
--------------------------------------------------------------------------------
function Button:isButtonDown()
    return self.touchDownIdx ~= nil
end

--------------------------------------------------------------------------------
-- Sets the normal texture.
-- @param texture texture
--------------------------------------------------------------------------------
function Button:setNormalTexture(texture)
    self:setStyle(Button.STYLE_NORMAL_TEXTURE, texture)
end

--------------------------------------------------------------------------------
-- Sets the selected texture.
-- @param texture texture
--------------------------------------------------------------------------------
function Button:setSelectedTexture(texture)
    self:setStyle(Button.STYLE_SELECTED_TEXTURE, texture)
end

--------------------------------------------------------------------------------
-- Sets the selected texture.
-- @param texture texture
--------------------------------------------------------------------------------
function Button:setDisabledTexture(texture)
    self:setStyle(Button.STYLE_DISABLED_TEXTURE, texture)
end

--------------------------------------------------------------------------------
-- Sets the text.
-- @param text text
--------------------------------------------------------------------------------
function Button:setText(text)
    self._text = text
    self._textLabel:setString(text)
end

--------------------------------------------------------------------------------
-- Returns the text.
-- @return text
--------------------------------------------------------------------------------
function Button:getText()
    return self._text
end

--------------------------------------------------------------------------------
-- Sets the textSize.
-- @param textSize textSize
--------------------------------------------------------------------------------
function Button:setTextSize(textSize)
    self:setStyle(Button.STYLE_TEXT_SIZE, textSize)
    self._textLabel:setTextSize(self:getTextSize())
end

--------------------------------------------------------------------------------
-- Sets the textSize.
-- @param textSize textSize
--------------------------------------------------------------------------------
function Button:getTextSize()
    return self:getStyle(Button.STYLE_TEXT_SIZE)
end

--------------------------------------------------------------------------------
-- Sets the textSize.
-- @param textSize textSize
--------------------------------------------------------------------------------
function Button:setFontName(fontName)
    self:setStyle(Button.STYLE_FONT_NAME, font)
    self._textLabel:setFont(self:getFont())
end

--------------------------------------------------------------------------------
-- Sets the textSize.
-- @param textSize textSize
--------------------------------------------------------------------------------
function Button:getFontName()
    return self:getStyle(Button.STYLE_FONT_NAME)
end

--------------------------------------------------------------------------------
-- Returns the font.
-- @return font
--------------------------------------------------------------------------------
function Button:getFont()
    local fontName = self:getFontName()
    local font = Resources.getFont(fontName, nil, self:getTextSize())
    return font
end

--------------------------------------------------------------------------------
-- Sets the text align.
-- @param horizotalAlign horizotal align(left, center, top)
-- @param verticalAlign vertical align(top, center, bottom)
--------------------------------------------------------------------------------
function Button:setTextAlign(horizotalAlign, verticalAlign)
    if horizotalAlign or verticalAlign then
        self:setStyle(Button.STYLE_TEXT_ALIGN, {horizotalAlign or "center", verticalAlign or "center"})
    else
        self:setStyle(Button.STYLE_TEXT_ALIGN, nil)
    end
    self._textLabel:setAlignment(self:getAlignment())
end

--------------------------------------------------------------------------------
-- Returns the text align.
-- @return horizotal align(left, center, top)
-- @return vertical align(top, center, bottom)
--------------------------------------------------------------------------------
function Button:getTextAlign()
    return unpack(self:getStyle(Button.STYLE_TEXT_ALIGN))
end

--------------------------------------------------------------------------------
-- Returns the text align for MOAITextBox.
-- @return horizotal align
-- @return vertical align
--------------------------------------------------------------------------------
function Button:getAlignment()
    local h, v = self:getTextAlign()
    h = assert(TextAlign[h])
    v = assert(TextAlign[v])
    return h, v
end

--------------------------------------------------------------------------------
-- Sets the text align.
-- @param red red(0 ... 1)
-- @param green green(0 ... 1)
-- @param blue blue(0 ... 1)
-- @param alpha alpha(0 ... 1)
--------------------------------------------------------------------------------
function Button:setTextColor(red, green, blue, alpha)
    if red == nil and green == nil and blue == nil and alpha == nil then
        self:setStyle(Button.STYLE_TEXT_COLOR, nil)
    else
        self:setStyle(Button.STYLE_TEXT_COLOR, {red or 0, green or 0, blue or 0, alpha or 0})
    end
    self._textLabel:setColor(self:getTextColor())
end

--------------------------------------------------------------------------------
-- Returns the text color.
-- @return red(0 ... 1)
-- @return green(0 ... 1)
-- @return blue(0 ... 1)
-- @return alpha(0 ... 1)
--------------------------------------------------------------------------------
function Button:getTextColor()
    return unpack(self:getStyle(Button.STYLE_TEXT_COLOR))
end

--------------------------------------------------------------------------------
-- Set the event listener that is called when the user click the button.
-- @param func click event handler
--------------------------------------------------------------------------------
function Button:setOnClick(func)
    self:setEventListener(UIEvent.CLICK, func)
end

--------------------------------------------------------------------------------
-- Set the event listener that is called when the user pressed the button.
-- @param func button down event handler
--------------------------------------------------------------------------------
function Button:setOnDown(func, obj)
    self:setEventListener(UIEvent.DOWN, func)
end

--------------------------------------------------------------------------------
-- Set the event listener that is called when the user released the button.
-- @param func button up event handler
--------------------------------------------------------------------------------
function Button:setOnUp(func)
    self:setEventListener(UIEvent.UP, func)
end

--------------------------------------------------------------------------------
-- Down the button.
-- There is no need to call directly to the basic.
-- @param idx Touch index
--------------------------------------------------------------------------------
function Button:doButtonDown(idx)
    if self:isButtonDown() then
        return
    end
    
    self.touchDownIdx = idx
    self:updateImageDeck()
    
    self:dispatchEvent(UIEvent.DOWN)
end

--------------------------------------------------------------------------------
-- Up the button.
-- There is no need to call directly to the basic.
--------------------------------------------------------------------------------
function Button:doButtonUp()
    if not self:isButtonDown() then
        return
    end

    self.touchDownIdx = nil
    self:updateImageDeck()
    
    self:dispatchEvent(UIEvent.UP)
end

--------------------------------------------------------------------------------
-- This event handler is called when enabled Changed.
-- @param e Touch Event
--------------------------------------------------------------------------------
function Button:onEnabledChanged(e)
    self:updateImageDeck()
    if not self:isEnabled() then
        self:doButtonUp()
    end
end

--------------------------------------------------------------------------------
-- This event handler is called when resize.
-- @param e Touch Event
--------------------------------------------------------------------------------
function Button:onResize(e)
    self._buttonImage:setSize(self:getSize())

    local xMin, yMin, xMax, yMax = self._buttonImage:getContentRect()
    local textWidth, textHeight = xMax - xMin, yMax - yMin    
    self._textLabel:setPos(xMin, yMin)
    self._textLabel:setSize(textWidth, textHeight)    
end

--------------------------------------------------------------------------------
-- This event handler is called when you touch the button.
-- @param e Touch Event
--------------------------------------------------------------------------------
function Button:onTouchDown(e)
    if self:isButtonDown() then
        return
    end
    self:doButtonDown(e.idx)
end

--------------------------------------------------------------------------------
-- This event handler is called when the button is released.
-- @param e Touch Event
--------------------------------------------------------------------------------
function Button:onTouchUp(e)
    if self.touchDownIdx ~= e.idx then
        return
    end
    self:doButtonUp()
    self:dispatchEvent(UIEvent.CLICK)
end

--------------------------------------------------------------------------------
-- This event handler is called when you move on the button.
-- @param e Touch Event
--------------------------------------------------------------------------------
function Button:onTouchMove(e)
    if self.touchDownIdx ~= e.idx then
        return
    end
    if not self:inside(e.wx, e.wy, 0) then
        self:doButtonUp()
    end
end

--------------------------------------------------------------------------------
-- This event handler is called when you cancel the touch.
-- @param e Touch Event
--------------------------------------------------------------------------------
function Button:onTouchCancel(e)
    if self.touchDownIdx ~= e.idx then
        return
    end
    self:doButtonUp()
end

----------------------------------------------------------------------------------------------------
-- @type Joystick
-- It is a virtual Joystick.
----------------------------------------------------------------------------------------------------
Joystick = class(UIComponent)
M.Joystick = Joystick

--- Direction of the stick
Joystick.STICK_CENTER          = "center"

--- Direction of the stick
Joystick.STICK_LEFT            = "left"

--- Direction of the stick
Joystick.STICK_TOP             = "top"

--- Direction of the stick
Joystick.STICK_RIGHT           = "right"

--- Direction of the stick
Joystick.STICK_BOTTOM          = "bottom"

--- Mode of the stick
Joystick.MODE_ANALOG           = "analog"

--- Mode of the stick
Joystick.MODE_DIGITAL          = "digital"

--- The ratio of the center
Joystick.RANGE_OF_CENTER_RATE  = 0.5

--- Style: baseTexture
Joystick.STYLE_BASE_TEXTURE  = "baseTexture"

--- Style: knobTexture
Joystick.STYLE_KNOB_TEXTURE  = "knobTexture"

--------------------------------------------------------------------------------
-- Initializes the internal variables.
--------------------------------------------------------------------------------
function Joystick:_initInternal()
    UIComponent._initInternal(self)
    self._themeName = "Joystick"
    self._touchIndex = nil
    self._rangeOfCenterRate = Joystick.RANGE_OF_CENTER_RATE
    self._stickMode = Joystick.MODE_ANALOG
    self._changedEvent = Event(UIEvent.STICK_CHANGED)
end

--------------------------------------------------------------------------------
-- Initializes the event listener.
-- You must not be called directly.
--------------------------------------------------------------------------------
function Joystick:_initEventListeners()
    UIComponent._initEventListeners(self)
    self:addEventListener(Event.TOUCH_DOWN, self.onTouchDown, self)
    self:addEventListener(Event.TOUCH_UP, self.onTouchUp, self)
    self:addEventListener(Event.TOUCH_MOVE, self.onTouchMove, self)
    self:addEventListener(Event.TOUCH_CANCEL, self.onTouchCancel, self)
end


--------------------------------------------------------------------------------
-- Initialize child objects that make up the Joystick.
-- You must not be called directly.
--------------------------------------------------------------------------------
function Joystick:_createChildren()
    UIComponent._createChildren(self)
    
    self._baseImage = Image(self:getStyle(Joystick.STYLE_BASE_TEXTURE))
    self._knobImage = Image(self:getStyle(Joystick.STYLE_KNOB_TEXTURE))

    self:addChild(self._baseImage)
    self:addChild(self._knobImage)

    self:setSize(self._baseImage:getSize())
    self:setCenterKnob()
end

function Joystick:updateDisplay()
    self._baseImage:setTexture(self:getStyle(Joystick.STYLE_BASE_TEXTURE))
    self._knobImage:setTexture(self:getStyle(Joystick.STYLE_KNOB_TEXTURE))
end

--------------------------------------------------------------------------------
-- To update the position of the knob.
-- @param x The x-position of the knob
-- @param y The y-position of the knob
--------------------------------------------------------------------------------
function Joystick:updateKnob(x, y)
    local oldX, oldY = self._knobImage:getLoc()
    local newX, newY = self:getKnobNewLoc(x, y)

    if oldX ~= newX or oldY ~= newY then
        self._knobImage:setLoc(newX, newY, 0)
    
        local e = self._changedEvent
        e.oldX, e.oldY = self:getKnobInputRate(oldX, oldY)
        e.newX, e.newY = self:getKnobInputRate(newX, newY)
        e.direction = self:getStickDirection()
        e.down = self._touchDownFlag
        self:dispatchEvent(e)
    end
end

--------------------------------------------------------------------------------
-- Set the position of the center of the knob.
--------------------------------------------------------------------------------
function Joystick:setCenterKnob()
    local cx, cy = self:getWidth() / 2, self:getHeight() / 2
    self._knobImage:setLoc(cx, cy, 0)
end

--------------------------------------------------------------------------------
-- Returns the position of the center of the whole.
-- Does not depend on the Pivot.
-- @return Center x-position
-- @return Center y-position
--------------------------------------------------------------------------------
function Joystick:getCenterLoc()
    return self:getWidth() / 2, self:getHeight() / 2
end

--------------------------------------------------------------------------------
-- Returns the position that matches the mode of the stick.
-- @param x X-position of the model
-- @param y Y-position of the model
-- @return adjusted x-position
-- @return adjusted y-position
--------------------------------------------------------------------------------
function Joystick:getKnobNewLoc(x, y)
    if self:getStickMode() == Joystick.MODE_ANALOG then
        return self:getKnobNewLocForAnalog(x, y)
    else
        return self:getKnobNewLocForDigital(x, y)
    end
end

--------------------------------------------------------------------------------
-- Returns the position to match the analog mode.
-- @param x X-position of the model
-- @param y Y-position of the model
-- @return adjusted x-position
-- @return adjusted y-position
--------------------------------------------------------------------------------
function Joystick:getKnobNewLocForAnalog(x, y)
    local cx, cy = self:getCenterLoc()
    local rx, ry = (x - cx), (y - cy)
    local radian = math.atan2(math.abs(ry), math.abs(rx))
    local maxX, maxY =  math.cos(radian) * cx + cx,  math.sin(radian) * cy + cy
    local minX, minY = -math.cos(radian) * cx + cx, -math.sin(radian) * cy + cy
    
    x = x < minX and minX or x
    x = x > maxX and maxX or x
    y = y < minY and minY or y
    y = y > maxY and maxY or y
    
    return x, y
end

--------------------------------------------------------------------------------
-- Returns the position to match the digital mode.
-- @param x X-position of the model
-- @param y Y-position of the model
-- @return adjusted x-position
-- @return adjusted y-position
--------------------------------------------------------------------------------
function Joystick:getKnobNewLocForDigital(x, y)
    local cx, cy = self:getCenterLoc()
    local rx, ry = (x - cx), (y - cy)
    local radian = math.atan2(math.abs(ry), math.abs(rx))
    local minX, minY = 0, 0
    local maxX, maxY = self:getSize()
    local cRate = self._rangeOfCenterRate
    local cMinX, cMinY = cx - cx * cRate, cy - cy * cRate
    local cMaxX, cMaxY = cx + cx * cRate, cy + cy * cRate
    
    if cMinX < x and x < cMaxX and cMinY < y and y < cMaxY then
        x = cx
        y = cy
    elseif math.cos(radian) > math.sin(radian) then
        x = x < cx and minX or maxX
        y = cy
    else
        x = cx
        y = y < cy and minY or maxY
    end
    return x, y
end

--------------------------------------------------------------------------------
-- Returns the percentage of input.
-- @param x X-position
-- @param y Y-position
-- @return X-ratio(-1 <= x <= 1)
-- @return Y-ratio(-1 <= y <= 1)
--------------------------------------------------------------------------------
function Joystick:getKnobInputRate(x, y)
    local cx, cy = self:getCenterLoc()
    local rateX, rateY = (x - cx) / cx, (y - cy) / cy
    return rateX, rateY
end

--------------------------------------------------------------------------------
-- Returns the direction of the stick.
-- @return direction
--------------------------------------------------------------------------------
function Joystick:getStickDirection()
    local x, y = self._knobImage:getLoc()
    local cx, cy = self:getCenterLoc()
    local radian = math.atan2(math.abs(x - cx), math.abs(y - cy))

    local dir
    if x == cx and y == cy then
        dir = Joystick.STICK_CENTER
    elseif math.cos(radian) < math.sin(radian) then
        dir = x < cx and Joystick.STICK_LEFT or Joystick.STICK_RIGHT
    else
        dir = y < cy and Joystick.STICK_TOP or Joystick.STICK_BOTTOM
    end
    return dir
end

--------------------------------------------------------------------------------
-- Returns the stick mode
-- @return stick mode
--------------------------------------------------------------------------------
function Joystick:getStickMode()
    return self._stickMode
end

--------------------------------------------------------------------------------
-- Set the mode of the stick.
-- @param mode mode("analog" or "digital")
--------------------------------------------------------------------------------
function Joystick:setStickMode(mode)
    self._stickMode = mode
end

--------------------------------------------------------------------------------
-- Returns the touched.
-- @return stick mode
--------------------------------------------------------------------------------
function Joystick:isTouchDown()
    return self._touchIndex ~= nil
end

--------------------------------------------------------------------------------
-- Set the event listener that is called when the stick changed.
-- @param func stickChanged event handler
--------------------------------------------------------------------------------
function Joystick:setOnStickChanged(func)
    self:setEventListener(UIEvent.STICK_CHANGED, func)
end

--------------------------------------------------------------------------------
-- This event handler is called when touched.
-- @param e Touch Event
--------------------------------------------------------------------------------
function Joystick:onTouchDown(e)
    if self:isTouchDown() then
        return
    end

    local mx, my = self:worldToModel(e.wx, e.wy, 0)
    self._touchIndex = e.idx
    self:updateKnob(mx, my)
end

--------------------------------------------------------------------------------
-- This event handler is called when the button is released.
-- @param e Touch Event
--------------------------------------------------------------------------------
function Joystick:onTouchUp(e)
    if e.idx ~= self._touchIndex then
        return
    end

    self._touchIndex = nil
    local cx, cy = self:getCenterLoc()
    self:updateKnob(cx, cy)
end

--------------------------------------------------------------------------------
-- This event handler is called when you move on the button.
-- @param e Touch Event
--------------------------------------------------------------------------------
function Joystick:onTouchMove(e)
    if e.idx ~= self._touchIndex then
        return
    end
    
    local mx, my = self:worldToModel(e.wx, e.wy, 0)
    self:updateKnob(mx, my)
end

--------------------------------------------------------------------------------
-- This event handler is called when you move on the button.
-- @param e Touch Event
--------------------------------------------------------------------------------
function Joystick:onTouchCancel(e)
    self._touchIndex = nil
    self:setCenterKnob()
end

----------------------------------------------------------------------------------------------------
-- @type Panel
-- It is a Panel.
----------------------------------------------------------------------------------------------------
Panel = class(UIComponent)
M.Panel = Panel

--- Style: panelTexture
Panel.STYLE_BACKGROUND_TEXTURE = "backgroundTexture"

--------------------------------------------------------------------------------
-- The constructor.
-- @param baseTexture Joystick base texture
-- @param knobTexture Joystick knob texture
--------------------------------------------------------------------------------
function Panel:_initInternal()
    UIComponent._initInternal(self)
    self._themeName = "Panel"
end

--------------------------------------------------------------------------------
-- Initialize the event listeners
--------------------------------------------------------------------------------
function Panel:_initEventListeners()
    UIComponent._initEventListeners(self)
    self:addEventListener(Event.RESIZE, self.onResize, self)
end

--------------------------------------------------------------------------------
-- Initialize child objects that make up the Joystick.
-- You must not be called directly.
--------------------------------------------------------------------------------
function Panel:_createChildren()
    UIComponent._createChildren(self)
    self:_createBackgroundImage()
end

function Panel:_createBackgroundImage()
    if self._backgroundImage then
        return
    end
    
    local texture = self:getBackgroundTexture()
    if texture then
        self._backgroundImage = NineImage(texture)
        self:addChild(self._backgroundImage)
    end
end

--------------------------------------------------------------------------------
-- Update the display objects.
--------------------------------------------------------------------------------
function Panel:updateDisplay()
    UIComponent.updateDisplay(self)
    if self._backgroundImage then
        self._backgroundImage:setImage(self:getBackgroundTexture())
        self._backgroundImage:setSize(self:getSize())
    end
end

--------------------------------------------------------------------------------
-- Sets the background texture path.
-- @param texture background texture path
--------------------------------------------------------------------------------
function Panel:setBackgroundTexture(texture)
    self:setStyle(Panel.STYLE_BACKGROUND_TEXTURE, texture)
    self._backgroundImage:setImage(self:getBackgroundTexture())    
end

--------------------------------------------------------------------------------
-- Returns the background texture path.
-- @param texture background texture path
--------------------------------------------------------------------------------
function Panel:getBackgroundTexture()
    return self:getStyle(Panel.STYLE_BACKGROUND_TEXTURE)
end


--------------------------------------------------------------------------------
-- This event handler is called when resize.
-- @param e Touch Event
--------------------------------------------------------------------------------
function Panel:onResize(e)
    self._backgroundImage:setSize(self:getSize())
end

----------------------------------------------------------------------------------------------------
-- @type TextBox
-- It is a TextBox.
----------------------------------------------------------------------------------------------------
TextBox = class(Panel)
M.TextBox = TextBox

--- Style: fontName
TextBox.STYLE_FONT_NAME = "fontName"

--- Style: textSize
TextBox.STYLE_TEXT_SIZE = "textSize"

--- Style: textColor
TextBox.STYLE_TEXT_COLOR = "textColor"

--- Style: textSize
TextBox.STYLE_TEXT_ALIGN = "textAlign"

--------------------------------------------------------------------------------
--Initialize a variables
--------------------------------------------------------------------------------
function TextBox:_initInternal()
    Panel._initInternal(self)
    self._themeName = "TextBox"
    self._text = ""
    self._textLabel = nil
end

--------------------------------------------------------------------------------
-- Initialize child objects that make up the Joystick.
-- You must not be called directly.
--------------------------------------------------------------------------------
function TextBox:_createChildren()
    Panel._createChildren(self)
    
    self._textLabel = Label(self._text, 100, 30)
    self._textLabel:setWordBreak(MOAITextBox.WORD_BREAK_CHAR)
    self:addChild(self._textLabel)
end

--------------------------------------------------------------------------------
-- Update the display objects.
--------------------------------------------------------------------------------
function TextBox:updateDisplay()
    Panel.updateDisplay(self)

    local textLabel = self._textLabel
    local xMin, yMin, xMax, yMax = self._backgroundImage:getContentRect()
    local textWidth, textHeight = xMax - xMin, yMax - yMin    
    textLabel:setPos(xMin, yMin)
    textLabel:setSize(textWidth, textHeight)
    textLabel:setString(self:getText())
    textLabel:setTextSize(self:getTextSize())
    textLabel:setColor(self:getTextColor())
    textLabel:setAlignment(self:getAlignment())
    textLabel:setFont(self:getFont())
end

--------------------------------------------------------------------------------
-- Sets the text.
-- @param text text
--------------------------------------------------------------------------------
function TextBox:setText(text)
    self._text = text
    self._textLabel:setString(text)
end

--------------------------------------------------------------------------------
-- Adds the text.
-- @param text text
--------------------------------------------------------------------------------
function TextBox:addText(text)
    self:setText(self._text .. text)
end

--------------------------------------------------------------------------------
-- Returns the text.
-- @return text
--------------------------------------------------------------------------------
function TextBox:getText()
    return self._text
end

--------------------------------------------------------------------------------
-- Sets the textSize.
-- @param textSize textSize
--------------------------------------------------------------------------------
function TextBox:setTextSize(textSize)
    self:setStyle(TextBox.STYLE_TEXT_SIZE, textSize)
    self._textLabel:setTextSize(self:getTextSize())
end

--------------------------------------------------------------------------------
-- Sets the textSize.
-- @param textSize textSize
--------------------------------------------------------------------------------
function TextBox:getTextSize()
    return self:getStyle(TextBox.STYLE_TEXT_SIZE)
end

--------------------------------------------------------------------------------
-- Sets the textSize.
-- @param textSize textSize
--------------------------------------------------------------------------------
function TextBox:setFontName(fontName)
    self:setStyle(TextBox.STYLE_FONT_NAME, font)
    self._textLabel:setFont(self:getFont())
end

--------------------------------------------------------------------------------
-- Sets the textSize.
-- @param textSize textSize
--------------------------------------------------------------------------------
function TextBox:getFontName()
    return self:getStyle(TextBox.STYLE_FONT_NAME)
end

--------------------------------------------------------------------------------
-- Returns the font.
-- @return font
--------------------------------------------------------------------------------
function TextBox:getFont()
    local fontName = self:getFontName()
    local font = Resources.getFont(fontName, nil, self:getTextSize())
    return font
end

--------------------------------------------------------------------------------
-- Sets the text align.
-- @param horizotalAlign horizotal align(left, center, top)
-- @param verticalAlign vertical align(top, center, bottom)
--------------------------------------------------------------------------------
function TextBox:setTextAlign(horizotalAlign, verticalAlign)
    if horizotalAlign or verticalAlign then
        self:setStyle(TextBox.STYLE_TEXT_ALIGN, {horizotalAlign or "center", verticalAlign or "center"})
    else
        self:setStyle(TextBox.STYLE_TEXT_ALIGN, nil)
    end
    self._textLabel:setAlignment(self:getAlignment())
end

--------------------------------------------------------------------------------
-- Returns the text align.
-- @return horizotal align(left, center, top)
-- @return vertical align(top, center, bottom)
--------------------------------------------------------------------------------
function TextBox:getTextAlign()
    return unpack(self:getStyle(TextBox.STYLE_TEXT_ALIGN))
end

--------------------------------------------------------------------------------
-- Returns the text align for MOAITextBox.
-- @return horizotal align
-- @return vertical align
--------------------------------------------------------------------------------
function TextBox:getAlignment()
    local h, v = self:getTextAlign()
    h = assert(TextAlign[h])
    v = assert(TextAlign[v])
    return h, v
end

--------------------------------------------------------------------------------
-- Sets the text align.
-- @param red red(0 ... 1)
-- @param green green(0 ... 1)
-- @param blue blue(0 ... 1)
-- @param alpha alpha(0 ... 1)
--------------------------------------------------------------------------------
function TextBox:setTextColor(red, green, blue, alpha)
    if red == nil and green == nil and blue == nil and alpha == nil then
        self:setStyle(TextBox.STYLE_TEXT_COLOR, nil)
    else
        self:setStyle(TextBox.STYLE_TEXT_COLOR, {red or 0, green or 0, blue or 0, alpha or 0})
    end
    self._textLabel:setColor(self:getTextColor())
end

--------------------------------------------------------------------------------
-- Returns the text color.
-- @return red(0 ... 1)
-- @return green(0 ... 1)
-- @return blue(0 ... 1)
-- @return alpha(0 ... 1)
--------------------------------------------------------------------------------
function TextBox:getTextColor()
    return unpack(self:getStyle(TextBox.STYLE_TEXT_COLOR))
end

--------------------------------------------------------------------------------
-- This event handler is called when resize.
-- @param e Touch Event
--------------------------------------------------------------------------------
function TextBox:onResize(e)
    Panel.onResize(self, e)
    
    local xMin, yMin, xMax, yMax = self._backgroundImage:getContentRect()
    local textWidth, textHeight = xMax - xMin, yMax - yMin
    self._textLabel:setPos(xMin, yMin)
    self._textLabel:setSize(textWidth, textHeight)
end

----------------------------------------------------------------------------------------------------
-- @type TextBox
-- It is a TextBox.
----------------------------------------------------------------------------------------------------
TextInput = class(TextBox)
M.TextInput = TextInput

--- Style: focusTexture
TextInput.STYLE_FOCUS_TEXTURE = "focusTexture"

--------------------------------------------------------------------------------
-- Initialize a variables
--------------------------------------------------------------------------------
function TextInput:_initInternal()
    TextBox._initInternal(self)
    self._themeName = "TextInput"
    self._onKeyboardInput = function(start, length, text)
        self:onKeyboardInput(start, length, text)
    end
    self._onKeyboardReturn = function()
        self:onKeyboardReturn()
    end
    
end

--------------------------------------------------------------------------------
-- Initialize the event listeners.
--------------------------------------------------------------------------------
function TextInput:_initEventListeners()
    TextBox._initEventListeners(self)
end

--------------------------------------------------------------------------------
-- Create the children.
--------------------------------------------------------------------------------
function TextInput:_createChildren()
    TextBox._createChildren(self)
    
    self._textAllow = Rect(1, self:getTextSize())
    self._textAllow:setColor(0, 0, 0, 1)
    self._textAllow:setVisible(false)
    self:addChild(self._textAllow)
end

--------------------------------------------------------------------------------
-- Draw the focus object.
--------------------------------------------------------------------------------
function TextInput:drawFocus(focus)
    TextBox.drawFocus(self, focus)
    self._backgroundImage:setImage(self:getBackgroundTexture())
    
    self:drawTextAllow()
end

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

--------------------------------------------------------------------------------
-- Returns the background texture path.
-- @return background texture path
--------------------------------------------------------------------------------
function TextInput:getBackgroundTexture()
    if self:isFocus() then
        return self:getStyle(TextInput.STYLE_FOCUS_TEXTURE)
    end
    return TextBox.getBackgroundTexture(self)
end

--------------------------------------------------------------------------------
-- This event handler is called when focus in.
-- @param e event
--------------------------------------------------------------------------------
function TextInput:onFocusIn(e)
    TextBox.onFocusIn(self, e)
    
    if MOAIKeyboard then
        MOAIKeyboard.setListener(MOAIKeyboard.EVENT_INPUT, self._onKeyboardInput)
        MOAIKeyboard.setListener(MOAIKeyboard.EVENT_RETURN, self._onKeyboardReturn)
        MOAIKeyboard.showKeyboard(self:getText())
    else
        InputMgr:addEventListener(Event.KEY_DOWN, self.onKeyDown, self)
        InputMgr:addEventListener(Event.KEY_UP, self.onKeyUp, self)
    end
end

--------------------------------------------------------------------------------
-- This event handler is called when focus in.
-- @param e event
--------------------------------------------------------------------------------
function TextInput:onFocusOut(e)
    TextBox.onFocusOut(self, e)

    if MOAIKeyboard then
        --TODO:MOAIKeyboard.hideKeyboard()
    else
        InputMgr:removeEventListener(Event.KEY_DOWN, self.onKeyDown, self)
        InputMgr:removeEventListener(Event.KEY_UP, self.onKeyUp, self)
    end
end

--------------------------------------------------------------------------------
-- This event handler is called when focus in.
-- @param e event
--------------------------------------------------------------------------------
function TextInput:onKeyDown(e)
    local key = e.key
    print("key = " .. key)
    
    if key == KeyCode.DEL or key == KeyCode.BACKSPACE then
        local text = self:getText()
        text = #text > 0 and text:sub(1, #text - 1) or text
        self:setText(text)
    elseif key == KeyCode.ENTER then
        -- TODO: LF
    else
        self:addText(string.char(key))
    end

    self:drawTextAllow()
end

--------------------------------------------------------------------------------
-- This event handler is called when key up.
-- @param e event
--------------------------------------------------------------------------------
function TextInput:onKeyUp(e)
end

--------------------------------------------------------------------------------
-- This event handler is called when keyboard input.
-- @param start start
-- @param length length
-- @param text text
--------------------------------------------------------------------------------
function TextInput:onKeyboardInput(start, length, text)
    self:setText(MOAIKeyboard.getText())
    self:drawTextAllow()
end

--------------------------------------------------------------------------------
-- This event handler is called when keyboard input.
--------------------------------------------------------------------------------
function TextInput:onKeyboardReturn()
    self:setText(MOAIKeyboard.getText())
    self:setFocus(false)
end

----------------------------------------------------------------------------------------------------
-- @type MsgBox
-- It is a MsgBox.
----------------------------------------------------------------------------------------------------
MsgBox = class(TextBox)
M.MsgBox = MsgBox

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

--------------------------------------------------------------------------------
-- Initialize a internal variables.
--------------------------------------------------------------------------------
function MsgBox:_initInternal()
    TextBox._initInternal(self)
    self._themeName = "MsgBox"
    self._popupShowing = false
    self._spoolingEnabled = true
    
    -- TODO: visibility
    self:setColor(0, 0, 0, 0)
end

--------------------------------------------------------------------------------
-- Initialize the event listeners.
--------------------------------------------------------------------------------
function MsgBox:_initEventListeners()
    TextBox._initEventListeners(self)
    self:addEventListener(Event.TOUCH_DOWN, self.onTouchDown, self)
end

--------------------------------------------------------------------------------
-- Show MsgBox.
--------------------------------------------------------------------------------
function MsgBox:showPopup()
    if self:isPopupShowing() then
        return
    end
    self._popupShowing = true
    
    -- text label setting
    self:setText(self._text)
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

--------------------------------------------------------------------------------
-- Hide MsgBox.
--------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------
-- Displays the next page.
--------------------------------------------------------------------------------
function MsgBox:nextPage()
    self._textLabel:nextPage()
    if self._spoolingEnabled then
        self._textLabel:spool()
    end
end

--------------------------------------------------------------------------------
-- TODO:LDoc.
--------------------------------------------------------------------------------
function MsgBox:isPopupShowing()
    return self._popupShowing
end

--------------------------------------------------------------------------------
-- TODO:LDoc.
--------------------------------------------------------------------------------
function MsgBox:isSpooling()
    return self._textLabel:isBusy()
end

--------------------------------------------------------------------------------
-- TODO:LDoc.
--------------------------------------------------------------------------------
function MsgBox:hasNextPase()
    return self._textLabel:more()
end

--------------------------------------------------------------------------------
-- Sets the pause texture.
-- @param texture pause texture
--------------------------------------------------------------------------------
function MsgBox:setPauseTexture(texture)
    self:setStyle(MsgBox.STYLE_PAUSE_TEXTURE, texture)
    
    local pauseIcon = self._pauseIcon
    pauseIcon:setTexture(self:getStyle(MsgBox.STYLE_PAUSE_TEXTURE))    
    pauseIcon:setSheetSize(1, 6)
    local width, height = self:getSize()
    local iconWidth, iconHeight = pauseIcon:getSize()
    pauseIcon:setPos(width - iconWidth, height - iconHeight)
end

--------------------------------------------------------------------------------
-- Turns spooling ON or OFF.
-- If self is currently spooling and enable is false, stop spooling and reveal 
-- entire page. 
-- @param enable Boolean for new state
-- @return none
-------------------------------------------------------------------------------
function MsgBox:setSpoolingEnabled(enabled)
    self._spoolingEnabled = enabled
    if not self._spoolingEnabled and self:isSpooling() then
        self._textLabel:stop()
        self._textLabel:revealAll()
    end
end

--------------------------------------------------------------------------------
-- This event handler is called when you touch the component.
-- @param e touch event
--------------------------------------------------------------------------------
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

----------------------------------------------------------------------------------------------------
-- @type ListBox
-- 
----------------------------------------------------------------------------------------------------
ListBox = class(Panel)
M.ListBox = ListBox

--- Style: listItemFactory
ListBox.STYLE_LIST_ITEM_FACTORY = "listItemFactory"

--------------------------------------------------------------------------------
-- Initialize a variables
--------------------------------------------------------------------------------
function ListBox:_initInternal()
    Panel._initInternal(self)
    self._themeName = "ListBox"
    self._listItems = {}
    self._listData = {}
end

--------------------------------------------------------------------------------
-- Initialize the event listeners.
--------------------------------------------------------------------------------
function ListBox:_initEventListeners()
    Panel._initEventListeners(self)
    self:addEventListener(Event.TOUCH_DOWN, self.onTouchDown, self)
end

--------------------------------------------------------------------------------
-- Create the children.
--------------------------------------------------------------------------------
function ListBox:_createChildren()
    Panel._createChildren(self)
end

--------------------------------------------------------------------------------
-- Update the display.
--------------------------------------------------------------------------------
function ListBox:updateDisplay()
    Panel.updateDisplay(self)
end

function ListBox:updateLayout()
    
end

function ListBox:refreshData()
    
end

function ListBox:setListData(listData)
    self._listData = listData
    self:refreshData()
end

function ListBox:getListData()
    return self._listData
end

function ListBox:getListItemFactory()
    return self:getStyle(ListBox.STYLE_LIST_ITEM_FACTORY)
end




----------------------------------------------------------------------------------------------------
-- @type ListBox
-- 
----------------------------------------------------------------------------------------------------
ListItem = class(UIComponent)
M.ListItem = ListItem

--------------------------------------------------------------------------------
-- Initialize a variables
--------------------------------------------------------------------------------
function ListItem:_initInternal()
    UIComponent._initInternal(self)
    self._themeName = "ListItem"
    self._data = nil
    self._rowIndex = nil
end

--------------------------------------------------------------------------------
-- Initialize the event listeners.
--------------------------------------------------------------------------------
function ListItem:_initEventListeners()
    UIComponent._initEventListeners(self)
    self:addEventListener(Event.TOUCH_DOWN, self.onTouchDown, self)
end

--------------------------------------------------------------------------------
-- Create the children.
--------------------------------------------------------------------------------
function ListItem:_createChildren()
    UIComponent._createChildren(self)
end

--------------------------------------------------------------------------------
-- Update the display.
--------------------------------------------------------------------------------
function ListItem:updateDisplay()
    UIComponent.updateDisplay(self)
    
    
    
end

function ListItem:setData(data, rowIndex)
    self._data = data
    self._rowIndex = rowIndex
    self:updateDisplay()
end


function ListItem:onTouchDown(e)
    

end


-- widget initialize
M.initialize()

return M
