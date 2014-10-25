----------------------------------------------------------------------------------------------------
-- This is a library to build an advanced widget.
-- There are still some problems.
--
-- TODO:TextInput does not support multi-byte.
-- TODO:TextInput can not move the cursor.
--
-- @author Makoto
-- @release V2.1.2
----------------------------------------------------------------------------------------------------

-- module
local M = {}

-- import
local flower = require "flower"
local class = flower.class
local table = flower.table
local math = flower.math
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
local LayoutMgr
local IconMgr
local TextAlign
local KeyCode
local UIEvent
local UIComponent
local UIGroup
local UIView
local UILayout
local BoxLayout
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
local Slider
local ScrollView

----------------------------------------------------------------------------------------------------
-- Public Const
----------------------------------------------------------------------------------------------------

--- Fixed a bug where the position of the MOAI SDK V1.4p0 does not reflect.(Last build fixed)
M.USE_TRANSFORM_BUGFIX = false

----------------------------------------------------------------------------------------------------
-- Public functions
----------------------------------------------------------------------------------------------------

---
-- Initializes the library.
-- They are initialized when you request the module.
function M.initialize()
    if M.initialized then
        return
    end

    M.themeMgr = ThemeMgr()
    M.focusMgr = FocusMgr()
    M.layoutMgr = LayoutMgr()
    M.iconMgr = IconMgr()

    M.initialized = true
end

---
-- Set the theme of widget.
-- TODO:Theme can be changed dynamically
-- @param theme theme of widget
function M.setTheme(theme)
    M.themeMgr:setTheme(theme)
end

---
-- Return the theme of widget.
-- @return theme
function M.getTheme()
    return M.themeMgr:getTheme()
end

---
-- Return the ThemeMgr.
-- @return themeMgr
function M.getThemeMgr()
    return M.themeMgr
end

---
-- Return the FocusMgr.
-- @return focusMgr
function M.getFocusMgr()
    return M.focusMgr
end

---
-- Return the LayoutMgr.
-- @return LayoutMgr
function M.getLayoutMgr()
    return M.layoutMgr
end

---
-- Return the IconMgr.
-- @return IconMgr
function M.getIconMgr()
    return M.iconMgr
end

---
-- This class is an dialog or IOS and Android.
-- @param ... title, message, positive, neutral, negative, cancelable, callback
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

---
-- Constructor.
function ThemeMgr:init()
    ThemeMgr.__super.init(self)
    self.theme = nil
end

---
-- Set the theme of widget.
-- @param theme theme of widget
function ThemeMgr:setTheme(theme)
    if self.theme ~= theme then
        self.theme = theme
        self:dispatchEvent(UIEvent.THEME_CHANGED)
    end
end

---
-- Return the theme of widget.
-- @return theme
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

---
-- Constructor.
function FocusMgr:init()
    FocusMgr.__super.init(self)
    self.focusObject = nil
end

---
-- Set the focus object.
-- @param object focus object.
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

---
-- Return the focus object.
-- @return focus object.
function FocusMgr:getFocusObject()
    return self.focusObject
end


----------------------------------------------------------------------------------------------------
-- @type LayoutMgr
-- This is a class to manage the layout of the widget.
-- Please get an instance from the widget module.
----------------------------------------------------------------------------------------------------
LayoutMgr = class(EventDispatcher)
M.LayoutMgr = LayoutMgr

---
-- Constructor.
function LayoutMgr:init()
    LayoutMgr.__super.init(self)
    self._invalidateDisplayQueue = {}
    self._invalidateLayoutQueue = {}
    self._invalidateViews = {}
    self._invalidating = false
end

---
-- Invalidate the display of the component.
-- @param component component
function LayoutMgr:invalidateDisplay(component)
    table.insertElement(self._invalidateDisplayQueue, component)

    if not self._invalidating then
        Executors.callOnce(self.validateAll, self)
        self._invalidating = true
    end
end

---
-- Invalidate the layout of the component.
-- @param component component
function LayoutMgr:invalidateLayout(component)
    table.insertElement(self._invalidateLayoutQueue, component)

    if component.isUIView then
        table.insertElement(self._invalidateViews, component)
    end

    if not self._invalidating then
        Executors.callOnce(self.validateAll, self)
        self._invalidating = true
    end
end

---
-- Validate the all components.
function LayoutMgr:validateAll()
    self:validateDisplay()
    self:validateLayout()

    if #self._invalidateDisplayQueue > 0 or #self._invalidateLayoutQueue > 0 then
        self:validateAll()
        return
    end

    self:validatePriority()

    self._invalidating = false
    self:dispatchEvent(Event.COMPLETE)

end

---
-- Validate the display of the all components.
function LayoutMgr:validateDisplay()
    local component = table.remove(self._invalidateDisplayQueue, #self._invalidateDisplayQueue)
    while component do
        component:validateDisplay()
        component = table.remove(self._invalidateDisplayQueue, #self._invalidateDisplayQueue)
    end
end

---
-- Validate the layout of the all components.
function LayoutMgr:validateLayout()
    local component = table.remove(self._invalidateLayoutQueue, #self._invalidateLayoutQueue)
    while component do
        component:validateLayout()
        component = table.remove(self._invalidateLayoutQueue, #self._invalidateLayoutQueue)
    end
end

---
-- Validate the priority of the views.
function LayoutMgr:validatePriority()
    local view = table.remove(self._invalidateViews, #self._invalidateViews)
    while view do
        view:updatePriority()
        view = table.remove(self._invalidateViews, #self._invalidateViews)
    end
end

----------------------------------------------------------------------------------------------------
-- @type IconMgr
-- This is a class to manage the layout of the widget.
-- Please get an instance from the widget module.
----------------------------------------------------------------------------------------------------
IconMgr = class()
M.IconMgr = IconMgr

---
-- Constructor.
function IconMgr:init()
    self._iconTextureInfos = {}
    self:addIconTexture("skins/icons.png", 24, 24)
end

function IconMgr:addIconTexture(textureName, tileWidth, tileHeight)
    local iconInfo = {}
    local texture = Resources.getTexture(textureName)
    local textureW, textureH = texture:getSize()
    iconInfo.texture = texture
    iconInfo.tileWidth = tileWidth
    iconInfo.tileHeight = tileHeight
    iconInfo.iconSize = math.floor(textureW / tileWidth) * math.floor(textureH / tileHeight)

    table.insertElement(self._iconTextureInfos, iconInfo)
end

function IconMgr:createIconImage(iconNo)
    local curIconNo = 0
    for i, iconInfo in ipairs(self._iconTextureInfos) do
        if iconNo <= curIconNo + iconInfo.iconSize then
            local image = SheetImage(iconInfo.texture)
            image:setTileSize(iconInfo.tileWidth, iconInfo.tileHeight)
            image:setIndex(iconNo - curIconNo)
            return image
        end
        curIconNo = curIconNo + iconInfo.iconSize
    end
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

--- ListBox: itemClick
UIEvent.ITEM_CLICK = "itemClick"

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

---
-- Constructor.
-- Please do not inherit this constructor.
-- Please have some template functions are inherited.
-- @param params Parameter table
function UIComponent:init(params)
    UIComponent.__super.init(self)
    self:_initInternal()
    self:_initEventListeners()
    self:_createChildren()

    self:setProperties(params)
    self._initialized = true

    self:validate()
    self:setPivToCenter()
end

---
-- Initialization is the process of internal variables.
-- Please to inherit this function if the definition of the variable.
function UIComponent:_initInternal()
    self.isUIComponent = true

    self._initialized = false
    self._enabled = true
    self._focusEnabled = true
    self._theme = nil
    self._styles = {}
    self._layout = nil
    self._excludeLayout = false
    self._invalidateDisplayFlag = true
    self._invalidateLayoutFlag = true
end

---
-- Performing the initialization processing of the event listener.
-- Please to inherit this function if you want to initialize the event listener.
function UIComponent:_initEventListeners()
    self:addEventListener(UIEvent.ENABLED_CHANGED, self.onEnabledChanged, self)
    self:addEventListener(UIEvent.FOCUS_IN, self.onFocusIn, self)
    self:addEventListener(UIEvent.FOCUS_OUT, self.onFocusOut, self)
    self:addEventListener(Event.TOUCH_DOWN, self.onTouchCommon, self, -10)
    self:addEventListener(Event.TOUCH_UP, self.onTouchCommon, self, -10)
    self:addEventListener(Event.TOUCH_MOVE, self.onTouchCommon, self, -10)
    self:addEventListener(Event.TOUCH_CANCEL, self.onTouchCommon, self, -10)
end

---
-- Performing the initialization processing of the component.
-- Please to inherit this function if you want to change the behavior of the component.
function UIComponent:_createChildren()

end

---
-- Invalidate the all state.
function UIComponent:invalidate()
    self:invalidateDisplay()
    self:invalidateLayout()
end

---
-- Invalidate the display.
-- Schedule the validate the display.
function UIComponent:invalidateDisplay()
    if not self._invalidateDisplayFlag then
        self:getLayoutMgr():invalidateDisplay(self)
        self._invalidateDisplayFlag = true
    end
end

---
-- Invalidate the layout.
-- Schedule the validate the layout.
function UIComponent:invalidateLayout()
    if not self._invalidateLayoutFlag then
        self:getLayoutMgr():invalidateLayout(self)
        self._invalidateLayoutFlag = true
    end
end

---
-- Validate the all state.
-- For slow, it should not call this process as much as possible.
function UIComponent:validate()
    self:validateDisplay()
    self:validateLayout()
end

---
-- Validate the display.
-- If you need to update the display, call the updateDisplay.
function UIComponent:validateDisplay()
    if self._invalidateDisplayFlag then
        self:updateDisplay()
        self._invalidateDisplayFlag = false
    end
end

---
-- Validate the layout.
-- If you need to update the layout, call the updateLayout.
function UIComponent:validateLayout()
    -- Fixed a bug where the position of the MOAI SDK V1.4p0 does not reflect
    if M.USE_TRANSFORM_BUGFIX then
        self:forceUpdate()
    end

    if self._invalidateLayoutFlag then
        self:updateLayout()
        self._invalidateLayoutFlag = false
    end

    if self.parent then
        self.parent:invalidateLayout()
    end
end

---
-- Update the display.
-- Do not call this function directly.
-- Instead, please consider invalidateDisplay whether available.
function UIComponent:updateDisplay()

end

---
-- Update the layout.
-- Do not call this function directly.
-- Instead, please consider invalidateLayout whether available.
function UIComponent:updateLayout()
    if self._layout then
        self._layout:update(self)
    end
end

---
-- Update the order of rendering.
-- It is called by LayoutMgr.
-- @param priority priority.
-- @return last priority
function UIComponent:updatePriority(priority)
    priority = priority or 0
    DisplayObject.setPriority(self, priority)

    for i, child in ipairs(self:getChildren()) do
        if child.updatePriority then
            priority = child:updatePriority(priority)
        else
            child:setPriority(priority)
        end
        priority = priority + 10
    end

    return priority
end

---
-- Draw focus object.
-- Called at a timing that is configured with focus.
-- @param focus focus
function UIComponent:drawFocus(focus)

end

---
-- Returns the children object.
-- If you want to use this function with caution.
-- @return children
function UIComponent:getChildren()
    return self.children
end

---
-- Sets the children object.
-- @param children
function UIComponent:setChildren(children)
    self:removeChildren()
    for i, child in ipairs(children) do
        self:addChild(child)
    end
end

---
-- Adds the specified child.
-- @param child DisplayObject
function UIComponent:addChild(child)
    if UIComponent.__super.addChild(self, child) then
        self:invalidateLayout()
        return true
    end
    return false
end

---
-- Removes a child.
-- @param child DisplayObject
-- @return True if removed.
function UIComponent:removeChild(child)
    if UIComponent.__super.removeChild(self, child) then
        self:invalidateLayout()
        return true
    end
    return false
end

---
-- Returns the nest level.
-- @return nest level
function UIComponent:getNestLevel()
    local parent = self.parent
    if parent and parent.getNestLevel then
        return parent:getNestLevel() + 1
    end
    return 1
end

---
-- Sets the properties
-- @param properties properties
function UIComponent:setProperties(properties)
    if properties then
        PropertyUtils.setProperties(self, properties, true)
    end
end

---
-- Sets the name.
-- @param name name
function UIComponent:setName(name)
    self.name = name
end

---
-- Sets the width.
-- @param width Width
function UIComponent:setWidth(width)
    local w, h = self:getSize()
    self:setSize(width, h)
end

---
-- Sets the height.
-- @param height Height
function UIComponent:setHeight(height)
    local w, h = self:getSize()
    self:setSize(w, height)
end

---
-- Sets the size.
-- @param width Width
-- @param height Height
function UIComponent:setSize(width, height)
    width  = width  < 0 and 0 or width
    height = height < 0 and 0 or height

    local oldWidth, oldHeight =  self:getSize()

    if oldWidth ~= width or oldHeight ~= height then
        UIComponent.__super.setSize(self, width, height)
        self:invalidate()
        self:dispatchEvent(UIEvent.RESIZE)
    end
end

---
-- Sets the object's parent, inheriting its color and transform.
-- If you set a parent, you want to add itself to the parent.
-- @param parent parent
function UIComponent:setParent(parent)
    if parent == self.parent then
        return
    end

    local oldParent = self.parent
    self.parent = parent
    if oldParent and oldParent.isGroup then
        oldParent:removeChild(self)
    end

    self:invalidateLayout()
    UIComponent.__super.setParent(self, parent)

    if parent and parent.isGroup then
        parent:addChild(self)
    end
end

---
-- Set the layout.
-- @param layout layout
function UIComponent:setLayout(layout)
    self._layout = layout
    self:invalidateLayout()
end

---
-- Set the enabled state.
-- @param enabled enabled
function UIComponent:setEnabled(enabled)
    self._enabled = enabled
    self:dispatchEvent(UIEvent.ENABLED_CHANGED)
end

---
-- Returns the enabled.
-- @return enabled
function UIComponent:isEnabled()
    return self._enabled
end

---
-- Returns the parent enabled.
-- @return enabled
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

---
-- Set the focus.
-- @param focus focus
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

---
-- Returns the focus.
-- @return focus
function UIComponent:isFocus()
    local focusMgr = self:getFocusMgr()
    return focusMgr:getFocusObject() == self
end

---
-- Sets the focus enabled.
-- @param focusEnabled focusEnabled
function UIComponent:setFocusEnabled(focusEnabled)
    if self._focusEnabled ~= focusEnabled then
        self._focusEnabled = focusEnabled
        if not self._focusEnabled then
            self:setFocus(false)
        end
    end
end

---
-- Returns the focus.
-- @return focus
function UIComponent:isFocusEnabled()
    return self._focusEnabled
end

---
-- Sets the theme.
-- @param theme theme
function UIComponent:setTheme(theme)
    if self._theme ~= theme then
        self._theme = theme
        self:invalidate()
        self:dispatchEvent(UIEvent.THEME_CHANGED)
    end
end

---
-- Returns the theme.
-- @return theme
function UIComponent:getTheme()
    if self._theme then
        return self._theme
    end

    if self._themeName then
        local globalTheme = M.getTheme()
        return globalTheme[self._themeName]
    end
end

---
-- Sets the style of the component.
-- @param name style name
-- @param value style value
function UIComponent:setStyle(name, value)
    if self._styles[name] ~= value then
        self._styles[name] = value
        self:dispatchEvent(UIEvent.STYLE_CHANGED, {styleName = name, styleValue = value})
    end
end

---
-- Returns the style.
-- @param name style name
-- @return style value
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

---
-- Returns the focusMgr.
-- @return focusMgr
function UIComponent:getFocusMgr()
    return M.getFocusMgr()
end

---
-- Returns the layoutMgr.
-- @return layoutMgr
function UIComponent:getLayoutMgr()
    return M.getLayoutMgr()
end

---
-- This event handler is called enabled changed.
-- @param e Touch Event
function UIComponent:onEnabledChanged(e)
    if self:isEnabled() then
        self:setColor(unpack(self:getStyle(UIComponent.STYLE_NORMAL_COLOR)))
    else
        self:setColor(unpack(self:getStyle(UIComponent.STYLE_DISABLED_COLOR)))
    end
end

---
-- This event handler is called when touch.
-- @param e Touch Event
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

---
-- This event handler is called when focus.
-- @param e focus Event
function UIComponent:onFocusIn(e)
    self:drawFocus(true)
end

---
-- This event handler is called when focus.
-- @param e focus Event
function UIComponent:onFocusOut(e)
    self:drawFocus(false)
end

----------------------------------------------------------------------------------------------------
-- @type UIGroup
-- It is a class that can have on a child UIComponent.
----------------------------------------------------------------------------------------------------
UIGroup = class(UIComponent)
M.UIGroup = UIGroup

---
-- Initialization is the process of internal variables.
-- Please to inherit this function if the definition of the variable.
function UIGroup:_initInternal()
    UIGroup.__super._initInternal(self)
    self.isUIGroup = true
    self._focusEnabled = false
end

----------------------------------------------------------------------------------------------------
-- @type UIView
-- This is a view class that displays the component.
-- Widgets to the root class view.
----------------------------------------------------------------------------------------------------
UIView = class(UIGroup)
M.UIView = UIView

---
-- Initialization is the process of internal variables.
-- Please to inherit this function if the definition of the variable.
function UIView:_initInternal()
    UIView.__super._initInternal(self)
    self.isUIView = true
    self._scene = nil
    self._lastPriority = 0

    self:_initLayer()
end

---
-- Initializes the layer to display the view.
function UIView:_initLayer()
    local layer = Layer()
    layer:setSortMode(MOAILayer.SORT_PRIORITY_ASCENDING)
    layer:setTouchEnabled(true)
    layer:addEventListener(Event.TOUCH_DOWN, self.onLayerTouchDown, self, 10)

    self:setSize(flower.getViewSize())
    self:setLayer(layer)
end

---
-- Initializes the event listeners.
function UIView:_initEventListeners()
    UIView.__super._initEventListeners(self)
end

---
-- Change the size of the viewport.
-- @param screenX X of the Screen.
-- @param screenY Y of the Screen.
-- @param screenWidth Width of the Screen.
-- @param screenHeight Height of the Screen.
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

---
-- Sets the visible to layer.
-- @param visible visible
function UIView:setVisible(visible)
    self.layer:setVisible(visible)
end

---
-- Returns the visible from layer.
-- @return visible
function UIView:getVisible()
    self.layer:getVisible()
end

---
-- Sets the scene for layer.
-- @param scene scene
function UIView:setScene(scene)
    if self.layer.scene then
        self.layer.scene:removeEventListener(Event.STOP, self.onSceneStop, self, -10)
    end

    self.layer:setScene(scene)

    if self.layer.scene then
        self.layer.scene:addEventListener(Event.STOP, self.onSceneStop, self, -10)
    end
end

---
-- This event handler is called when you touch the layer.
-- @param e Touch Event
function UIView:onLayerTouchDown(e)
    local focusMgr = self:getFocusMgr()
    focusMgr:setFocusObject(nil)
end

---
-- This event handler is called when you stop the scene.
-- @param e Touch Event
function UIView:onSceneStop(e)
    local focusMgr = self:getFocusMgr()
    focusMgr:setFocusObject(nil)
end

----------------------------------------------------------------------------------------------------
-- @type UILayout
-- This is a class to set the layout of UIComponent.
----------------------------------------------------------------------------------------------------
UILayout = class()
M.UILayout = UILayout

---
-- Constructor.
function UILayout:init(params)
    self:_initInternal()
    self:setProperties(params)
end

---
-- Initialize the internal variables.
function UILayout:_initInternal()

end

---
-- Update the layout.
-- @param parent parent component.
function UILayout:update(parent)

end

---
-- Sets the properties.
-- @param properties properties
function UILayout:setProperties(properties)
    if properties then
        PropertyUtils.setProperties(self, properties, true)
    end
end

--------------------------------------------------------------------------------
-- @type BoxLayout
-- This is the class that sets the layout of the box.
--------------------------------------------------------------------------------
BoxLayout = class(UILayout)
M.BoxLayout = BoxLayout

--- Horizotal Align: left
BoxLayout.HORIZOTAL_LEFT = "left"

--- Horizotal Align: center
BoxLayout.HORIZOTAL_CENTER = "center"

--- Horizotal Align: right
BoxLayout.HORIZOTAL_RIGHT = "right"

--- Vertical Align: top
BoxLayout.VERTICAL_TOP = "top"

--- Vertical Align: center
BoxLayout.VERTICAL_CENTER = "center"

--- Vertical Align: bottom
BoxLayout.VERTICAL_BOTTOM = "bottom"

--- Layout Direction: vertical
BoxLayout.DIRECTION_VERTICAL = "vertical"

--- Layout Direction: horizotal
BoxLayout.DIRECTION_HORIZOTAL = "horizotal"

---
-- Initializes the internal variables.
function BoxLayout:_initInternal()
    self._horizotalAlign = BoxLayout.HORIZOTAL_LEFT
    self._horizotalGap = 0
    self._verticalAlign = BoxLayout.VERTICAL_TOP
    self._verticalGap = 0
    self._paddingTop = 0
    self._paddingBottom = 0
    self._paddingLeft = 0
    self._paddingRight = 0
    self._direction = BoxLayout.DIRECTION_VERTICAL
end

---
-- Update the layout.
-- @param parent parent
function BoxLayout:update(parent)
    if self._direction == BoxLayout.DIRECTION_VERTICAL then
        self:updateVertical(parent)
    elseif self._direction == BoxLayout.DIRECTION_HORIZOTAL then
        self:updateHorizotal(parent)
    end
end

---
-- Sets the position of an objects in the vertical direction.
-- @param parent
function BoxLayout:updateVertical(parent)
    local children = parent.children
    local childrenWidth, childrenHeight = self:calcVerticalLayoutSize(children)

    local parentWidth, parentHeight = parent:getSize()
    local parentWidth = math.max(parentWidth, childrenWidth)
    local parentHeight = math.max(parentHeight, childrenHeight)
    parent:setSize(parentWidth, parentHeight)

    local childY = self:calcChildY(parentHeight, childrenHeight)
    for i, child in ipairs(children) do
        if not child._excludeLayout then
            local childWidth, childHeight = child:getSize()
            local childX = self:calcChildX(parentWidth, childWidth)
            child:setPos(childX, childY)
            childY = childY + childHeight + self._verticalGap
        end
    end
end

---
-- Sets the position of an objects in the horizotal direction.
-- @param parent
function BoxLayout:updateHorizotal(parent)
    local children = parent.children
    local childrenWidth, childrenHeight = self:calcHorizotalLayoutSize(children)

    local parentWidth, parentHeight = parent:getSize()
    local parentWidth = math.max(parentWidth, childrenWidth)
    local parentHeight = math.max(parentHeight, childrenHeight)
    parent:setSize(parentWidth, parentHeight)

    local childX = self:calcChildX(parentWidth, childrenWidth)
    for i, child in ipairs(children) do
        if not child._excludeLayout then
            local childWidth, childHeight = child:getSize()
            local childY = self:calcChildY(parentHeight, childHeight)
            child:setPos(childX, childY)
            childX = childX + childWidth + self._horizotalGap
        end
    end
end

---
-- Calculates the x position of the child object.
-- @param parentWidth parent width.
-- @param childWidth child width.
-- @return x position.
function BoxLayout:calcChildX(parentWidth, childWidth)
    local diffWidth = parentWidth - childWidth

    local x = 0
    if self._horizotalAlign == BoxLayout.HORIZOTAL_LEFT then
        x = self._paddingLeft
    elseif self._horizotalAlign == BoxLayout.HORIZOTAL_CENTER then
        x = math.floor((diffWidth + self._paddingLeft - self._paddingRight) / 2)
    elseif self._horizotalAlign == BoxLayout.HORIZOTAL_RIGHT then
        x = diffWidth - self._paddingRight
    else
        error("Not found direction!")
    end
    return x
end

---
-- Calculates the y position of the child object.
-- @param parentHeight parent width.
-- @param childHeight child width.
-- @return y position.
function BoxLayout:calcChildY(parentHeight, childHeight)
    local diffHeight = parentHeight - childHeight

    local y = 0
    if self._verticalAlign == BoxLayout.VERTICAL_TOP then
        y = self._paddingTop
    elseif self._verticalAlign == BoxLayout.VERTICAL_CENTER then
        y = math.floor((diffHeight + self._paddingTop - self._paddingBottom) / 2)
    elseif self._verticalAlign == BoxLayout.VERTICAL_BOTTOM then
        y = diffHeight - self._paddingBottom
    else
        error("Not found direction!")
    end
    return y
end

---
-- Calculate the layout size in the vertical direction.
-- @param children children
-- @return layout width
-- @return layout height
function BoxLayout:calcVerticalLayoutSize(children)
    local width = self._paddingLeft + self._paddingRight
    local height = self._paddingTop + self._paddingBottom
    local count = 0
    for i, child in ipairs(children) do
        if not child._excludeLayout then
            local cWidth, cHeight = child:getSize()
            height = height + cHeight + self._verticalGap
            width = math.max(width, cWidth + self._paddingLeft + self._paddingRight)
            count = count + 1
        end
    end
    if count > 1 then
        height = height - self._verticalGap
    end
    return width, height
end

---
-- Calculate the layout size in the horizotal direction.
-- @param children children
-- @return layout width
-- @return layout height
function BoxLayout:calcHorizotalLayoutSize(children)
    local width = self._paddingLeft + self._paddingRight
    local height = self._paddingTop + self._paddingBottom
    local count = 0
    for i, child in ipairs(children) do
        if not child._excludeLayout then
            local cWidth, cHeight = child:getSize()
            width = width + cWidth + self._horizotalGap
            height = math.max(height, cHeight + self._paddingTop + self._paddingBottom)
            count = count + 1
        end
    end
    if count > 1 then
        width = width - self._horizotalGap
    end
    return width, height
end

---
-- Set the padding.
-- @param left left padding
-- @param top top padding
-- @param right right padding
-- @param bottom bottom padding
function BoxLayout:setPadding(left, top, right, bottom)
    self._paddingLeft = left or self._paddingTop
    self._paddingTop = top or self._paddingTop
    self._paddingRight = right or self._paddingRight
    self._paddingBottom = bottom or self._paddingBottom
end

---
-- Set the alignment.
-- @param horizotalAlign horizotal align
-- @param verticalAlign vertical align
function BoxLayout:setAlign(horizotalAlign, verticalAlign)
    self._horizotalAlign = horizotalAlign
    self._verticalAlign = verticalAlign
end

---
-- Set the direction.
-- @param direction direction("horizotal" or "vertical")
function BoxLayout:setDirection(direction)
    self._direction = direction
end

---
-- Set the gap.
-- @param horizotalGap horizotal gap
-- @param verticalGap vertical gap
function BoxLayout:setGap(horizotalGap, verticalGap)
    self._horizotalGap = horizotalGap
    self._verticalGap = verticalGap
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

---
-- Initializes the internal variables.
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

---
-- Initializes the event listener.
function Button:_initEventListeners()
    Button.__super._initEventListeners(self)
    self:addEventListener(Event.RESIZE, self.onResize, self)
    self:addEventListener(Event.TOUCH_DOWN, self.onTouchDown, self)
    self:addEventListener(Event.TOUCH_UP, self.onTouchUp, self)
    self:addEventListener(Event.TOUCH_MOVE, self.onTouchMove, self)
    self:addEventListener(Event.TOUCH_CANCEL, self.onTouchCancel, self)
    self:addEventListener(UIEvent.SELECTED_CHANGED, self.onSelectedChanged, self)
end

---
-- Create children.
function Button:_createChildren()
    Button.__super._createChildren(self)

    self:_createButtonImage()
    self:_createTextLabel()

    if self._buttonImage then
        self:setSize(self._buttonImage:getSize())
    end
end

---
-- Create the buttonImage.
function Button:_createButtonImage()
    if self._buttonImage then
        return
    end
    local imagePath = assert(self:getImagePath())
    self._buttonImage = NineImage(imagePath)
    self:addChild(self._buttonImage)
end

---
-- Create the textLabel.
function Button:_createTextLabel()
    if self._textLabel then
        return
    end
    self._textLabel = Label(self._text)
    self:addChild(self._textLabel)
end

---
-- Update the display.
function Button:updateDisplay()
    self:updateButtonImage()
    self:updateTextLabel()
end

---
-- Update the buttonImage.
function Button:updateButtonImage()
    local buttonImage = self._buttonImage
    buttonImage:setImage(self:getImagePath())
    buttonImage:setSize(self:getSize())
end

---
-- Update the buttonImage.
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

---
-- Returns the image path.
-- @return imageDeck
function Button:getImagePath()
    if not self:isEnabled() then
        return self:getStyle(Button.STYLE_DISABLED_TEXTURE)
    elseif self:isSelected() then
        return self:getStyle(Button.STYLE_SELECTED_TEXTURE)
    else
        return self:getStyle(Button.STYLE_NORMAL_TEXTURE)
    end
end

---
-- Returns the label content rect.
-- @return content rect
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

---
-- If the selected the button returns True.
-- @return If the selected the button returns True
function Button:isSelected()
    return self._selected
end

---
-- Sets the selected.
-- @param selected selected
function Button:setSelected(selected)
    if self._selected == selected then
        return
    end

    self._selected = selected
    self:updateButtonImage()
    self:dispatchEvent(UIEvent.SELECTED_CHANGED, selected)
end

---
-- Sets the toggle.
-- @param toggle toggle
function Button:setToggle(toggle)
    self._toggle = toggle
end

---
-- Returns the toggle.
-- @return toggle
function Button:isToggle()
    return self._toggle
end

---
-- Sets the normal texture.
-- @param texture texture
function Button:setNormalTexture(texture)
    self:setStyle(Button.STYLE_NORMAL_TEXTURE, texture)
    self:invalidateDisplay()
end

---
-- Sets the selected texture.
-- @param texture texture
function Button:setSelectedTexture(texture)
    self:setStyle(Button.STYLE_SELECTED_TEXTURE, texture)
    self:invalidateDisplay()
end

---
-- Sets the selected texture.
-- @param texture texture
function Button:setDisabledTexture(texture)
    self:setStyle(Button.STYLE_DISABLED_TEXTURE, texture)
    self:invalidateDisplay()
end

---
-- Sets the text.
-- @param text text
function Button:setText(text)
    self._text = text
    self._textLabel:setString(text)
    self._textLabel:setReveal(self._text and #self._text or 0)
end

---
-- Returns the text.
-- @return text
function Button:getText()
    return self._text
end

---
-- Sets the textSize.
-- @param textSize textSize
function Button:setTextSize(textSize)
    self:setStyle(Button.STYLE_TEXT_SIZE, textSize)
    self._textLabel:setTextSize(self:getTextSize())
end

---
-- Sets the textSize.
-- @param textSize textSize
function Button:getTextSize()
    return self:getStyle(Button.STYLE_TEXT_SIZE)
end

---
-- Sets the fontName.
-- @param fontName fontName
function Button:setFontName(fontName)
    self:setStyle(Button.STYLE_FONT_NAME, fontName)
    self._textLabel:setFont(self:getFont())
end

---
-- Sets the textSize.
-- @param textSize textSize
function Button:getFontName()
    return self:getStyle(Button.STYLE_FONT_NAME)
end

---
-- Returns the font.
-- @return font
function Button:getFont()
    local fontName = self:getFontName()
    local font = Resources.getFont(fontName, nil, self:getTextSize())
    return font
end

---
-- Sets the text align.
-- @param horizotalAlign horizotal align(left, center, top)
-- @param verticalAlign vertical align(top, center, bottom)
function Button:setTextAlign(horizotalAlign, verticalAlign)
    if horizotalAlign or verticalAlign then
        self:setStyle(Button.STYLE_TEXT_ALIGN, {horizotalAlign or "center", verticalAlign or "center"})
    else
        self:setStyle(Button.STYLE_TEXT_ALIGN, nil)
    end
    self._textLabel:setAlignment(self:getAlignment())
end

---
-- Returns the text align.
-- @return horizotal align(left, center, top)
-- @return vertical align(top, center, bottom)
function Button:getTextAlign()
    return unpack(self:getStyle(Button.STYLE_TEXT_ALIGN))
end

---
-- Returns the text align for MOAITextBox.
-- @return horizotal align
-- @return vertical align
function Button:getAlignment()
    local h, v = self:getTextAlign()
    h = assert(TextAlign[h])
    v = assert(TextAlign[v])
    return h, v
end

---
-- Sets the text color.
-- @param red red(0 ... 1)
-- @param green green(0 ... 1)
-- @param blue blue(0 ... 1)
-- @param alpha alpha(0 ... 1)
function Button:setTextColor(red, green, blue, alpha)
    if red == nil and green == nil and blue == nil and alpha == nil then
        self:setStyle(Button.STYLE_TEXT_COLOR, nil)
    else
        self:setStyle(Button.STYLE_TEXT_COLOR, {red or 0, green or 0, blue or 0, alpha or 0})
    end
    self._textLabel:setColor(self:getTextColor())
end

---
-- Returns the text color.
-- @return red(0 ... 1)
-- @return green(0 ... 1)
-- @return blue(0 ... 1)
-- @return alpha(0 ... 1)
function Button:getTextColor()
    return unpack(self:getStyle(Button.STYLE_TEXT_COLOR))
end

---
-- Sets the text padding.
-- @param paddingLeft padding left
-- @param paddingTop padding top
-- @param paddingRight padding right
-- @param paddingBottom padding bottom
function Button:setTextPadding(paddingLeft, paddingTop, paddingRight, paddingBottom)
    local style = {paddingLeft or 0, paddingTop or 0, paddingRight or 0, paddingBottom or 0}
    self:setStyle(Button.STYLE_TEXT_PADDING, style)
    if self._initialized then
        self:updateTextLabel()
    end
end

---
-- Returns the text padding.
-- @return paddingLeft
-- @return paddingTop
-- @return paddingRight
-- @return paddingBottom
function Button:getTextPadding()
    local padding = self:getStyle(Button.STYLE_TEXT_PADDING)
    if padding then
        return unpack(padding)
    end
    return 0, 0, 0, 0
end

---
-- Set the event listener that is called when the user click the button.
-- @param func click event handler
function Button:setOnClick(func)
    self:setEventListener(UIEvent.CLICK, func)
end

---
-- Set the event listener that is called when the user pressed the button.
-- @param func button down event handler
function Button:setOnDown(func)
    self:setEventListener(UIEvent.DOWN, func)
end

---
-- Set the event listener that is called when the user released the button.
-- @param func button up event handler
function Button:setOnUp(func)
    self:setEventListener(UIEvent.UP, func)
end

---
-- Set the event listener that is called when selected changed.
-- @param func selected changed event handler
function Button:setOnSelectedChanged(func)
    self:setEventListener(UIEvent.SELECTED_CHANGED, func)
end

---
-- This event handler is called when enabled Changed.
-- @param e Touch Event
function Button:onEnabledChanged(e)
    Button.__super.onEnabledChanged(self, e)
    self:updateButtonImage()

    if not self:isEnabled() and not self:isToggle() then
        self:setSelected(false)
    end
end

---
-- This event handler is called when selected changed.
-- @param e Touch Event
function Button:onSelectedChanged(e)
    if self:isSelected() then
        self:dispatchEvent(UIEvent.DOWN)
    else
        self:dispatchEvent(UIEvent.UP)
    end
end

---
-- This event handler is called when resize.
-- @param e Touch Event
function Button:onResize(e)
end

---
-- This event handler is called when you touch the button.
-- @param e Touch Event
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

---
-- This event handler is called when the button is released.
-- @param e Touch Event
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

---
-- This event handler is called when you move on the button.
-- @param e Touch Event
function Button:onTouchMove(e)
    if self._touchDownIdx ~= e.idx then
        return
    end

    if self:isToggle() then
        return
    end

    self:setSelected(self:inside(e.wx, e.wy, 0))

end

---
-- This event handler is called when you cancel the touch.
-- @param e Touch Event
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

---
-- Initializes the internal variables.
function ImageButton:_initInternal()
    ImageButton.__super._initInternal(self)
    self._themeName = "ImageButton"
end

---
-- Create the buttonImage.
function ImageButton:_createButtonImage()
    if self._buttonImage then
        return
    end
    local imagePath = assert(self:getImagePath())
    self._buttonImage = Image(imagePath)
    self:addChild(self._buttonImage)
end

---
-- Update the imageDeck.
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

---
-- Initializes the internal variables.
function SheetButton:_initInternal()
    SheetButton.__super._initInternal(self)
    self._themeName = "SheetButton"
end

---
-- Create the buttonImage.
function SheetButton:_createButtonImage()
    if self._buttonImage then
        return
    end

    local textureSheets = assert(self:getStyle(SheetButton.STYLE_TEXTURE_SHEETS))
    self._buttonImage = SheetImage(textureSheets .. ".png")
    self._buttonImage:setTextureAtlas(textureSheets .. ".lua")
    self:addChild(self._buttonImage)
end

---
-- Update the buttonImage.
function SheetButton:updateButtonImage()
    local imagePath = assert(self:getImagePath())

    self._buttonImage:setIndexByName(imagePath)
    self:setSize(self._buttonImage:getSize())
end

---
-- Sets the sheet texture's file.
-- @param filename filename
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

---
-- Initializes the internal variables.
function CheckBox:_initInternal()
    CheckBox.__super._initInternal(self)
    self._themeName = "CheckBox"
    self._toggle = true
end

---
-- Update the buttonImage.
function CheckBox:updateButtonImage()
    local buttonImage = self._buttonImage
    buttonImage:setTexture(self:getImagePath())
end

---
-- Update the textLabel.
function CheckBox:updateTextLabel()
    CheckBox.__super.updateTextLabel(self)

    self._textLabel:fitWidth()
end

---
-- Returns the label content rect.
-- @return content rect
function CheckBox:getLabelContentRect()
    local buttonImage = self._buttonImage
    local textLabel = self._textLabel
    local left, top = buttonImage:getRight(), buttonImage:getTop()
    local right, bottom = left + textLabel:getWidth(), top + buttonImage:getHeight()
    return left, top, right, bottom
end

----------------------------------------------------------------------------------------------------
-- @type Joystick
-- It is a virtual Joystick.
----------------------------------------------------------------------------------------------------
Joystick = class(UIComponent)
M.Joystick = Joystick

--- Direction of the stick
Joystick.STICK_CENTER = "center"

--- Direction of the stick
Joystick.STICK_LEFT = "left"

--- Direction of the stick
Joystick.STICK_TOP = "top"

--- Direction of the stick
Joystick.STICK_RIGHT = "right"

--- Direction of the stick
Joystick.STICK_BOTTOM = "bottom"

--- Mode of the stick
Joystick.MODE_ANALOG = "analog"

--- Mode of the stick
Joystick.MODE_DIGITAL = "digital"

--- The ratio of the center
Joystick.RANGE_OF_CENTER_RATE = 0.5

--- Style: baseTexture
Joystick.STYLE_BASE_TEXTURE = "baseTexture"

--- Style: knobTexture
Joystick.STYLE_KNOB_TEXTURE = "knobTexture"

---
-- Initializes the internal variables.
function Joystick:_initInternal()
    Joystick.__super._initInternal(self)
    self._themeName = "Joystick"
    self._touchIndex = nil
    self._rangeOfCenterRate = Joystick.RANGE_OF_CENTER_RATE
    self._stickMode = Joystick.MODE_ANALOG
    self._changedEvent = Event(UIEvent.STICK_CHANGED)
end

---
-- Initializes the event listener.
-- You must not be called directly.
function Joystick:_initEventListeners()
    Joystick.__super._initEventListeners(self)
    self:addEventListener(Event.TOUCH_DOWN, self.onTouchDown, self)
    self:addEventListener(Event.TOUCH_UP, self.onTouchUp, self)
    self:addEventListener(Event.TOUCH_MOVE, self.onTouchMove, self)
    self:addEventListener(Event.TOUCH_CANCEL, self.onTouchCancel, self)
end

---
-- Initialize child objects that make up the Joystick.
-- You must not be called directly.
function Joystick:_createChildren()
    Joystick.__super._createChildren(self)

    self._baseImage = Image(self:getStyle(Joystick.STYLE_BASE_TEXTURE))
    self._knobImage = Image(self:getStyle(Joystick.STYLE_KNOB_TEXTURE))

    self:addChild(self._baseImage)
    self:addChild(self._knobImage)

    self:setSize(self._baseImage:getSize())
    self:setCenterKnob()
end

---
-- Update the display.
function Joystick:updateDisplay()
    self._baseImage:setTexture(self:getStyle(Joystick.STYLE_BASE_TEXTURE))
    self._knobImage:setTexture(self:getStyle(Joystick.STYLE_KNOB_TEXTURE))
end

---
-- To update the position of the knob.
-- @param x The x-position of the knob
-- @param y The y-position of the knob
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

---
-- Set the position of the center of the knob.
function Joystick:setCenterKnob()
    local cx, cy = self:getWidth() / 2, self:getHeight() / 2
    self._knobImage:setLoc(cx, cy, 0)
end

---
-- Returns the position of the center of the whole.
-- Does not depend on the Pivot.
-- @return Center x-position
-- @return Center y-position
function Joystick:getCenterLoc()
    return self:getWidth() / 2, self:getHeight() / 2
end

---
-- Returns the position that matches the mode of the stick.
-- @param x X-position of the model
-- @param y Y-position of the model
-- @return adjusted x-position
-- @return adjusted y-position
function Joystick:getKnobNewLoc(x, y)
    if self:getStickMode() == Joystick.MODE_ANALOG then
        return self:getKnobNewLocForAnalog(x, y)
    else
        return self:getKnobNewLocForDigital(x, y)
    end
end

---
-- Returns the position to match the analog mode.
-- @param x X-position of the model
-- @param y Y-position of the model
-- @return adjusted x-position
-- @return adjusted y-position
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

---
-- Returns the position to match the digital mode.
-- @param x X-position of the model
-- @param y Y-position of the model
-- @return adjusted x-position
-- @return adjusted y-position
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

---
-- Returns the percentage of input.
-- @param x X-position
-- @param y Y-position
-- @return X-ratio(-1 <= x <= 1)
-- @return Y-ratio(-1 <= y <= 1)
function Joystick:getKnobInputRate(x, y)
    local cx, cy = self:getCenterLoc()
    local rateX, rateY = (x - cx) / cx, (y - cy) / cy
    return rateX, rateY
end

---
-- Returns the direction of the stick.
-- @return direction
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

---
-- Returns the stick mode
-- @return stick mode
function Joystick:getStickMode()
    return self._stickMode
end

---
-- Set the mode of the stick.
-- @param mode mode("analog" or "digital")
function Joystick:setStickMode(mode)
    self._stickMode = mode
end

---
-- Returns the touched.
-- @return stick mode
function Joystick:isTouchDown()
    return self._touchIndex ~= nil
end

---
-- Set the event listener that is called when the stick changed.
-- @param func stickChanged event handler
function Joystick:setOnStickChanged(func)
    self:setEventListener(UIEvent.STICK_CHANGED, func)
end

---
-- This event handler is called when touched.
-- @param e Touch Event
function Joystick:onTouchDown(e)
    if self:isTouchDown() then
        return
    end

    local mx, my = self:worldToModel(e.wx, e.wy, 0)
    self._touchIndex = e.idx
    self:updateKnob(mx, my)
end

---
-- This event handler is called when the button is released.
-- @param e Touch Event
function Joystick:onTouchUp(e)
    if e.idx ~= self._touchIndex then
        return
    end

    self._touchIndex = nil
    local cx, cy = self:getCenterLoc()
    self:updateKnob(cx, cy)
end

---
-- This event handler is called when you move on the button.
-- @param e Touch Event
function Joystick:onTouchMove(e)
    if e.idx ~= self._touchIndex then
        return
    end

    local mx, my = self:worldToModel(e.wx, e.wy, 0)
    self:updateKnob(mx, my)
end

---
-- This event handler is called when you move on the button.
-- @param e Touch Event
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

---
-- Initializes the internal variables.
function Panel:_initInternal()
    Panel.__super._initInternal(self)
    self._themeName = "Panel"
end

---
-- Initialize the event listeners
function Panel:_initEventListeners()
    Panel.__super._initEventListeners(self)
    self:addEventListener(UIEvent.RESIZE, self.onResize, self)
end

---
-- Create a children object.
function Panel:_createChildren()
    Panel.__super._createChildren(self)
    self:_createBackgroundImage()
end

---
-- Create an image of the background
function Panel:_createBackgroundImage()
    if self._backgroundImage then
        return
    end

    local texture = self:getBackgroundTexture()
    self._backgroundImage = NineImage(texture)
    self:addChild(self._backgroundImage)
end

---
-- Update the display objects.
function Panel:updateDisplay()
    Panel.__super.updateDisplay(self)
    self._backgroundImage:setImage(self:getBackgroundTexture())
    self._backgroundImage:setSize(self:getSize())
    self._backgroundImage:setVisible(self:getBackgroundVisible())
end

---
-- Sets the background texture path.
-- @param texture background texture path
function Panel:setBackgroundTexture(texture)
    self:setStyle(Panel.STYLE_BACKGROUND_TEXTURE, texture)
    self._backgroundImage:setImage(self:getBackgroundTexture())
end

---
-- Returns the background texture path.
-- @param texture background texture path
function Panel:getBackgroundTexture()
    return self:getStyle(Panel.STYLE_BACKGROUND_TEXTURE)
end

---
-- Set the visible of the background.
-- @param visible visible
function Panel:setBackgroundVisible(visible)
    self:setStyle(Panel.STYLE_BACKGROUND_VISIBLE, visible)
    self._backgroundImage:setVisible(self:getBackgroundVisible())
end

---
-- Returns the visible of the background.
-- @return visible
function Panel:getBackgroundVisible()
    local visible = self:getStyle(Panel.STYLE_BACKGROUND_VISIBLE)
    if visible ~= nil then
        return visible
    end
    return true
end

---
-- This event handler is called when resize.
-- @param e Touch Event
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

---
-- Initialize a variables
function TextBox:_initInternal()
    TextBox.__super._initInternal(self)
    self._themeName = "TextBox"
    self._text = ""
    self._textLabel = nil
end

---
-- Create a children object.
function TextBox:_createChildren()
    TextBox.__super._createChildren(self)

    self._textLabel = Label(self._text, 100, 30)
    self._textLabel:setWordBreak(MOAITextBox.WORD_BREAK_CHAR)
    self:addChild(self._textLabel)
end

---
-- Update the display objects.
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

---
-- Sets the text.
-- @param text text
function TextBox:setText(text)
    self._text = text
    self._textLabel:setString(text)
end

---
-- Adds the text.
-- @param text text
function TextBox:addText(text)
    self:setText(self._text .. text)
end

---
-- Returns the text.
-- @return text
function TextBox:getText()
    return self._text
end

---
-- Returns the text length.
-- TODO:Tag escaping.
-- @return text length
function TextBox:getTextLength()
    return self._text and #self._text or 0
end

---
-- Sets the textSize.
-- @param textSize textSize
function TextBox:setTextSize(textSize)
    self:setStyle(TextBox.STYLE_TEXT_SIZE, textSize)
    self._textLabel:setTextSize(self:getTextSize())
end

---
-- Returns the textSize.
-- @return textSize
function TextBox:getTextSize()
    return self:getStyle(TextBox.STYLE_TEXT_SIZE)
end

---
-- Sets the fontName.
-- @param fontName fontName
function TextBox:setFontName(fontName)
    self:setStyle(TextBox.STYLE_FONT_NAME, fontName)
    self._textLabel:setFont(self:getFont())
end

---
-- Returns the font name.
-- @return font name
function TextBox:getFontName()
    return self:getStyle(TextBox.STYLE_FONT_NAME)
end

---
-- Returns the font.
-- @return font
function TextBox:getFont()
    local fontName = self:getFontName()
    local font = Resources.getFont(fontName, nil, self:getTextSize())
    return font
end

---
-- Sets the text align.
-- @param horizotalAlign horizotal align(left, center, top)
-- @param verticalAlign vertical align(top, center, bottom)
function TextBox:setTextAlign(horizotalAlign, verticalAlign)
    if horizotalAlign or verticalAlign then
        self:setStyle(TextBox.STYLE_TEXT_ALIGN, {horizotalAlign or "center", verticalAlign or "center"})
    else
        self:setStyle(TextBox.STYLE_TEXT_ALIGN, nil)
    end
    self._textLabel:setAlignment(self:getAlignment())
end

---
-- Returns the text align.
-- @return horizotal align(left, center, top)
-- @return vertical align(top, center, bottom)
function TextBox:getTextAlign()
    return unpack(self:getStyle(TextBox.STYLE_TEXT_ALIGN))
end

---
-- Returns the text align for MOAITextBox.
-- @return horizotal align
-- @return vertical align
function TextBox:getAlignment()
    local h, v = self:getTextAlign()
    h = assert(TextAlign[h])
    v = assert(TextAlign[v])
    return h, v
end

---
-- Sets the text align.
-- @param red red(0 ... 1)
-- @param green green(0 ... 1)
-- @param blue blue(0 ... 1)
-- @param alpha alpha(0 ... 1)
function TextBox:setTextColor(red, green, blue, alpha)
    if red == nil and green == nil and blue == nil and alpha == nil then
        self:setStyle(TextBox.STYLE_TEXT_COLOR, nil)
    else
        self:setStyle(TextBox.STYLE_TEXT_COLOR, {red or 0, green or 0, blue or 0, alpha or 0})
    end
    self._textLabel:setColor(self:getTextColor())
end

---
-- Returns the text color.
-- @return red(0 ... 1)
-- @return green(0 ... 1)
-- @return blue(0 ... 1)
-- @return alpha(0 ... 1)
function TextBox:getTextColor()
    return unpack(self:getStyle(TextBox.STYLE_TEXT_COLOR))
end

---
-- This event handler is called when resize.
-- @param e Touch Event
function TextBox:onResize(e)
    TextBox.__super.onResize(self, e)

    local textLabel = self._textLabel
    local xMin, yMin, xMax, yMax = self._backgroundImage:getContentRect()
    local textWidth, textHeight = xMax - xMin, yMax - yMin
    textLabel:setSize(textWidth, textHeight)
    textLabel:setPos(xMin, yMin)
end

---
-- Set textbox padding by label's setRect method, it will set 4 direction padding
-- @param padding pixecls
function TextBox:setPadding(padding)
    if self._textLabel then
        local x1, y1, x2, y2 = self._textLabel:getRect()
        self._textLabel:setRect(x1 + padding, y1 + padding, x2 - padding, y2 - padding)
    end
end

---
-- Set textbox padding-top by label's setRect method
-- @param padding pixecls
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

    self._textAllow = Rect(1, self:getTextSize())
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
        InputMgr:addEventListener(Event.KEY_DOWN, self.onKeyDown, self)
        InputMgr:addEventListener(Event.KEY_UP, self.onKeyUp, self)
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
        InputMgr:removeEventListener(Event.KEY_DOWN, self.onKeyDown, self)
        InputMgr:removeEventListener(Event.KEY_UP, self.onKeyUp, self)
    end
end

---
-- This event handler is called when focus in.
-- @param e event
function TextInput:onKeyDown(e)
    local key = e.key

    if key == KeyCode.DEL or key == KeyCode.BACKSPACE then
        local text = self:getText()
        text = #text > 0 and text:sub(1, #text - 1) or text
        self:setText(text)
    elseif key == KeyCode.ENTER then
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
    self:addEventListener(Event.TOUCH_DOWN, self.onTouchDown, self)
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

--- Style: scrollBarTexture
ListBox.STYLE_SCROLL_BAR_TEXTURE = "scrollBarTexture"

---
-- Initialize a variables
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
    self._scrollBar = nil
    self._scrollBarVisible = true
    self._labelField = nil
    self._touchedIndex = nil
end

---
-- Initialize the event listeners.
function ListBox:_initEventListeners()
    ListBox.__super._initEventListeners(self)
    self:addEventListener(Event.TOUCH_DOWN, self.onTouchDown, self)
    self:addEventListener(Event.TOUCH_UP, self.onTouchUp, self)
    self:addEventListener(Event.TOUCH_MOVE, self.onTouchMove, self)
    self:addEventListener(Event.TOUCH_CANCEL, self.onTouchCancel, self)
end

---
-- Create the children.
function ListBox:_createChildren()
    ListBox.__super._createChildren(self)
    self:_createScrollBar()
end

---
-- Create the scrollBar
function ListBox:_createScrollBar()
    self._scrollBar = NineImage(self:getStyle(ListBox.STYLE_SCROLL_BAR_TEXTURE))
    self:addChild(self._scrollBar)
end

---
-- Create the ListItem.
-- @param index index of the listItems
-- @return listItem
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

---
-- Delete the ListItem.
-- @param index index of the listItems
function ListBox:_deleteListItem(index)
    local listItem = self._listItems[index]
    if listItem then
        listItem:setSelected(false)
        self:removeChild(listItem)
        table.insert(self._freeListItems, listItem)
        self._listItems[index] = nil
    end
end

---
-- Clears the ListItems.
function ListBox:_clearListItems()
    for i = 1, #self._listItems do
        self:_deleteListItem(i)
    end
    self._freeListItems = {}
end

---
-- Update the display.
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

    self:updateScrollBar()
end

---
-- Update the priority.
-- @param priority priority
-- @return last priority
function ListBox:updatePriority(priority)
    priority = ListBox.__super.updatePriority(self, priority)
    self._scrollBar:setPriority(priority + 1)
    return priority + 10
end

---
-- Update the size by rowCount.
function ListBox:updateSize()
    local rowCount = self:getRowCount()
    local rowHeight = self:getRowHeight()
    local pLeft, pTop, pRight, pBottom = self._backgroundImage:getContentPadding()

    self:setHeight(rowCount * rowHeight + pTop + pBottom)
end

---
-- Update the scroll bar.
function ListBox:updateScrollBar()
    local bar = self._scrollBar
    local xMin, yMin, xMax, yMax = self._backgroundImage:getContentRect()
    local vsp = self:getVerticalScrollPosition()
    local maxVsp = self:getMaxVerticalScrollPosition()
    local step = (yMax - yMin) / (maxVsp + 1)

    bar:setSize(bar:getWidth(), math.floor(math.max(step, bar.displayHeight)))

    step = step >= bar.displayHeight and step or (yMax - yMin - bar.displayHeight) / (maxVsp + 1)
    bar:setPos(xMax - bar:getWidth(), yMin + math.floor(step * vsp))
    bar:setVisible(maxVsp > 0 and self._scrollBarVisible)
end

---
-- Sets the list data.
-- @param listData listData
function ListBox:setListData(listData)
    self._listData = listData or {}
    self:_clearListItems()
    self:invalidateDisplay()
end

---
-- Returns the list data.
-- @return listData
function ListBox:getListData()
    return self._listData
end

---
-- Returns the list size.
-- @return size
function ListBox:getListSize()
    return #self._listData
end

---
-- Returns the ListItems.
-- Care must be taken to use the ListItems.
-- ListItems is used to cache internally rotate.
-- Therefore, ListItems should not be accessed from outside too.
-- @return listItems
function ListBox:getListItems()
    return self._listItems
end

---
-- Returns the ListItem.
-- @param index index of the listItems
-- @return listItem
function ListBox:getListItemAt(index)
    return self._listItems[index]
end

---
-- Sets the ListItemFactory.
-- @param factory ListItemFactory
function ListBox:setListItemFactory(factory)
    self:setStyle(ListBox.STYLE_LIST_ITEM_FACTORY, factory)
    self:_clearListItems()
    self:invalidateDisplay()
end

---
-- Returns the ListItemFactory.
-- @return ListItemFactory
function ListBox:getListItemFactory()
    return self:getStyle(ListBox.STYLE_LIST_ITEM_FACTORY)
end

---
-- Sets the selectedIndex.
-- @param index selectedIndex
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

---
-- Returns the selectedIndex.
-- @return selectedIndex
function ListBox:getSelectedIndex()
    return self._selectedIndex
end

---
-- Set the selected item.
-- @param item selected item
function ListBox:setSelectedItem(item)
    if item then
        self:setSelectedIndex(item:getDataIndex())
    else
        self:setSelectedIndex(nil)
    end
end

---
-- Set the scrollBar visible.
-- @param visible scrollBar visible
function ListBox:setScrollBarVisible(visible)
    self._scrollBarVisible = visible
    self._scrollBar:setVisible(maxVsp > 0 and self._scrollBarVisible)
end

---
-- Return the selected item.
-- @return selected item
function ListBox:getSelectedItem()
    if self._selectedIndex then
        return self._listItems[self._selectedIndex]
    end
end

---
-- Set the labelField.
-- @param labelField labelField
function ListBox:setLabelField(labelField)
    self._labelField = labelField
    self:invalidateDisplay()
end

---
-- Return the labelField.
-- @return labelField
function ListBox:getLabelField()
    return self._labelField
end

---
-- Set the verticalScrollPosition.
-- @param pos verticalScrollPosition
function ListBox:setVerticalScrollPosition(pos)
    if self._verticalScrollPosition == pos then
        return
    end
    self._verticalScrollPosition = math.max(0, math.min(self:getMaxVerticalScrollPosition(), pos))
    self:invalidateDisplay()
end

---
-- Return the verticalScrollPosition.
-- @return verticalScrollPosition
function ListBox:getVerticalScrollPosition()
    return self._verticalScrollPosition
end

---
-- Return the maxVerticalScrollPosition.
-- @return maxVerticalScrollPosition
function ListBox:getMaxVerticalScrollPosition()
    return math.max(math.floor(self:getListSize() / self:getColumnCount()) - self:getRowCount(), 0)
end

---
-- Set the height of the row.
-- @param rowHeight height of the row
function ListBox:setRowHeight(rowHeight)
    self:setStyle(ListBox.STYLE_ROW_HEIGHT, rowHeight)
    self:invalidateDisplay()
end

---
-- Return the height of the row.
-- @return rowHeight
function ListBox:getRowHeight()
    return self:getStyle(ListBox.STYLE_ROW_HEIGHT)
end

---
-- Set the count of the rows.
-- @param rowCount count of the rows
function ListBox:setRowCount(rowCount)
    self._rowCount = rowCount
    self:updateSize()
    self:invalidateDisplay()
end

---
-- Return the count of the rows.
-- @return rowCount
function ListBox:getRowCount()
    return self._rowCount
end

---
-- Set the count of the columns.
-- @param columnCount count of the columns
function ListBox:setColumnCount(columnCount)
    assert(columnCount >= 1, "columnCount property error!")

    self._columnCount = columnCount
    self:invalidateDisplay()
end

---
-- Return the count of the columns.
-- @return columnCount
function ListBox:getColumnCount()
    return self._columnCount
end

---
-- Returns true if the component has been touched.
-- @return touching
function ListBox:isTouching()
    return self._touchedIndex ~= nil
end

---
-- Set the texture path of the scroll bar.
-- Needs to be NinePatch.
-- @param texture texture path.
function ListBox:setScrollBarTexture(texture)
    self:setStyle(ListBox.STYLE_SCROLL_BAR_TEXTURE, texture)
    self._scrollBar:setImage(texture)
    self:updateScrollBar()
end

---
-- Set the event listener that is called when the user item changed.
-- @param func event handler
function ListBox:setOnItemChanged(func)
    self:setEventListener(UIEvent.ITEM_CHANGED, func)
end

---
-- Set the event listener that is called when the user item changed.
-- @param func event handler
function ListBox:setOnItemEnter(func)
    print("Depricated function:setOnItemEnter")
    self:setOnItemClick(func)
end

---
-- Set the event listener that is called when the user item changed.
-- @param func event handler
function ListBox:setOnItemClick(func)
    self:setEventListener(UIEvent.ITEM_CLICK, func)
end

---
-- TODO:Doc
function ListBox:findListItemByPos(x, y)
    local listSize = self:getListSize()

    for i = 1, listSize do
        local item = self:getListItemAt(i)
        if item and item:inside(x, y, 0) then
            return item
        end
    end
end

---
-- This event handler is called when touch.
-- @param e Touch Event
function ListBox:onTouchDown(e)
    if self._touchedIndex ~= nil and self._touchedIndex ~= e.idx then
        return
    end
    self._touchedIndex = e.idx
    self._touchedY = e.wy
    self._touchedVsp = self:getVerticalScrollPosition()
    self._itemClickCancelFlg = false

    local item = self:findListItemByPos(e.wx, e.wy)
    self:setSelectedItem(item)
end

---
-- This event handler is called when touch.
-- @param e Touch Event
function ListBox:onTouchUp(e)
    if self._touchedIndex ~= e.idx then
        return
    end

    local item = self:getSelectedItem()
    local oldVsp = self._touchedVsp
    local nowVsp = self:getVerticalScrollPosition()

    if item and item:getData() and not self._itemClickCancelFlg then
        self:dispatchEvent(UIEvent.ITEM_CLICK, item:getData())
    end

    self._touchedIndex = nil
    self._touchedY = nil
    self._touchedVsp = nil
    self._itemClickCancelFlg = false
end

---
-- This event handler is called when touch.
-- @param e Touch Event
function ListBox:onTouchMove(e)
    if self._touchedIndex ~= e.idx then
        return
    end
    local rowHeight = self:getRowHeight()
    local delta = self._touchedY - e.wy
    local oldVsp = self:getVerticalScrollPosition()
    local newVsp = self._touchedVsp + math.floor(delta / rowHeight)

    if oldVsp ~= newVsp then
        self._itemClickCancelFlg = true
        self:setVerticalScrollPosition(newVsp)
    end
end

---
-- This event handler is called when touch.
-- @param e Touch Event
function ListBox:onTouchCancel(e)
    self:onTouchUp(e)
end

---
-- This event handler is called when resize.
-- @param e Event
function ListBox:onResize(e)
    ListBox.__super.onResize(self, e)

    local xMin, yMin, xMax, yMax = self._backgroundImage:getContentRect()
    local contentWidth, contentHeight = xMax - xMin, yMax - yMin
    local rowHeight = self:getRowHeight()
    self._rowCount = math.floor(contentHeight / rowHeight)
end


----------------------------------------------------------------------------------------------------
-- @type ListItem
-- It is the item class ListBox.
-- Used from the ListBox.
----------------------------------------------------------------------------------------------------
ListItem = class(TextBox)
M.ListItem = ListItem

--- Style: iconVisible
ListItem.STYLE_ICON_VISIBLE = "iconVisible"

--- Style: iconTexture
ListItem.STYLE_ICON_TEXTURE = "iconTexture"

--- Style: iconTileSize
ListItem.STYLE_ICON_TILE_SIZE = "iconTileSize"

---
-- Initialize a variables
function ListItem:_initInternal()
    ListItem.__super._initInternal(self)
    self._themeName = "ListItem"
    self._data = nil
    self._dataIndex = nil
    self._focusEnabled = false
    self._selected = false
    self._iconImage = nil
    self._iconDataField = "iconNo"
end

---
-- Create the children.
function ListItem:_createChildren()
    self:_createIconImage()
    ListItem.__super._createChildren(self)
end

---
-- Create the iconImage.
function ListItem:_createIconImage()
    if self._iconImage then
        return
    end
    if not self:getStyle(ListItem.STYLE_ICON_TEXTURE) then
        return
    end

    self._iconImage = SheetImage(self:getStyle(ListItem.STYLE_ICON_TEXTURE))
    self._iconImage:setTileSize(unpack(self:getStyle(ListItem.STYLE_ICON_TILE_SIZE)))
    self._iconImage:setVisible(self:getStyle(ListItem.STYLE_ICON_TEXTURE) or false)
    self:addChild(self._iconImage)
end

---
-- Update the display.
function ListItem:updateDisplay()
    ListItem.__super.updateDisplay(self)

    if self._iconImage and self._iconImage:getIndex() > 0 then
        local textLabel = self._textLabel
        local textW, textH = textLabel:getSize()
        local textX, textY = textLabel:getPos()
        local padding = 5

        local icon = self._iconImage
        local iconW, iconH = icon:getSize()
        icon:setPos(textX, textY + math.floor((textH - iconH) / 2))

        textLabel:setSize(textW - iconW - padding, textH)
        textLabel:addLoc(iconW + padding, 0, 0)
    end
end

---
-- Set the data and rowIndex.
-- @param data data
-- @param dataIndex index of the data
function ListItem:setData(data, dataIndex)
    self._data = data
    self._dataIndex = dataIndex

    local textLabel = self._textLabel
    textLabel:setString(self:getText())

    if self._iconImage then
        self._iconImage:setIndex(self:getIconIndex())
    end
end

---
-- Return the data.
-- @return data
function ListItem:getData()
    return self._data
end

---
-- Return the data index.
-- @return data index
function ListItem:getDataIndex()
    return self._dataIndex
end

---
-- Return the icon index.
-- @return icon index
function ListItem:getIconIndex()
    return self._data and self._data[self._iconDataField] or 0
end

---
-- Set the selected.
function ListItem:setSelected(selected)
    self._selected = selected
    self:setBackgroundVisible(selected)
end

---
-- Returns true if selected.
-- @return true if selected
function ListItem:isSelected()
    return self._selected
end

---
-- Returns the text.
-- @return text
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

---
-- Returns the labelField.
-- @return labelField
function ListItem:getLabelField()
    if self.parent then
        return self.parent:getLabelField()
    end
end

---
-- Sets the icon visible.
function ListItem:setIconVisible(iconVisible)
    self:setStyle(ListItem.STYLE_ICON_VISIBLE)

    if self._iconImage then
        self._iconImage:setVisible(iconVisible)
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

---
-- Initializes the internal variables.
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

---
-- Initializes the event listener.
function Slider:_initEventListeners()
    Slider.__super._initEventListeners(self)
    self:addEventListener(Event.TOUCH_DOWN, self.onTouchDown, self)
    self:addEventListener(Event.TOUCH_UP, self.onTouchUp, self)
    self:addEventListener(Event.TOUCH_MOVE, self.onTouchMove, self)
    self:addEventListener(Event.TOUCH_CANCEL, self.onTouchCancel, self)
end

---
-- Create children.
function Slider:_createChildren()
    Slider.__super._createChildren(self)
    self:_createBackgroundImage()
    self:_createProgressImage()
    self:_createThumbImage()
end

---
-- Create the backgroundImage.
function Slider:_createBackgroundImage()
    if self._backgroundImage then
        return
    end
    self._backgroundImage = NineImage(self:getStyle(Slider.STYLE_BACKGROUND_TEXTURE))
    self:addChild(self._backgroundImage)
end

---
-- Create the progressImage.
function Slider:_createProgressImage()
    if self._progressImage then
        return
    end
    self._progressImage = NineImage(self:getStyle(Slider.STYLE_PROGRESS_TEXTURE))
    self:addChild(self._progressImage)
end

---
-- Create the progressImage.
function Slider:_createThumbImage()
    if self._thumbImage then
        return
    end
    self._thumbImage = Image(self:getStyle(Slider.STYLE_THUMB_TEXTURE))
    self:addChild(self._thumbImage)
end

---
-- Update the display.
function Slider:updateDisplay()
    Slider.__super.updateDisplay(self)
    self:updateBackgroundImage()
    self:updateProgressImage()
end

---
-- Update the backgroundImage.
function Slider:updateBackgroundImage()
    local width = self:getWidth()
    local height = self._backgroundImage:getHeight()
    self._backgroundImage:setSize(width, height)
end

---
-- Update the progressImage.
function Slider:updateProgressImage()
    local width = self:getWidth()
    local height = self._progressImage:getHeight()
    self._progressImage:setSize(width * (self._currValue / self._maxValue), height)
    self._thumbImage:setLoc(width * (self._currValue / self._maxValue), height / 2)
end

---
-- Set the value of the current.
-- @param value value of the current
function Slider:setValue(value)
    if self._currValue == value then
        return
    end

    self._currValue = value
    self:updateProgressImage()
    self:dispatchEvent(UIEvent.VALUE_CHANGED, self._currValue)
end

---
-- Return the value of the current.
-- @return value of the current
function Slider:getValue()
    return self._currValue
end

---
-- Sets the background texture.
-- @param texture texture
function Slider:setBackgroundTexture(texture)
    self:setStyle(Slider.STYLE_BACKGROUND_TEXTURE, texture)
    self._backgroundImage:setImage(self:getStyle(Slider.STYLE_BACKGROUND_TEXTURE))
end

---
-- Sets the progress texture.
-- @param texture texture
function Slider:setProgressTexture(texture)
    self:setStyle(Slider.STYLE_PROGRESS_TEXTURE, texture)
    self._progressImage:setImage(self:getStyle(Slider.STYLE_PROGRESS_TEXTURE))
end

---
-- Sets the thumb texture.
-- @param texture texture
function Slider:setThumbTexture(texture)
    self:setStyle(Slider.STYLE_THUMB_TEXTURE, texture)
    self._thumbImage:setTexture(self:getStyle(Slider.STYLE_THUMB_TEXTURE))
end

---
-- Set the event listener that is called when the user click the Slider.
-- @param func click event handler
function Slider:setOnValueChanged(func)
    self:setEventListener(UIEvent.VALUE_CHANGED, func)
end

---
-- Down the Slider.
-- There is no need to call directly to the basic.
-- @param worldX Touch worldX
function Slider:doSlide(worldX)
    local width = self:getWidth()
    local left = self:getLeft()
    local modelX = worldX - left

    modelX = math.min(modelX, width)
    modelX = math.max(modelX, 0)
    self:setValue(modelX / width)
end

---
-- This event handler is called when you touch the Slider.
-- @param e Touch Event
function Slider:onTouchDown(e)
    if self._touchDownIdx then
        return
    end

    self._touchDownIdx = e.idx
    self:doSlide(e.wx)
end

---
-- This event handler is called when the Slider is released.
-- @param e Touch Event
function Slider:onTouchUp(e)
    if self._touchDownIdx ~= e.idx then
        return
    end
    self._touchDownIdx = nil
    self:doSlide(e.wx)
end

---
-- This event handler is called when you move on the Slider.
-- @param e Touch Event
function Slider:onTouchMove(e)
    if self._touchDownIdx ~= e.idx then
        return
    end
    if self:inside(e.wx, e.wy, 0) then
        self:doSlide(e.wx)
    end
end

---
-- This event handler is called when you cancel the touch.
-- @param e Touch Event
function Slider:onTouchCancel(e)
    if self._touchDownIdx ~= e.idx then
        return
    end
    self._touchDownIdx = nil
    self:doSlide(e.wx)
end

----------------------------------------------------------------------------------------------------
-- @type ScrollView
-- Scrollable UIView class.
----------------------------------------------------------------------------------------------------
ScrollView = class(UIView)
M.ScrollView = ScrollView

--- Style: friction
ScrollView.STYLE_FRICTION = "friction"

--- Style: scrollPolicy
ScrollView.STYLE_SCROLL_POLICY = "scrollPolicy"

--- Style: bouncePolicy
ScrollView.STYLE_BOUNCE_POLICY = "bouncePolicy"

--- Style: scrollForceBounds
ScrollView.STYLE_SCROLL_FORCE_BOUNDS = "scrollForceBounds"

---
-- Initializes the internal variables.
function ScrollView:_initInternal()
    ScrollView.__super._initInternal(self)
    self._themeName = "ScrollView"
    self._scrollForceX = 0
    self._scrollForceY = 0
    self._scrollGroup = nil
    self._looper = nil
    self._touchDownIndex = nil
    self._lastTouchX = nil
    self._lastTouchY = nil
    self._scrollToAnim = nil
end

---
-- Performing the initialization processing of the event listener.
function ScrollView:_initEventListeners()
    ScrollView.__super._initEventListeners(self)
    self.layer:addEventListener(Event.TOUCH_DOWN, self.onScrollLayerTouchDown, self, -20)
    self.layer:addEventListener(Event.TOUCH_UP, self.onScrollLayerTouchUp, self, -20)
    self.layer:addEventListener(Event.TOUCH_MOVE, self.onScrollLayerTouchMove, self, -20)
    self.layer:addEventListener(Event.TOUCH_CANCEL, self.onScrollLayerTouchCancel, self, -20)
end

---
-- Performing the initialization processing of the component.
function ScrollView:_createChildren()
    self._scrollGroup = UIGroup {
        size = {self:getSize()}
    }

    self:addChild(self._scrollGroup)
end

---
-- Adjusted so as to fall within the scope of the scroll.
function ScrollView:_ajustScrollPosition()
    local left, top = self:getScrollPos()
    local clipLeft, clipTop = self:clipScrollPosition(left, top)
    local hBounceEnabled, vBounceEnabled = self:getBouncePolicy()

    left = hBounceEnabled and left or clipLeft
    top = vBounceEnabled and top or clipTop

    self:setScrollPos(left, top)
end

---
-- Adjust the scroll size.
function ScrollView:_ajustScrollSize()
    if not self._autoResizing then
        return
    end
    
    local width, height = 0, 0
    local minWidth, minHeight = self.layer:getSize()
    
    for i, child in ipairs(self:getChildren()) do
       width  = math.max(width, child:getRight())
       height = math.max(height, child:getBottom())
    end

    width = width >= minWidth and width or minWidth
    height = height >= minHeight and height or minHeight

    self._scrollGroup:setSize(width, height)
end

---
-- If it is out of the boundary, to bounce.
-- @return True if to bouncing.
function ScrollView:_doBounce()
    if self:isScrolling() or self:isScrollAnimating() then
        return false
    end

    local left, top = self:getScrollPos()
    if self:isPositionOutOfBounds(left, top) then
        local clippedLeft, clippedTop = self:clipScrollPosition(left, top)
        self:scrollTo(clippedLeft, clippedTop, 0.5, MOAIEaseType.SOFT_EASE_IN)
        return true
    end    
end

---
-- Update of the scroll processing.
function ScrollView:_doUpdateScroll()
    if self:isTouching() then
        return
    end
    if not self:isScrolling() then
        return
    end

    local left, top = self:getScrollPos()
    local scrollX, scrollY = self:getScrollForceVec()
    local rateX, rateY = (1 - self:getFriction()), (1 - self:getFriction())

    rateX = self:isPositionOutOfHorizontal(left) and rateX * 0.35 or rateX
    rateY = self:isPositionOutOfVertical(top) and rateY * 0.35 or rateY

    self:addScrollPos(scrollX, scrollY)
    self:setScrollForceVec(scrollX * rateX, scrollY * rateY)
end

---
-- Sets the scene for layer.
-- @param scene scene
function ScrollView:setScene(scene)
    if self.layer.scene then
        self.layer.scene:removeEventListener(Event.CLOSE, self.onSceneClose, self, -10)
        self:dispose()
    end

    ScrollView.__super.setScene(self, scene)

    if self.layer.scene then
        self.layer.scene:addEventListener(Event.CLOSE, self.onSceneClose, self, -10)
        self._looper = Executors.callLoop(self.onEnterFrame, self)
    end
end

---
-- Dispose resources.
function ScrollView:dispose()
    if self._looper then
        self._looper:stop()
        self._looper = nil
    end
end

---
-- Add the content to scrollGroup.
-- @param content
function ScrollView:addContent(content)
    self._scrollGroup:addChild(content)
end

---
-- Add the content from scrollGroup.
-- @param content
function ScrollView:removeContent(content)
    self._scrollGroup:removeChild(content)
end

---
-- Add the content from scrollGroup.
-- @param contents
function ScrollView:setContents(contents)
    self._scrollGroup:setChildren(contents)
end

---
-- Return the scrollGroup.
-- @return scrollGroup
function ScrollView:getScrollGroup()
    return self._scrollGroup
end

---
-- Return the scrollGroup.
-- @return scrollGroup
function ScrollView:setScrollGroup(scrollGroup)
    self:removeChild(self._scrollGroup)
    self._scrollGroup = assert(scrollGroup)
    self:addChild(self._scrollGroup)

    self:invalidate()
end

---
-- Computes attenuation as a function of distance.
-- @param distance Distance
-- @return distance^(-2/3)
function ScrollView:attenuation(distance)
    distance = distance == 0 and 1 or math.pow(distance, 0.667)
    return 1 / distance
end

---
-- Also changes the size of the scroll container when layout update.
function ScrollView:updateLayout()
    ScrollView.__super.updateLayout(self)
    self:_ajustScrollSize()
end

---
-- Set the layout.
-- @param layout layout
function ScrollView:setLayout(layout)
    self._scrollGroup:setLayout(layout)
end

---
-- Set the coefficient of friction at the time of scrolling.
-- @param value friction
function ScrollView:setFriction(value)
    self:setStyle(ScrollView.STYLE_FRICTION, value)
end

---
-- Returns the coefficient of friction at the time of scrolling.
-- @return friction
function ScrollView:getFriction()
    return self:getStyle(ScrollView.STYLE_FRICTION)
end

---
-- Sets the horizontal and vertical scroll enabled.
-- @param horizontal horizontal scroll is enabled.
-- @param vertical vertical scroll is enabled.
function ScrollView:setScrollPolicy(horizontal, vertical)
    if horizontal == nil then horizontal = true end
    if vertical == nil then vertical = true end

    self:setStyle(ScrollView.STYLE_SCROLL_POLICY, {horizontal, vertical})
end

---
-- Return the scroll policy.
-- @return horizontal scroll enabled.
-- @return vertical scroll enabled.
function ScrollView:getScrollPolicy()
    return unpack(self:getStyle(ScrollView.STYLE_SCROLL_POLICY))
end

---
-- Sets the horizontal and vertical bounce enabled.
-- @param horizontal horizontal scroll is enabled.
-- @param vertical vertical scroll is enabled.
function ScrollView:setBouncePolicy(horizontal, vertical)
    if horizontal == nil then horizontal = true end
    if vertical == nil then vertical = true end

    self:setStyle(ScrollView.STYLE_BOUNCE_POLICY, {horizontal, vertical})
end

---
-- Returns whether horizontal bouncing is enabled.
-- @return horizontal bouncing enabled
-- @return vertical bouncing enabled
function ScrollView:getBouncePolicy()
    return unpack(self:getStyle(ScrollView.STYLE_BOUNCE_POLICY))
end

---
-- If this component is scrolling returns true.
-- @return scrolling
function ScrollView:isScrolling()
    return self._scrollForceX ~= 0 or self._scrollForceY~= 0
end

---
-- Sets the scroll position.
-- @param x x-position.
-- @param y y-position.
function ScrollView:setScrollPos(x, y)
    self._scrollGroup:setPos(x, y)
end

---
-- Sets the scroll position.
-- @param x x-position.
-- @param y y-position.
function ScrollView:addScrollPos(x, y)
    self._scrollGroup:addLoc(x, y, 0)
end

---
-- Returns the scroll position.
-- @return x-position.
-- @return y-position.
function ScrollView:getScrollPos()
    return self._scrollGroup:getPos()
end

---
-- Sets the force to scroll in one frame.
-- It does not make sense if you're touch.
-- @param x x force
-- @param y y force
function ScrollView:setScrollForceVec(x, y)
    local hScrollEnabled, vScrollEnabled = self:getScrollPolicy()
    local minScrollX, minScrollY, maxScrollX, maxScrollY = self:getScrollForceBounds()
    local scrollX, scrollY = self:getScrollForceVec()
    
    scrollX = hScrollEnabled and x or 0
    scrollX = (-minScrollX < scrollX and scrollX < minScrollX) and 0 or scrollX
    scrollX = scrollX < -maxScrollX and -maxScrollX or scrollX
    scrollX = maxScrollX < scrollX  and  maxScrollX or scrollX

    scrollY = vScrollEnabled and y or 0
    scrollY = (-minScrollY < scrollY and scrollY < minScrollY) and 0 or scrollY
    scrollY = scrollY < -maxScrollY and -maxScrollY or scrollY
    scrollY = maxScrollY < scrollY  and  maxScrollY or scrollY
    
    self._scrollForceX = scrollX
    self._scrollForceY = scrollY
end

---
-- Returns the force to scroll in one frame.
-- @return x force
-- @return y force
function ScrollView:getScrollForceVec()
    return self._scrollForceX, self._scrollForceY
end

---
-- Sets the scroll force in one frame.
-- @param minX x force
-- @param minY y force
-- @param maxX x force
-- @param maxY y force
function ScrollView:setScrollForceBounds(minX, minY, maxX, maxY)
    self:setStyle(ScrollView.STYLE_SCROLL_FORCE_BOUNDS, {minX, minY, maxX, maxY})
end

---
-- Returns the maximum force in one frame.
-- @param x force
-- @param y force
function ScrollView:getScrollForceBounds()
    return unpack(self:getStyle(ScrollView.STYLE_SCROLL_FORCE_BOUNDS))
end

---
-- If the user has touched returns true.
-- @return If the user has touched returns true.
function ScrollView:isTouching()
    return self._touchDownIndex ~= nil
end

---
-- Scroll to the specified location.
-- @param x position of the x
-- @param y position of the x
-- @param sec second
-- @param mode EaseType
-- @param callback (optional) allows callback notification when animation completes.
function ScrollView:scrollTo(x, y, sec, mode, callback)
    local x, y = self:clipScrollPosition(x, y)
    local px, py, pz = self._scrollGroup:getPiv()
    mode = mode or MOAIEaseType.SHARP_EASE_IN

    self:stopScrollAnimation()
    self._scrollToAnim = self._scrollGroup:seekLoc(x + px, y + py, 0, sec, mode)
end

---
-- Computes the boundaries of the scroll area.
-- @return the min and max values of the scroll area
function ScrollView:getScrollBounds()
    local childWidth, childHeight = self._scrollGroup:getSize()
    local parentWidth, parentHeight = self:getSize()
    local minX, minY = parentWidth - childWidth, parentHeight - childHeight
    local maxX, maxY = 0, 0

    return minX, minY, maxX, maxY
end

---
-- Returns whether the input position is out of bounds.
-- @param left The x position
-- @param top The y position
-- @return boolean
function ScrollView:isPositionOutOfBounds(left, top)
    local minX, minY, maxX, maxY = self:getScrollBounds()

    return left < minX or left > maxX or top < minY or top > maxY
end

---
-- Returns whether the input position is out of bounds.
-- @param left The x position
-- @return boolean
function ScrollView:isPositionOutOfHorizontal(left)
    local minX, minY, maxX, maxY = self:getScrollBounds()

    return left < minX or left > maxX
end

---
-- Returns whether the input position is out of bounds.
-- @param left The x position
-- @return boolean
function ScrollView:isPositionOutOfVertical(top)
    local minX, minY, maxX, maxY = self:getScrollBounds()

    return top < minY or top > maxY
end

---
-- Clips the input position to the size of the container
-- @param left The x position
-- @param top The y position
-- @return clipped left and top
function ScrollView:clipScrollPosition(left, top)
    local minX, minY, maxX, maxY = self:getScrollBounds()
    left = left < minX and minX or left
    left = left > maxX and maxX or left
    top  = top  < minY and minY or top
    top  = top  > maxY and maxY or top

    return left, top
end

---
-- Returns whether the scrollTo animation is running.
-- @return boolean
function ScrollView:isScrollAnimating()
    return self._scrollToAnim and self._scrollToAnim:isBusy()
end

---
-- Stops the scrollTo animation if it's running
-- @return none
function ScrollView:stopScrollAnimation()
    if self._scrollToAnim then
        self._scrollToAnim:stop()
        self._scrollToAnim = nil
    end
end

---
-- Update frame.
function ScrollView:onEnterFrame()
    if self:_doBounce() then
        return
    end

    self:_doUpdateScroll()
end

---
-- This event handler is called when scene closed.
-- @param e touch event
function ScrollView:onSceneClose(e)
    self:dispose()
end

---
-- This event handler is called when you touch the component.
-- @param e touch event
function ScrollView:onScrollLayerTouchDown(e)
    if self:isTouching() then
        return
    end

    self._scrollForceX = 0
    self._scrollForceY = 0
    self._touchDownIndex = e.idx
    self._lastTouchX = e.wx
    self._lastTouchY = e.wy

    self:stopScrollAnimation()
end

---
-- This event handler is called when you touch the component.
-- @param e touch event
function ScrollView:onScrollLayerTouchUp(e)
    if self._touchDownIndex ~= e.idx then
        return
    end
    
    self._touchDownIndex = nil
    self._lastTouchX = nil
    self._lastTouchY = nil
end

---
-- This event handler is called when you touch the component.
-- @param e touch event
function ScrollView:onScrollLayerTouchMove(e)
    if self._touchDownIndex ~= e.idx then
        return
    end

    local moveX, moveY = e.wx - self._lastTouchX , e.wy - self._lastTouchY
    self:setScrollForceVec(moveX, moveY)
    moveX, moveY = self:getScrollForceVec()

    local minX, minY, maxX, maxY = self:getScrollBounds()
    local left, top = self:getScrollPos()
    local newLeft, newTop = left + moveX, top + moveY

    local clippedLeft, clippedTop = self:clipScrollPosition(newLeft, newTop)
    local diff = math.distance(clippedLeft, clippedTop, newLeft, newTop)
    local hBounceEnabled, vBounceEnabled = self:getBouncePolicy()

    if self:isPositionOutOfHorizontal(newLeft) then
        moveX = hBounceEnabled and (self:attenuation(diff) * moveX) or 0
    end
    if self:isPositionOutOfVertical(newTop) then
        moveY = vBounceEnabled and (self:attenuation(diff) * moveY) or 0
    end

    self:addScrollPos(moveX, moveY, 0)
    self._lastTouchX = e.wx
    self._lastTouchY = e.wy
end

---
-- This event handler is called when you touch the component.
-- @param e touch event
function ScrollView:onScrollLayerTouchCancel(e)
    if self._touchDownIndex ~= e.idx then
        return
    end

    self._touchDownIndex = nil
    self._lastTouchX = nil
    self._lastTouchY = nil
end


-- widget initialize
M.initialize()

return M
