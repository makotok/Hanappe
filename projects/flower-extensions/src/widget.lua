----------------------------------------------------------------------------------------------------
-- GUI Library.
-- There are still some problems.
-- 
-- TODO:Require refactoring of some of the classes.
-- TODO:TextInput does not support multi-byte.
-- TODO:TextInput can not move the cursor.
-- TODO:Does not have a scroll bar in ListBox.
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
local EventDispatcher = flower.EventDispatcher
local DisplayObject = flower.DisplayObject
local Layer = flower.Layer
local Group = flower.Group
local Image = flower.Image
local SheetImage = flower.SheetImage
local NineImage = flower.NineImage
local MovieClip = flower.MovieClip
local Label = flower.Label
local Rect = flower.Rect
local TouchHandler = flower.TouchHandler
local MOAIKeyboard = MOAIKeyboardAndroid or MOAIKeyboardIOS
local MOAIDialog = MOAIDialogAndroid or MOAIDialogIOS

-- classes
local ThemeMgr
local FocusMgr
local TextAlign
local KeyCode
local UIEvent
local UIComponent
local UIGroup
local UIView
local Button
local ImageButton
local SheetButton
local CheckBox
local Joystick
local Panel
local TextBox
local TextInput
local MsgBox
local ListBox
local ListItem
local ScrollBar
local Slider

-- interfaces
local MOAIPropInterface = MOAIProp.getInterfaceTable()

----------------------------------------------------------------------------------------------------
-- Public functions
----------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Initializes the library.
-- They are initialized when you request the module.
--------------------------------------------------------------------------------
function M.initialize()
    if M.initialized then
        return
    end

    M.themeMgr = ThemeMgr()
    M.focusMgr = FocusMgr()
    
    M.initialized = true
end

--------------------------------------------------------------------------------
-- Set the theme of widget.
-- TODO:Theme can be changed dynamically
-- @param theme theme of widget
--------------------------------------------------------------------------------
function M.setTheme(theme)
    M.themeMgr:setTheme(theme)
end

--------------------------------------------------------------------------------
-- Return the theme of widget.
-- @return theme
--------------------------------------------------------------------------------
function M.getTheme()
    return M.themeMgr:getTheme()
end

--------------------------------------------------------------------------------
-- Return the ThemeMgr.
--------------------------------------------------------------------------------
function M.getThemeMgr()
    return M.themeMgr
end

--------------------------------------------------------------------------------
-- Return the FocusMgr.
--------------------------------------------------------------------------------
function M.getFocusMgr()
    return M.focusMgr
end

----------------------------------------------------------------------------------------------------
-- @type function showDialog
-- This class is an dialog or IOS and Android.
-- @param string title, 
-- @param string message, 
-- @param string positive, 
-- @param string neutral, 
-- @param string negative, 
-- @param bool cancelable 
-- @param [, function callback ]
----------------------------------------------------------------------------------------------------
function M.showDialog(...)
    MOAIDialog.showDialog(...)
end

----------------------------------------------------------------------------------------------------
-- @type ThemeMgr
-- This is a class to manage the Theme.
-- Please get an instance from the widget module.
----------------------------------------------------------------------------------------------------
ThemeMgr = class(EventDispatcher)
M.ThemeMgr = ThemeMgr

--------------------------------------------------------------------------------
-- Constructor.
--------------------------------------------------------------------------------
function ThemeMgr:init()
    ThemeMgr.__super.init(self)
    self.theme = nil
end

--------------------------------------------------------------------------------
-- Set the theme of widget.
-- @param theme theme of widget
--------------------------------------------------------------------------------
function ThemeMgr:setTheme(theme)
    if self.theme ~= theme then
        self.theme = theme
        self:dispatchEvent(UIEvent.THEME_CHANGED)
    end
end

--------------------------------------------------------------------------------
-- Return the theme of widget.
-- @return theme
--------------------------------------------------------------------------------
function ThemeMgr:getTheme()
    return self.theme
end

----------------------------------------------------------------------------------------------------
-- @type FocusMgr
-- This is a class to manage the focus of the widget.
-- Please get an instance from the widget module.
----------------------------------------------------------------------------------------------------
FocusMgr = class(EventDispatcher)
M.FocusMgr = FocusMgr

--------------------------------------------------------------------------------
-- Constructor.
--------------------------------------------------------------------------------
function FocusMgr:init()
    FocusMgr.__super.init(self)
    self.focusObject = nil
end

--------------------------------------------------------------------------------
-- Set the focus object.
-- @param object focus object.
--------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------
-- Return the focus object.
-- @return focus object.
--------------------------------------------------------------------------------
function FocusMgr:getFocusObject()
    return self.focusObject
end

----------------------------------------------------------------------------------------------------
-- @type TextAlign
-- This is a table that defines the alignment of the text.
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
-- This is a table that defines the code of the key input.
----------------------------------------------------------------------------------------------------
KeyCode = {}
M.KeyCode = KeyCode

--- DEL
KeyCode.DEL = 127

--- BACKSPACE
KeyCode.BACKSPACE = 8

--- SPACE
KeyCode.SPACE = 32

--- ENTER
KeyCode.ENTER = 13

--- TAB
KeyCode.TAB = 9

----------------------------------------------------------------------------------------------------
-- @type UIEvent
-- This is a class that defines the type of event.
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

--- Button: Click Event
UIEvent.CANCEL = "cancel"

--- Button: Selected changed Event
UIEvent.SELECTED_CHANGED = "selectedChanged"

--- Button: down Event
UIEvent.DOWN = "down"

--- Button: up Event
UIEvent.UP = "up"

--- Slider: value changed Event
UIEvent.VALUE_CHANGED = "valueChanged"

--- Joystick: Event type when you change the position of the stick
UIEvent.STICK_CHANGED = "stickChanged"

--- MsgBox: msgShow Event
UIEvent.MSG_SHOW = "msgShow"

--- MsgBox: msgHide Event
UIEvent.MSG_HIDE = "msgHide"

--- MsgBox: msgEnd Event
UIEvent.MSG_END = "msgEnd"

--- MsgBox: spoolStop Event
UIEvent.SPOOL_STOP = "spoolStop"

--- ListBox: selectedChanged
UIEvent.ITEM_CHANGED = "itemChanged"

--- ListBox: enter
UIEvent.ITEM_ENTER = "itemEnter"

----------------------------------------------------------------------------------------------------
-- @type UIComponent
-- The base class for all components.
-- Provide the basic operation of the component.
----------------------------------------------------------------------------------------------------
UIComponent = class(Group)
M.UIComponent = UIComponent

--- Style: normalColor
UIComponent.STYLE_NORMAL_COLOR = "normalColor"

--- Style: disabledColor
UIComponent.STYLE_DISABLED_COLOR = "disabledColor"

--------------------------------------------------------------------------------
-- Constructor.
-- Please do not inherit this constructor.
-- Please have some template functions are inherited.
-- @param params Parameter table
--------------------------------------------------------------------------------
function UIComponent:init(params)
    UIComponent.__super.init(self)
    self:_initInternal()
    self:_initEventListeners()
    self:_createChildren()
    
    self:setProperties(params)
    self:updateDisplay()
    self:setPivToCenter()
    
    self._initialized = true
end

--------------------------------------------------------------------------------
-- Initialization is the process of internal variables.
-- Please to inherit this function if the definition of the variable.
--------------------------------------------------------------------------------
function UIComponent:_initInternal()
    self.isUIComponent = true
    
    self._initialized = false
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
-- When called this function, please refresh all.
--------------------------------------------------------------------------------
function UIComponent:updateDisplay()

end

--------------------------------------------------------------------------------
-- Draw focus object.
-- Called at a timing that is configured with focus.
-- @param focus focus
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
    if UIComponent.__super.addChild(self, child) then
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
-- Sets the width.
-- @param width Width
--------------------------------------------------------------------------------
function UIComponent:setWidth(width)
    local w, h = self:getSize()
    self:setSize(width, h)
end

--------------------------------------------------------------------------------
-- Sets the height.
-- @param width Width
--------------------------------------------------------------------------------
function UIComponent:setHeight(height)
    local w, h = self:getSize()
    self:setSize(w, height)
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
        UIComponent.__super.setSize(self, width, height)
        self:dispatchEvent(UIEvent.RESIZE)
    end
end

--------------------------------------------------------------------------------
-- Sets the object's parent, inheriting its color and transform.
-- If you set a parent, you want to add itself to the parent.
-- @param parent parent
--------------------------------------------------------------------------------
function UIComponent:setParent(parent)
    if parent == self.parent then
        return
    end
    
    -- remove
    local oldParent = self.parent
    self.parent = parent
    if oldParent and oldParent.isGroup then
        oldParent:removeChild(self)
    end
    
    -- set
    UIComponent.__super.setParent(self, parent)
    
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
    self._enabled = enabled
    self:dispatchEvent(UIEvent.ENABLED_CHANGED)
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
function UIComponent:isComponentEnabled()
    if not self._enabled then
        return false
    end
    
    local parent = self.parent
    if parent and parent.isComponentEnabled then
        return parent:isComponentEnabled()
    end
    return true
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
    
    local globalTheme = M.getTheme()
    return globalTheme["common"][name]
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
    if self:isEnabled() then
        self:setColor(unpack(self:getStyle(UIComponent.STYLE_NORMAL_COLOR)))
    else
        self:setColor(unpack(self:getStyle(UIComponent.STYLE_DISABLED_COLOR)))
    end
end

--------------------------------------------------------------------------------
-- This event handler is called when touch.
-- @param e Touch Event
--------------------------------------------------------------------------------
function UIComponent:onTouchCommon(e)
    if not self:isComponentEnabled() then
        e:stop()
        return
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
-- It is a class that can have on a child UIComponent.
----------------------------------------------------------------------------------------------------
UIGroup = class(UIComponent)
M.UIGroup = UIGroup

--------------------------------------------------------------------------------
-- Initialization is the process of internal variables.
-- Please to inherit this function if the definition of the variable.
--------------------------------------------------------------------------------
function UIGroup:_initInternal()
    UIGroup.__super._initInternal(self)
    self.isUIGroup = true
    self._focusEnabled = false
end

--------------------------------------------------------------------------------
-- Adds the specified child.
-- @param child DisplayObject
--------------------------------------------------------------------------------
function UIGroup:addChild(child)
    if UIGroup.__super.addChild(self, child) then
        child:setPriority(self:getPriority())
        return true
    end
    return false
end

--------------------------------------------------------------------------------
-- Updates the display of child components.
--------------------------------------------------------------------------------
function UIGroup:updateDisplay()
    for i, child in ipairs(self:getChildren()) do
        if child.updateDisplay then
            child:updateDisplay()
        end
    end
end

----------------------------------------------------------------------------------------------------
-- @type UIView
-- This is a view class that displays the component.
-- Widgets to the root class view.
----------------------------------------------------------------------------------------------------
UIView = class(UIGroup)
M.UIView = UIView

UIView.PRIORITY_MARGIN = 100

--------------------------------------------------------------------------------
-- Initialization is the process of internal variables.
-- Please to inherit this function if the definition of the variable.
--------------------------------------------------------------------------------
function UIView:_initInternal()
    UIView.__super._initInternal(self)
    self.isUIView = true
    self._scene = nil
    self._lastPriority = 0
    
    self:_initLayer()
end

--------------------------------------------------------------------------------
-- Initializes the layer to display the view.
--------------------------------------------------------------------------------
function UIView:_initLayer()
    local layer = Layer()
    layer:setSortMode(MOAILayer.SORT_PRIORITY_ASCENDING)
    layer:setTouchEnabled(true)
    layer:addEventListener(Event.TOUCH_DOWN, self.onLayerTouchDown, self, 10)
    
    self:setSize(layer:getSize())
    self:setLayer(layer)
end

--------------------------------------------------------------------------------
-- Initializes the event listener.
--------------------------------------------------------------------------------
function UIView:_initEventListeners()
    UIView.__super._initEventListeners(self)
end

--------------------------------------------------------------------------------
-- Change the size of the viewport.
-- @param screenX X of the Screen.
-- @param screenY Y of the Screen.
-- @param screenWidth Width of the Screen.
-- @param screenHeight Height of the Screen.
--------------------------------------------------------------------------------
function UIView:updateViewport(screenX, screenY, screenWidth, screenHeight)
    local viewScale = flower.viewScale
    local viewWidth = screenWidth / viewScale
    local viewHeight = screenHeight / viewScale
    
    local viewport = MOAIViewport.new()
    viewport:setSize(screenX, screenY, screenX + screenWidth, screenY + screenHeight)
    viewport:setScale(viewWidth, -viewHeight)
    viewport:setOffset(-1, 1)

    self.layer:setViewport(viewport)
    self:setSize(viewWidth, viewHeight)
end

--------------------------------------------------------------------------------
-- Adds the specified child.
-- @param child DisplayObject
--------------------------------------------------------------------------------
function UIView:addChild(child)
    if UIView.__super.addChild(self, child) then
        self._lastPriority = self._lastPriority + UIView.PRIORITY_MARGIN
        child:setPriority(self._lastPriority)
        return true
    end
    return false
end

--------------------------------------------------------------------------------
-- Sets the visible to layer.
-- @param visible visible
--------------------------------------------------------------------------------
function UIView:setVisible(visible)
    self.layer:setVisible(visible)
end

--------------------------------------------------------------------------------
-- Returns the visible from layer.
-- @return visible
--------------------------------------------------------------------------------
function UIView:getVisible()
    self.layer:getVisible()
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

--- Style: textColor
Button.STYLE_TEXT_COLOR = "textColor"

--- Style: textAlign
Button.STYLE_TEXT_ALIGN = "textAlign"

--- Style: textPadding
Button.STYLE_TEXT_PADDING = "textPadding"

--------------------------------------------------------------------------------
-- Initializes the internal variables.
--------------------------------------------------------------------------------
function Button:_initInternal()
    Button.__super._initInternal(self)
    self._themeName = "Button"
    self._touchDownIdx = nil
    self._buttonImage = nil
    self._text = ""
    self._textLabel = nil
    self._selected = false
    self._toggle = false
end

--------------------------------------------------------------------------------
-- Initializes the event listener.
--------------------------------------------------------------------------------
function Button:_initEventListeners()
    Button.__super._initEventListeners(self)
    self:addEventListener(Event.RESIZE, self.onResize, self)
    self:addEventListener(Event.TOUCH_DOWN, self.onTouchDown, self)
    self:addEventListener(Event.TOUCH_UP, self.onTouchUp, self)
    self:addEventListener(Event.TOUCH_MOVE, self.onTouchMove, self)
    self:addEventListener(Event.TOUCH_CANCEL, self.onTouchCancel, self)
    self:addEventListener(UIEvent.SELECTED_CHANGED, self.onSelectedChanged, self)
end

--------------------------------------------------------------------------------
-- Create children.
--------------------------------------------------------------------------------
function Button:_createChildren()
    Button.__super._createChildren(self)
    
    self:_createButtonImage()
    self:_createTextLabel()
    
    if self._buttonImage then
        self:setSize(self._buttonImage:getSize())
    end
end

--------------------------------------------------------------------------------
-- Create the buttonImage.
--------------------------------------------------------------------------------
function Button:_createButtonImage()
    if self._buttonImage then
        return
    end
    local imagePath = assert(self:getImagePath())
    self._buttonImage = NineImage(imagePath)
    self:addChild(self._buttonImage)
end

--------------------------------------------------------------------------------
-- Create the textLabel.
--------------------------------------------------------------------------------
function Button:_createTextLabel()
    if self._textLabel then
        return
    end
    self._textLabel = Label(self._text)
    self:addChild(self._textLabel)
end

--------------------------------------------------------------------------------
-- Update the display.
--------------------------------------------------------------------------------
function Button:updateDisplay()
    self:updateButtonImage()
    self:updateTextLabel()
end

--------------------------------------------------------------------------------
-- Update the buttonImage.
--------------------------------------------------------------------------------
function Button:updateButtonImage()
    local buttonImage = self._buttonImage
    buttonImage:setImage(self:getImagePath())
    buttonImage:setSize(self:getSize())
end

--------------------------------------------------------------------------------
-- Update the buttonImage.
--------------------------------------------------------------------------------
function Button:updateTextLabel()
    if not self._textLabel then
        return
    end
    
    local textLabel = self._textLabel
    local text = self:getText()
    local xMin, yMin, xMax, yMax = self:getLabelContentRect()
    local textWidth, textHeight = xMax - xMin, yMax - yMin    
    textLabel:setSize(textWidth, textHeight)
    textLabel:setPos(xMin, yMin)
    textLabel:setString(text)
    textLabel:setReveal(text and #text or 0)
    textLabel:setTextSize(self:getTextSize())
    textLabel:setColor(self:getTextColor())
    textLabel:setAlignment(self:getAlignment())
    textLabel:setFont(self:getFont())
end

--------------------------------------------------------------------------------
-- Returns the image path.
-- @return imageDeck
--------------------------------------------------------------------------------
function Button:getImagePath()
    if not self:isEnabled() then
        return self:getStyle(Button.STYLE_DISABLED_TEXTURE)
    elseif self:isSelected() then
        return self:getStyle(Button.STYLE_SELECTED_TEXTURE)
    else
        return self:getStyle(Button.STYLE_NORMAL_TEXTURE)
    end
end

--------------------------------------------------------------------------------
-- Returns the label content rect.
-- @return content rect
--------------------------------------------------------------------------------
function Button:getLabelContentRect()
    local buttonImage = self._buttonImage
    local paddingLeft, paddingTop, paddingRight, paddingBottom = self:getTextPadding()
    if buttonImage.getContentRect then
        local xMin, yMin, xMax, yMax = buttonImage:getContentRect()
        return xMin + paddingLeft, yMin + paddingTop, xMax - paddingRight, yMax - paddingBottom
    else
        local xMin, yMin, xMax, yMax = 0, 0, buttonImage:getSize()
        return xMin + paddingLeft, yMin + paddingTop, xMax - paddingRight, yMax - paddingBottom
    end
end

--------------------------------------------------------------------------------
-- If the selected the button returns True.
-- @return If the selected the button returns True
--------------------------------------------------------------------------------
function Button:isSelected()
    return self._selected
end

--------------------------------------------------------------------------------
-- Sets the selected.
-- @param selected selected
--------------------------------------------------------------------------------
function Button:setSelected(selected)
    if self._selected == selected then
        return
    end
    
    self._selected = selected
    self:updateButtonImage()
    self:dispatchEvent(UIEvent.SELECTED_CHANGED, selected)
end

--------------------------------------------------------------------------------
-- Sets the toggle.
-- @param toggle toggle
--------------------------------------------------------------------------------
function Button:setToggle(toggle)
    self._toggle = toggle
end

--------------------------------------------------------------------------------
-- Returns the toggle.
-- @return toggle
--------------------------------------------------------------------------------
function Button:isToggle()
    return self._toggle
end

--------------------------------------------------------------------------------
-- Sets the normal texture.
-- @param texture texture
--------------------------------------------------------------------------------
function Button:setNormalTexture(texture)
    self:setStyle(Button.STYLE_NORMAL_TEXTURE, texture)
    if self._initialized then
        self:updateDisplay()
    end
end

--------------------------------------------------------------------------------
-- Sets the selected texture.
-- @param texture texture
--------------------------------------------------------------------------------
function Button:setSelectedTexture(texture)
    self:setStyle(Button.STYLE_SELECTED_TEXTURE, texture)
    if self._initialized then
        self:updateDisplay()
    end
end

--------------------------------------------------------------------------------
-- Sets the selected texture.
-- @param texture texture
--------------------------------------------------------------------------------
function Button:setDisabledTexture(texture)
    self:setStyle(Button.STYLE_DISABLED_TEXTURE, texture)
    if self._initialized then
        self:updateDisplay()
    end
end

--------------------------------------------------------------------------------
-- Sets the text.
-- @param text text
--------------------------------------------------------------------------------
function Button:setText(text)
    self._text = text
    self._textLabel:setString(text)
    self._textLabel:setReveal(self._text and #self._text or 0)
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
-- Sets the text color.
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
-- Sets the text padding.
-- @param paddingLeft padding left
-- @param paddingTop padding top
-- @param paddingRight padding right
-- @param paddingBottom padding bottom
--------------------------------------------------------------------------------
function Button:setTextPadding(paddingLeft, paddingTop, paddingRight, paddingBottom)
    local style = {paddingLeft or 0, paddingTop or 0, paddingRight or 0, paddingBottom or 0}
    self:setStyle(Button.STYLE_TEXT_PADDING, style)
    if self._initialized then
        self:updateTextLabel()
    end
end

--------------------------------------------------------------------------------
-- Returns the text padding.
-- @return paddingLeft
-- @return paddingTop
-- @return paddingRight
-- @return paddingBottom
--------------------------------------------------------------------------------
function Button:getTextPadding()
    local padding = self:getStyle(Button.STYLE_TEXT_PADDING)
    if padding then
        return unpack(padding)
    end
    return 0, 0, 0, 0
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
-- Set the event listener that is called when selected changed.
-- @param func selected changed event handler
--------------------------------------------------------------------------------
function Button:setOnSelectedChanged(func, obj)
    self:setEventListener(UIEvent.SELECTED_CHANGED, func)
end

--------------------------------------------------------------------------------
-- This event handler is called when enabled Changed.
-- @param e Touch Event
--------------------------------------------------------------------------------
function Button:onEnabledChanged(e)
    Button.__super.onEnabledChanged(self, e)
    self:updateButtonImage()
    
    if not self:isEnabled() and not self:isToggle() then
        self:setSelected(false)
    end
end

--------------------------------------------------------------------------------
-- This event handler is called when selected changed.
-- @param e Touch Event
--------------------------------------------------------------------------------
function Button:onSelectedChanged(e)
    if self:isSelected() then
        self:dispatchEvent(UIEvent.DOWN)
    else
        self:dispatchEvent(UIEvent.UP)
    end
end

--------------------------------------------------------------------------------
-- This event handler is called when resize.
-- @param e Touch Event
--------------------------------------------------------------------------------
function Button:onResize(e)
    self:updateDisplay()
end

--------------------------------------------------------------------------------
-- This event handler is called when you touch the button.
-- @param e Touch Event
--------------------------------------------------------------------------------
function Button:onTouchDown(e)
    if self._touchDownIdx ~= nil then
        return
    end
    self._touchDownIdx = e.idx
    
    if self:isToggle() then
        self._buttonImage:setColor(0.8, 0.8, 0.8, 1)
        return
    end
    
    if not self:isToggle() then
        self:setSelected(true)
    end
end

--------------------------------------------------------------------------------
-- This event handler is called when the button is released.
-- @param e Touch Event
--------------------------------------------------------------------------------
function Button:onTouchUp(e)
    if self._touchDownIdx ~= e.idx then
        return
    end
    self._touchDownIdx = nil
    
    if self:isToggle() then
        if self:inside(e.wx, e.wy, 0) then
            self:setSelected(not self:isSelected())
        end
        self._buttonImage:setColor(1, 1, 1, 1)
        return    
    end

    if self:isSelected() then
        self:setSelected(false)
        self:dispatchEvent(UIEvent.CLICK)
    else
        self:dispatchEvent(UIEvent.CANCEL)
    end
end

--------------------------------------------------------------------------------
-- This event handler is called when you move on the button.
-- @param e Touch Event
--------------------------------------------------------------------------------
function Button:onTouchMove(e)
    if self._touchDownIdx ~= e.idx then
        return
    end
    
    if self:isToggle() then
        return
    end
    
    self:setSelected(self:inside(e.wx, e.wy, 0))
    
end

--------------------------------------------------------------------------------
-- This event handler is called when you cancel the touch.
-- @param e Touch Event
--------------------------------------------------------------------------------
function Button:onTouchCancel(e)
    if self._touchDownIdx ~= e.idx then
        return
    end

    self._touchDownIdx = nil
    
    if self:isToggle() then
        self._buttonImage:setColor(1, 1, 1, 1)
        return
    end
    
   self:setSelected(false)
   self:dispatchEvent(UIEvent.CANCEL)
end


----------------------------------------------------------------------------------------------------
-- @type ImageButton
-- This class is an Image that can be pressed.
----------------------------------------------------------------------------------------------------
ImageButton = class(Button)
M.ImageButton = ImageButton

--------------------------------------------------------------------------------
-- Initializes the internal variables.
--------------------------------------------------------------------------------
function ImageButton:_initInternal()
    ImageButton.__super._initInternal(self)
    self._themeName = "ImageButton"
end

--------------------------------------------------------------------------------
-- Create the buttonImage.
--------------------------------------------------------------------------------
function ImageButton:_createButtonImage()
    if self._buttonImage then
        return
    end
    local imagePath = assert(self:getImagePath())
    self._buttonImage = Image(imagePath)
    self:addChild(self._buttonImage)
end

--------------------------------------------------------------------------------
-- Update the imageDeck.
--------------------------------------------------------------------------------
function ImageButton:updateButtonImage()
    local imagePath = assert(self:getImagePath())

    self._buttonImage:setTexture(imagePath)
    self:setSize(self._buttonImage:getSize())
end

----------------------------------------------------------------------------------------------------
-- @type SheetButton
-- This class is an SheetImage that can be pressed.
----------------------------------------------------------------------------------------------------
SheetButton = class(Button)
M.SheetButton = SheetButton

--- Style: textureSheets
SheetButton.STYLE_TEXTURE_SHEETS = "textureSheets"

--------------------------------------------------------------------------------
-- Initializes the internal variables.
--------------------------------------------------------------------------------
function SheetButton:_initInternal()
    SheetButton.__super._initInternal(self)
    self._themeName = "SheetButton"
end

--------------------------------------------------------------------------------
-- Create the buttonImage.
--------------------------------------------------------------------------------
function SheetButton:_createButtonImage()
    if self._buttonImage then
        return
    end
    
    local textureSheets = assert(self:getStyle(SheetButton.STYLE_TEXTURE_SHEETS))
    self._buttonImage = SheetImage(textureSheets .. ".png")
    self._buttonImage:setTextureAtlas(textureSheets .. ".lua")
    self:addChild(self._buttonImage)
end

--------------------------------------------------------------------------------
-- Update the buttonImage.
--------------------------------------------------------------------------------
function SheetButton:updateButtonImage()
    local imagePath = assert(self:getImagePath())

    self._buttonImage:setIndexByName(imagePath)
    self:setSize(self._buttonImage:getSize())
end

--------------------------------------------------------------------------------
-- Sets the sheet texture's file.
-- @param sheet texture
--------------------------------------------------------------------------------
function SheetButton:setTextureSheets(filename)
    self:setStyle(SheetButton.STYLE_TEXTURE_SHEETS, filename)
    self._buttonImage:setTextureAtlas(filename .. ".lua", filename .. ".png")
    self:updateButtonImage()
end

----------------------------------------------------------------------------------------------------
-- @type CheckBox
-- This class is an checkbox.
----------------------------------------------------------------------------------------------------
CheckBox = class(ImageButton)
M.CheckBox = CheckBox

--------------------------------------------------------------------------------
-- Initializes the internal variables.
--------------------------------------------------------------------------------
function CheckBox:_initInternal()
    CheckBox.__super._initInternal(self)
    self._themeName = "CheckBox"
    self._toggle = true
end

--------------------------------------------------------------------------------
-- Update the buttonImage.
--------------------------------------------------------------------------------
function CheckBox:updateButtonImage()
    local buttonImage = self._buttonImage
    buttonImage:setTexture(self:getImagePath())
end

--------------------------------------------------------------------------------
-- Returns the label content rect.
-- @return content rect
--------------------------------------------------------------------------------
function CheckBox:getLabelContentRect()
    local buttonImage = self._buttonImage
    local textLabel = self._textLabel
    local left, top = buttonImage:getRight(), buttonImage:getTop()
    local right, bottom = left + textLabel:getWidth(), top + buttonImage:getHeight()
    return left, top, right, bottom
end

--------------------------------------------------------------------------------
-- Update the textLabel.
--------------------------------------------------------------------------------
function CheckBox:updateTextLabel()
    CheckBox.__super.updateTextLabel(self)
    
    self._textLabel:fitWidth()
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
    Joystick.__super._initInternal(self)
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
    Joystick.__super._initEventListeners(self)
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
    Joystick.__super._createChildren(self)
    
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
-- It is the only class to display the panel.
----------------------------------------------------------------------------------------------------
Panel = class(UIComponent)
M.Panel = Panel

--- Style: backgroundTexture
Panel.STYLE_BACKGROUND_TEXTURE = "backgroundTexture"

--- Style: backgroundVisible
Panel.STYLE_BACKGROUND_VISIBLE = "backgroundVisible"

--------------------------------------------------------------------------------
-- Initializes the internal variables.
--------------------------------------------------------------------------------
function Panel:_initInternal()
    Panel.__super._initInternal(self)
    self._themeName = "Panel"
end

--------------------------------------------------------------------------------
-- Initialize the event listeners
--------------------------------------------------------------------------------
function Panel:_initEventListeners()
    Panel.__super._initEventListeners(self)
    self:addEventListener(UIEvent.RESIZE, self.onResize, self)
end

--------------------------------------------------------------------------------
-- Create a children object.
--------------------------------------------------------------------------------
function Panel:_createChildren()
    Panel.__super._createChildren(self)
    self:_createBackgroundImage()
end

--------------------------------------------------------------------------------
-- Create an image of the background
--------------------------------------------------------------------------------
function Panel:_createBackgroundImage()
    if self._backgroundImage then
        return
    end
    
    local texture = self:getBackgroundTexture()
    self._backgroundImage = NineImage(texture)
    self:addChild(self._backgroundImage)
end

--------------------------------------------------------------------------------
-- Update the display objects.
--------------------------------------------------------------------------------
function Panel:updateDisplay()
    Panel.__super.updateDisplay(self)
    self._backgroundImage:setImage(self:getBackgroundTexture())
    self._backgroundImage:setSize(self:getSize())
    self._backgroundImage:setVisible(self:getBackgroundVisible())
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
-- Sets the background texture path.
-- @param texture background texture path
--------------------------------------------------------------------------------
function Panel:setBackgroundVisible(visible)
    self:setStyle(Panel.STYLE_BACKGROUND_VISIBLE, visible)
    self._backgroundImage:setVisible(self:getBackgroundVisible())
end

--------------------------------------------------------------------------------
-- Returns the background texture path.
-- @param texture background texture path
--------------------------------------------------------------------------------
function Panel:getBackgroundVisible()
    local visible = self:getStyle(Panel.STYLE_BACKGROUND_VISIBLE)
    if visible ~= nil then
        return visible
    end
    return true
end

--------------------------------------------------------------------------------
-- This event handler is called when resize.
-- @param e Touch Event
--------------------------------------------------------------------------------
function Panel:onResize(e)
    self._backgroundImage:setImage(self:getBackgroundTexture())
    self._backgroundImage:setSize(self:getSize())
end

----------------------------------------------------------------------------------------------------
-- @type TextBox
-- It is a class that displays the text.
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
-- Initialize a variables
--------------------------------------------------------------------------------
function TextBox:_initInternal()
    TextBox.__super._initInternal(self)
    self._themeName = "TextBox"
    self._text = ""
    self._textLabel = nil
end

--------------------------------------------------------------------------------
-- Create a children object.
--------------------------------------------------------------------------------
function TextBox:_createChildren()
    TextBox.__super._createChildren(self)
    
    self._textLabel = Label(self._text, 100, 30)
    self._textLabel:setWordBreak(MOAITextBox.WORD_BREAK_CHAR)
    self:addChild(self._textLabel)
end

--------------------------------------------------------------------------------
-- Update the display objects.
--------------------------------------------------------------------------------
function TextBox:updateDisplay()
    TextBox.__super.updateDisplay(self)

    local textLabel = self._textLabel
    local xMin, yMin, xMax, yMax = self._backgroundImage:getContentRect()
    local textWidth, textHeight = xMax - xMin, yMax - yMin    
    textLabel:setSize(textWidth, textHeight)
    textLabel:setPos(xMin, yMin)
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
    TextBox.__super.onResize(self, e)
    
    local textLabel = self._textLabel
    local xMin, yMin, xMax, yMax = self._backgroundImage:getContentRect()
    local textWidth, textHeight = xMax - xMin, yMax - yMin
    textLabel:setSize(textWidth, textHeight)
    textLabel:setPos(xMin, yMin)
end

--------------------------------------------------------------------------------
-- Set textbox padding by label's setRect method, it will set 4 direction padding
-- @param padding pixecls
--------------------------------------------------------------------------------
function TextBox:setPadding(padding)
    if self._textLabel then
        local x1, y1, x2, y2 = self._textLabel:getRect()
        self._textLabel:setRect(x1 + padding, y1 + padding, x2 - padding, y2 - padding)
    end
end

--------------------------------------------------------------------------------
-- Set textbox padding-top by label's setRect method
-- @param padding pixecls
--------------------------------------------------------------------------------
function TextBox:setPaddingTop(padding)
    if self._textLabel then
        local x1, y1, x2, y2 = self._textLabel:getRect()
        self._textLabel:setRect(x1, padding, x2, y2)
    end
end

----------------------------------------------------------------------------------------------------
-- @type TextInput
-- This class is a line of text can be entered.
-- Does not correspond to a multi-line input.
----------------------------------------------------------------------------------------------------
TextInput = class(TextBox)
M.TextInput = TextInput

--- Style: focusTexture
TextInput.STYLE_FOCUS_TEXTURE = "focusTexture"

--------------------------------------------------------------------------------
-- Initialize a variables
--------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------
-- Initialize the event listeners.
--------------------------------------------------------------------------------
function TextInput:_initEventListeners()
    TextInput.__super._initEventListeners(self)
end

--------------------------------------------------------------------------------
-- Create the children.
--------------------------------------------------------------------------------
function TextInput:_createChildren()
    TextInput.__super._createChildren(self)
    
    self._textAllow = Rect(1, self:getTextSize())
    self._textAllow:setColor(0, 0, 0, 1)
    self._textAllow:setVisible(false)
    self:addChild(self._textAllow)
end

--------------------------------------------------------------------------------
-- Draw the focus object.
--------------------------------------------------------------------------------
function TextInput:drawFocus(focus)
    TextInput.__super.drawFocus(self, focus)
    self._backgroundImage:setImage(self:getBackgroundTexture())
    self:drawTextAllow()
end

--------------------------------------------------------------------------------
-- Draw an arrow in the text.
--------------------------------------------------------------------------------
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
    return TextInput.__super.getBackgroundTexture(self)
end

--------------------------------------------------------------------------------
-- This event handler is called when focus in.
-- @param e event
--------------------------------------------------------------------------------
function TextInput:onFocusIn(e)
    TextInput.__super.onFocusIn(self, e)
    
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
    TextInput.__super.onFocusOut(self, e)

    if MOAIKeyboard and MOAIKeyboard.hideKeyboard then
        MOAIKeyboard.hideKeyboard()
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
-- It is a class that displays the message.
-- Displays the next page of the message when selected.
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
    MsgBox.__super._initInternal(self)
    self._themeName = "MsgBox"
    self._popupShowing = false
    self._spoolingEnabled = true
    
    -- TODO: inherit visibility
    self:setColor(0, 0, 0, 0)
end

--------------------------------------------------------------------------------
-- Initialize the event listeners.
--------------------------------------------------------------------------------
function MsgBox:_initEventListeners()
    MsgBox.__super._initEventListeners(self)
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
-- Return true if showing.
-- @return true if showing
--------------------------------------------------------------------------------
function MsgBox:isPopupShowing()
    return self._popupShowing
end

--------------------------------------------------------------------------------
-- Return true if textLabel is busy.
--------------------------------------------------------------------------------
function MsgBox:isSpooling()
    return self._textLabel:isBusy()
end

--------------------------------------------------------------------------------
-- Returns true if there is a next page.
-- @return True if there is a next page
--------------------------------------------------------------------------------
function MsgBox:hasNextPase()
    return self._textLabel:more()
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
-- It is a class that displays multiple items.
-- You can choose to scroll through the items.
----------------------------------------------------------------------------------------------------
ListBox = class(Panel)
M.ListBox = ListBox

--- Style: listItemFactory
ListBox.STYLE_LIST_ITEM_FACTORY = "listItemFactory"

--- Style: rowHeight
ListBox.STYLE_ROW_HEIGHT = "rowHeight"

--------------------------------------------------------------------------------
-- Initialize a variables
--------------------------------------------------------------------------------
function ListBox:_initInternal()
    ListBox.__super._initInternal(self)
    self._themeName = "ListBox"
    self._listItems = {}
    self._listData = {}
    self._freeListItems = {}
    self._selectedIndex = nil
    self._rowCount = 5
    self._columnCount = 1
    self._verticalScrollPosition = 0
end

--------------------------------------------------------------------------------
-- Initialize the event listeners.
--------------------------------------------------------------------------------
function ListBox:_initEventListeners()
    ListBox.__super._initEventListeners(self)
    self:addEventListener(Event.TOUCH_DOWN, self.onTouchDown, self)
    self:addEventListener(Event.TOUCH_UP, self.onTouchUp, self)
    self:addEventListener(Event.TOUCH_MOVE, self.onTouchMove, self)
    self:addEventListener(Event.TOUCH_CANCEL, self.onTouchCancel, self)
end

--------------------------------------------------------------------------------
-- Create the children.
--------------------------------------------------------------------------------
function ListBox:_createChildren()
    ListBox.__super._createChildren(self)
end

--------------------------------------------------------------------------------
-- Create the ListItem.
-- @param index index of the listItems
-- @return listItem
--------------------------------------------------------------------------------
function ListBox:_createListItem(index)
    if not self._listItems[index] then
        local factory = self:getListItemFactory()
        local freeItems = self._freeListItems
        local listItem = #freeItems > 0 and table.remove(freeItems, 1) or factory:newInstance()
        self:addChild(listItem)
        self._listItems[index] = listItem
    end

    local vsp = self:getVerticalScrollPosition()
    local colCount = self:getColumnCount()
    local xMin, yMin, xMax, yMax = self._backgroundImage:getContentRect()
    local itemWidth = (xMax - xMin) / colCount
    local itemHeight = self:getRowHeight()
    local itemX = xMin + itemWidth * ((index - 1) % colCount)
    local itemY = yMin + (math.floor((index - 1) / colCount) - vsp) * itemHeight

    local listItem = self._listItems[index]
    listItem:setData(self._listData[index], index)
    listItem:setSize(itemWidth, itemHeight)
    listItem:setPos(itemX, itemY)
    listItem:setSelected(index == self._selectedIndex)
    
    return listItem
end

--------------------------------------------------------------------------------
-- Delete the ListItem.
-- @param index index of the listItems
--------------------------------------------------------------------------------
function ListBox:_deleteListItem(index)
    local listItem = self._listItems[index]
    if listItem then
        listItem:setSelected(false)
        self:removeChild(listItem)
        table.insert(self._freeListItems, listItem)
        self._listItems[index] = nil
    end
end

--------------------------------------------------------------------------------
-- Clears the ListItems.
--------------------------------------------------------------------------------
function ListBox:_clearListItems()
    for i = 1, #self._listItems do
        self:_deleteListItem(i)
    end
    self._freeListItems = {}
end

--------------------------------------------------------------------------------
-- Update the display.
--------------------------------------------------------------------------------
function ListBox:updateDisplay()
    ListBox.__super.updateDisplay(self)
    
    -- listItems
    local vsp = self:getVerticalScrollPosition()
    local rowCount = self:getRowCount()
    local colCount = self:getColumnCount()
    local minIndex = vsp * colCount + 1
    local maxIndex = vsp * colCount + rowCount * colCount
    local listSize = self:getListSize()
    for i = 1, listSize do
        if i < minIndex or maxIndex < i then
            self:_deleteListItem(i)
        else
            self:_createListItem(i)
        end
    end
end

--------------------------------------------------------------------------------
-- Update the size by rowCount.
--------------------------------------------------------------------------------
function ListBox:updateSize()
    local rowCount = self:getRowCount()
    local rowHeight = self:getRowHeight()
    local pLeft, pTop, pRight, pBottom = self._backgroundImage:getContentPadding()
    
    self:setHeight(rowCount * rowHeight + pTop + pBottom)
end

--------------------------------------------------------------------------------
-- Sets the list data.
-- @param listData listData
--------------------------------------------------------------------------------
function ListBox:setListData(listData)
    self._listData = listData or {}
    self:_clearListItems()
    self:updateDisplay()
end

--------------------------------------------------------------------------------
-- Returns the list data.
-- @return listData
--------------------------------------------------------------------------------
function ListBox:getListData()
    return self._listData
end

--------------------------------------------------------------------------------
-- Returns the list size.
-- @return size
--------------------------------------------------------------------------------
function ListBox:getListSize()
    return #self._listData
end

--------------------------------------------------------------------------------
-- Returns the ListItems.
-- Care must be taken to use the ListItems.
-- ListItems is used to cache internally rotate.
-- Therefore, ListItems should not be accessed from outside too.
-- @return listItems
--------------------------------------------------------------------------------
function ListBox:getListItems()
    return self._listItems
end

--------------------------------------------------------------------------------
-- Returns the ListItem.
-- @param index index of the listItems
-- @return listItem
--------------------------------------------------------------------------------
function ListBox:getListItemAt(index)
    return self._listItems[index]
end

--------------------------------------------------------------------------------
-- Sets the ListItemFactory.
-- @param factory ListItemFactory
--------------------------------------------------------------------------------
function ListBox:setListItemFactory(factory)
    self:setStyle(ListBox.STYLE_LIST_ITEM_FACTORY, factory)
    self:_clearListItems()
    self:updateDisplay()
end

--------------------------------------------------------------------------------
-- Returns the ListItemFactory.
-- @return ListItemFactory
--------------------------------------------------------------------------------
function ListBox:getListItemFactory()
    return self:getStyle(ListBox.STYLE_LIST_ITEM_FACTORY)
end

--------------------------------------------------------------------------------
-- Sets the selectedIndex.
-- @param index selectedIndex
--------------------------------------------------------------------------------
function ListBox:setSelectedIndex(index)
    if index == self._selectedIndex then
        return
    end
    
    local oldItem = self:getSelectedItem()
    if oldItem then
        oldItem:setSelected(false)
    end

    self._selectedIndex = index
    
    local newItem = self:getSelectedItem()
    if newItem then
        newItem:setSelected(true)
    end
    
    local data = newItem and  newItem:getData() or nil
    self:dispatchEvent(UIEvent.ITEM_CHANGED, data)
end

--------------------------------------------------------------------------------
-- Returns the selectedIndex.
-- @return selectedIndex
--------------------------------------------------------------------------------
function ListBox:getSelectedIndex()
    return self._selectedIndex
end

--------------------------------------------------------------------------------
-- Set the selected item.
-- @param item selected item
--------------------------------------------------------------------------------
function ListBox:setSelectedItem(item)
    if item then
        self:setSelectedIndex(item:getDataIndex())
    else
        self:setSelectedIndex(nil)
    end
end

--------------------------------------------------------------------------------
-- Return the selected item.
-- @return selected item
--------------------------------------------------------------------------------
function ListBox:getSelectedItem()
    if self._selectedIndex then
        return self._listItems[self._selectedIndex]
    end
end

--------------------------------------------------------------------------------
-- Set the labelField.
-- @param labelField labelField
--------------------------------------------------------------------------------
function ListBox:setLabelField(labelField)
    self._labelField = labelField
    self:updateDisplay()
end

--------------------------------------------------------------------------------
-- Return the labelField.
-- @return labelField
--------------------------------------------------------------------------------
function ListBox:getLabelField()
    return self._labelField
end

--------------------------------------------------------------------------------
-- Set the verticalScrollPosition.
-- @param pos verticalScrollPosition
--------------------------------------------------------------------------------
function ListBox:setVerticalScrollPosition(pos)
    if self._verticalScrollPosition == pos then
        return
    end
    self._verticalScrollPosition = math.max(0, math.min(self:getMaxVerticalScrollPosition(), pos))
    self:updateDisplay()
end

--------------------------------------------------------------------------------
-- Return the verticalScrollPosition.
-- @return verticalScrollPosition
--------------------------------------------------------------------------------
function ListBox:getVerticalScrollPosition()
    return self._verticalScrollPosition
end

--------------------------------------------------------------------------------
-- Return the maxVerticalScrollPosition.
-- @return maxVerticalScrollPosition
--------------------------------------------------------------------------------
function ListBox:getMaxVerticalScrollPosition()
    return math.max(math.floor(self:getListSize() / self:getColumnCount()) - self:getRowCount(), 0)
end

--------------------------------------------------------------------------------
-- Set the height of the row.
-- @param rowHeight height of the row
--------------------------------------------------------------------------------
function ListBox:setRowHeight(rowHeight)
    self:setStyle(ListBox.STYLE_ROW_HEIGHT, rowHeight)
    self:updateDisplay()
end

--------------------------------------------------------------------------------
-- Return the height of the row.
-- @return rowHeight
--------------------------------------------------------------------------------
function ListBox:getRowHeight()
    return self:getStyle(ListBox.STYLE_ROW_HEIGHT)
end

--------------------------------------------------------------------------------
-- Set the count of the rows.
-- @param rowCount count of the rows
--------------------------------------------------------------------------------
function ListBox:setRowCount(rowCount)
    self._rowCount = rowCount
    self:updateSize()
    self:updateDisplay()
end

--------------------------------------------------------------------------------
-- Return the count of the rows.
-- @return rowCount
--------------------------------------------------------------------------------
function ListBox:getRowCount()
    return self._rowCount
end

--------------------------------------------------------------------------------
-- Set the count of the columns.
-- @param columnCount count of the columns
--------------------------------------------------------------------------------
function ListBox:setColumnCount(columnCount)
    assert(columnCount >= 1, "columnCount property error!")
    
    self._columnCount = columnCount
    self:updateDisplay()
end

--------------------------------------------------------------------------------
-- Return the count of the columns.
-- @return columnCount
--------------------------------------------------------------------------------
function ListBox:getColumnCount()
    return self._columnCount
end

--------------------------------------------------------------------------------
-- Returns true if the component has been touched.
-- @return touching
--------------------------------------------------------------------------------
function ListBox:isTouching()
    return self._touchedIndex ~= nil
end

--------------------------------------------------------------------------------
-- Set the event listener that is called when the user item changed.
-- @param func event handler
--------------------------------------------------------------------------------
function ListBox:setOnItemChanged(func)
    self:setEventListener(UIEvent.ITEM_CHANGED, func)
end

--------------------------------------------------------------------------------
-- Set the event listener that is called when the user item changed.
-- @param func event handler
--------------------------------------------------------------------------------
function ListBox:setOnItemEnter(func)
    self:setEventListener(UIEvent.ITEM_ENTER, func)
end

--------------------------------------------------------------------------------
-- This event handler is called when touch.
-- @param e Touch Event
--------------------------------------------------------------------------------
function ListBox:onTouchDown(e)
    if self._touchedIndex ~= nil and self._touchedIndex ~= e.idx then
        return
    end
    self._touchedIndex = e.idx
    self._touchedY = e.wy
    self._touchedVsp = self:getVerticalScrollPosition()
end

--------------------------------------------------------------------------------
-- This event handler is called when touch.
-- @param e Touch Event
--------------------------------------------------------------------------------
function ListBox:onTouchUp(e)
    if self._touchedIndex ~= e.idx then
        return
    end
    self._touchedIndex = nil
    self._touchedY = nil
    self._touchedVsp = nil
end

--------------------------------------------------------------------------------
-- This event handler is called when touch.
-- @param e Touch Event
--------------------------------------------------------------------------------
function ListBox:onTouchMove(e)
    if self._touchedIndex ~= e.idx then
        return
    end
    local rowHeight = self:getRowHeight()
    local delta = self._touchedY - e.wy
    local vsp = self._touchedVsp + math.floor(delta / rowHeight)
    self:setVerticalScrollPosition(vsp)
end


--------------------------------------------------------------------------------
-- This event handler is called when touch.
-- @param e Touch Event
--------------------------------------------------------------------------------
function ListBox:onTouchCancel(e)
    self:onTouchUp(e)
end

--------------------------------------------------------------------------------
-- This event handler is called when resize.
-- @param e Event
--------------------------------------------------------------------------------
function ListBox:onResize(e)
    ListBox.__super.onResize(self, e)
    
    local xMin, yMin, xMax, yMax = self._backgroundImage:getContentRect()
    local contentWidth, contentHeight = xMax - xMin, yMax - yMin    
    local rowHeight = self:getRowHeight()
    self._rowCount = math.floor(contentHeight / rowHeight)
    self:updateDisplay()
end


----------------------------------------------------------------------------------------------------
-- @type ListItem
-- It is the item class ListBox.
-- Used from the ListBox.
----------------------------------------------------------------------------------------------------
ListItem = class(TextBox)
M.ListItem = ListItem

--------------------------------------------------------------------------------
-- Initialize a variables
--------------------------------------------------------------------------------
function ListItem:_initInternal()
    ListItem.__super._initInternal(self)
    self._themeName = "ListItem"
    self._data = nil
    self._dataIndex = nil
    self._focusEnabled = false
    self._selected = false
end

--------------------------------------------------------------------------------
-- Initialize the event listeners.
--------------------------------------------------------------------------------
function ListItem:_initEventListeners()
    ListItem.__super._initEventListeners(self)
    self:addEventListener(Event.TOUCH_DOWN, self.onTouchDown, self)
end

--------------------------------------------------------------------------------
-- Create the children.
--------------------------------------------------------------------------------
function ListItem:_createChildren()
    ListItem.__super._createChildren(self)
end

--------------------------------------------------------------------------------
-- Set the data and rowIndex.
-- @param data data
-- @param dataIndex index of the data
--------------------------------------------------------------------------------
function ListItem:setData(data, dataIndex)
    self._data = data
    self._dataIndex = dataIndex

    local textLabel = self._textLabel
    textLabel:setString(self:getText())
end

--------------------------------------------------------------------------------
-- Return the data.
-- @return data
--------------------------------------------------------------------------------
function ListItem:getData()
    return self._data
end

--------------------------------------------------------------------------------
-- Return the data index.
-- @return data index
--------------------------------------------------------------------------------
function ListItem:getDataIndex()
    return self._dataIndex
end

--------------------------------------------------------------------------------
-- Set the selected.
--------------------------------------------------------------------------------
function ListItem:setSelected(selected)
    self._selected = selected
    self:setBackgroundVisible(selected)
end

--------------------------------------------------------------------------------
-- Returns true if selected.
-- @return true if selected
--------------------------------------------------------------------------------
function ListItem:isSelected()
    return self._selected
end

--------------------------------------------------------------------------------
-- Returns the text.
-- @return text
--------------------------------------------------------------------------------
function ListItem:getText()
    local data = self._data
    if data then
        local labelField = self:getLabelField()
        local text = labelField and data[labelField] or tostring(data)
        return text or ""
    else
        return ""
    end
end

--------------------------------------------------------------------------------
-- Returns the labelField.
-- @return labelField
--------------------------------------------------------------------------------
function ListItem:getLabelField()
    if self.parent then
        return self.parent:getLabelField()
    end
end

--------------------------------------------------------------------------------
-- The event handler is called when you touch the ListItem.
-- @param e Touch event
--------------------------------------------------------------------------------
function ListItem:onTouchDown(e)
    local listBox = self.parent
    if self:isSelected() then
        listBox:dispatchEvent(UIEvent.ITEM_ENTER, self._data)
    else
        listBox:setSelectedItem(self)
    end
end

----------------------------------------------------------------------------------------------------
-- @type Slider
-- This class is an slider that can be pressed and dragged.
----------------------------------------------------------------------------------------------------
Slider = class(UIComponent)
M.Slider = Slider

--- Style: backgroundTexture
Slider.STYLE_BACKGROUND_TEXTURE = "backgroundTexture"

--- Style: progressTexture
Slider.STYLE_PROGRESS_TEXTURE = "progressTexture"

--- Style: thumbTexture
Slider.STYLE_THUMB_TEXTURE = "thumbTexture"

--------------------------------------------------------------------------------
-- Initializes the internal variables.
--------------------------------------------------------------------------------
function Slider:_initInternal()
    Slider.__super._initInternal(self)
    self._themeName = "Slider"
    self._touchDownIdx = nil
    self._backgroundImage = nil
    self._progressImage = nil
    self._thumbImage = nil
    self._minValue = 0.0
    self._maxValue = 1.0
    self._currValue = 0.4
end

--------------------------------------------------------------------------------
-- Initializes the event listener.
--------------------------------------------------------------------------------
function Slider:_initEventListeners()
    Slider.__super._initEventListeners(self)
    self:addEventListener(Event.RESIZE, self.onResize, self)
    self:addEventListener(Event.TOUCH_DOWN, self.onTouchDown, self)
    self:addEventListener(Event.TOUCH_UP, self.onTouchUp, self)
    self:addEventListener(Event.TOUCH_MOVE, self.onTouchMove, self)
    self:addEventListener(Event.TOUCH_CANCEL, self.onTouchCancel, self)
end

--------------------------------------------------------------------------------
-- Create children.
--------------------------------------------------------------------------------
function Slider:_createChildren()
    Slider.__super._createChildren(self)
    self:_createBackgroundImage()
    self:_createProgressImage()
    self:_createThumbImage()
end

--------------------------------------------------------------------------------
-- Create the backgroundImage.
--------------------------------------------------------------------------------
function Slider:_createBackgroundImage()
    if self._backgroundImage then
        return
    end
    self._backgroundImage = NineImage(self:getStyle(Slider.STYLE_BACKGROUND_TEXTURE))
    self:addChild(self._backgroundImage)
end

--------------------------------------------------------------------------------
-- Create the progressImage.
--------------------------------------------------------------------------------
function Slider:_createProgressImage()
    if self._progressImage then
        return
    end
    self._progressImage = NineImage(self:getStyle(Slider.STYLE_PROGRESS_TEXTURE))
    self:addChild(self._progressImage)
end

--------------------------------------------------------------------------------
-- Create the progressImage.
--------------------------------------------------------------------------------
function Slider:_createThumbImage()
    if self._thumbImage then
        return
    end
    self._thumbImage = Image(self:getStyle(Slider.STYLE_THUMB_TEXTURE))
    self:addChild(self._thumbImage)
end

--------------------------------------------------------------------------------
-- Update the display.
--------------------------------------------------------------------------------
function Slider:updateDisplay()
    Slider.__super.updateDisplay(self)
    self:updateBackgroundImage()
    self:updateProgressImage()
end

--------------------------------------------------------------------------------
-- Update the backgroundImage.
--------------------------------------------------------------------------------
function Slider:updateBackgroundImage()
    local width = self:getWidth()
    local height = self._backgroundImage:getHeight()
    self._backgroundImage:setSize(width, height)
end

--------------------------------------------------------------------------------
-- Update the progressImage.
--------------------------------------------------------------------------------
function Slider:updateProgressImage()
    local width = self:getWidth()
    local height = self._progressImage:getHeight()
    self._progressImage:setSize(width * (self._currValue / self._maxValue), height)
    self._thumbImage:setLoc(width * (self._currValue / self._maxValue), height / 2)
end

--------------------------------------------------------------------------------
-- Set the value of the current.
-- @param value value of the current
--------------------------------------------------------------------------------
function Slider:setValue(value)
    if self._currValue == value then
        return
    end
    
    self._currValue = value
    self:updateProgressImage()
    self:dispatchEvent(UIEvent.VALUE_CHANGED, self._currValue)
end

--------------------------------------------------------------------------------
-- Return the value of the current.
-- @return value of the current
--------------------------------------------------------------------------------
function Slider:getValue()
    return self._currValue
end

--------------------------------------------------------------------------------
-- Sets the background texture.
-- @param texture texture
--------------------------------------------------------------------------------
function Slider:setBackgroundTexture(texture)
    self:setStyle(Slider.STYLE_BACKGROUND_TEXTURE, texture)
    self._backgroundImage:setImage(self:getStyle(Slider.STYLE_BACKGROUND_TEXTURE))
end

--------------------------------------------------------------------------------
-- Sets the progress texture.
-- @param texture texture
--------------------------------------------------------------------------------
function Slider:setProgressTexture(texture)
    self:setStyle(Slider.STYLE_PROGRESS_TEXTURE, texture)
    self._progressImage:setImage(self:getStyle(Slider.STYLE_PROGRESS_TEXTURE))
end

--------------------------------------------------------------------------------
-- Sets the thumb texture.
-- @param texture texture
--------------------------------------------------------------------------------
function Slider:setThumbTexture(texture)
    self:setStyle(Slider.STYLE_THUMB_TEXTURE, texture)
    self._thumbImage:setTexture(self:getStyle(Slider.STYLE_THUMB_TEXTURE))
end

--------------------------------------------------------------------------------
-- Set the event listener that is called when the user click the Slider.
-- @param func click event handler
--------------------------------------------------------------------------------
function Slider:setOnValueChanged(func)
    self:setEventListener(UIEvent.VALUE_CHANGED, func)
end

--------------------------------------------------------------------------------
-- Down the Slider.
-- There is no need to call directly to the basic.
-- @param idx Touch index
--------------------------------------------------------------------------------
function Slider:doSlide(worldX)
    local width = self:getWidth()
    local left = self:getLeft()
    local modelX = worldX - left
    
    modelX = math.min(modelX, width)
    modelX = math.max(modelX, 0)
    self:setValue(modelX / width)
end

--------------------------------------------------------------------------------
-- This event handler is called when resize.
-- @param e Touch Event
--------------------------------------------------------------------------------
function Slider:onResize(e)
    self:updateDisplay()
end

--------------------------------------------------------------------------------
-- This event handler is called when you touch the Slider.
-- @param e Touch Event
--------------------------------------------------------------------------------
function Slider:onTouchDown(e)
    if self._touchDownIdx then
        return
    end
    
    self._touchDownIdx = e.idx
    self:doSlide(e.wx)
end

--------------------------------------------------------------------------------
-- This event handler is called when the Slider is released.
-- @param e Touch Event
--------------------------------------------------------------------------------
function Slider:onTouchUp(e)
    if self._touchDownIdx ~= e.idx then
        return
    end
    self._touchDownIdx = nil
    self:doSlide(e.wx)
end

--------------------------------------------------------------------------------
-- This event handler is called when you move on the Slider.
-- @param e Touch Event
--------------------------------------------------------------------------------
function Slider:onTouchMove(e)
    if self._touchDownIdx ~= e.idx then
        return
    end
    if self:inside(e.wx, e.wy, 0) then
        self:doSlide(e.wx)
    end
end

--------------------------------------------------------------------------------
-- This event handler is called when you cancel the touch.
-- @param e Touch Event
--------------------------------------------------------------------------------
function Slider:onTouchCancel(e)
    if self._touchDownIdx ~= e.idx then
        return
    end
    self._touchDownIdx = nil
    self:doSlide(e.wx)
end

-- widget initialize
M.initialize()

return M
