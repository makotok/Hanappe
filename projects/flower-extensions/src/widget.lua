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
local Event = flower.Event
local Image = flower.Image
local NineImage = flower.NineImage
local Group = flower.Group

-- classes
local PropertyUtils
local PriorityQueue
local LayoutMgr
local ThemeMgr
local FocusMgr
local UIComponent
local UIGroup
local View
local ScrollView
local ListView
local Button
local TextInput
local Panel
local MsgBox
local Layout
local BoxLayout
local FormLayout

----------------------------------------------------------------------------------------------------
-- Constraints
----------------------------------------------------------------------------------------------------

local BUILTIN_THEME = {
    Button = {
        normalTexture = "skins/button_normal.9.png",
        selectedTexture = "skins/button_selected.9.png",
        disabledTexture = "skins/button_disabled.9.png",
        font = "VL-PGothic.ttf",
        textSize = 24,
        textColor = {0, 0, 0, 1},
        horizotalAlign = "center",
        verticalAlign = "center",
    },
    TextInput = {
    
    },
    Panel = {
        panelTexture = "skins/panel_base.9.png",
    },
    MsgBox = {
        panelTexture = "skins/panel_base.9.png",
        font = "VL-PGothic.ttf",
        textSize = 24,
        textColor = {0, 0, 0, 1},
    },
    Joystick = {
        baseTexture = "skins/joystick_base.png",
        knobTexture = "skins/joystick_knob.png",
    },
    ListView = {
    
    
    },
}

----------------------------------------------------------------------------------------------------
-- Public functions
----------------------------------------------------------------------------------------------------

function M.initialize()
    if not M.initialized then
        return
    end
    
    M.layoutMgr = LayoutMgr()
    M.themeMgr = ThemeMgr()
    M.focusMgr = FocusMgr()
    
    M.setTheme(BUILTIN_THEME)
end

function M.setTheme(theme)
    M.themeMgr:setTheme(theme)
end

function M.getTheme()
    return M.themeMgr:getTheme()
end

function M.getLayoutMgr()
    return M.layoutMgr
end

function M.getThemeMgr()
    return M.themeMgr
end

function M.getFocusMgr()
    return M.focusMgr
end

----------------------------------------------------------------------------------------------------
-- @type PropertyUtils
-- It is a property utility class.
----------------------------------------------------------------------------------------------------

PropertyUtils = {}
M.PropertyUtils = PropertyUtils

PropertyUtils.SETTER_NAMES = {}
PropertyUtils.GETTER_NAMES = {}

--------------------------------------------------------------------------------
-- Sets the properties to object.
-- 
--------------------------------------------------------------------------------
function PropertyUtils.setProperties(obj, params, unpackFlag)
    for k, v in pairs(params) do
        PropertyUtils.setProperty(obj, k, v, unpackFlag)
    end
end

--------------------------------------------------------------------------------
-- オブジェクトのsetter関数経由で値を設定します.
--------------------------------------------------------------------------------
function PropertyUtils.setProperty(obj, name, value, unpackFlag)
    local setterNames = PropertyUtils.SETTER_NAMES[name]
    if not setterNames[name] then
        local setterName = "set" .. name:sub(1, 1):upper() .. (#name > 1 and name:sub(2) or "")
        setterNames[name] = setterName
    end

    local setterName = setterNames[name]
    local setter = assert(obj[setterName], "Not Found Property!" .. name)
    if not unpackFlag or type(value) ~= "table" or getmetatable(value) ~= nil then
        return setter(obj, value)
    else
        return setter(obj, unpack(value))
    end
end

--------------------------------------------------------------------------------
-- オブジェクトのgetter関数経由で値を返します.
--------------------------------------------------------------------------------
function PropertyUtils.getProperty(obj, name)
    local getterName = M.getGetterName(name)
    local getter = obj[getterName]
    if getter then
        return getter(obj)
    end
end

----------------------------------------------------------------------------------------------------
-- @type PriorityQueue
----------------------------------------------------------------------------------------------------
PriorityQueue = class()

----------------------------------------
-- コンストラクタです.
-- @param comparetor
----------------------------------------
function PriorityQueue:init(comparetor)
    assert(comparetor, "comparetor is nil!")
    self.queue = {}
    self.comparetor = comparetor
end

----------------------------------------
-- オブジェクトを順序付けて追加します.
-- @param object オブジェクト
----------------------------------------
function PriorityQueue:push(object)
    self:remove(object)

    local comparetor = assert(self.comparetor)
    local index = 0
    for i, v in ipairs(self.queue) do
        index = i
        if comparetor(object, v) > 0 then
            break
        end
    end
    index = index + 1
    table.insert(self.queue, index, object)
end

----------------------------------------
-- キューの先頭オブジェクト削除してから返します.<br>
-- キューに存在しない場合はnilを返します.
-- @return object
----------------------------------------
function PriorityQueue:poll()
    if self:size() > 0 then
        return table.remove(self.queue, 1)
    end
    return nil
end

----------------------------------------
-- 指定したインデックスのオブジェクトを返します.
-- @param i インデックス
-- @return object
----------------------------------------
function PriorityQueue:get(i)
    return self.queue[i]
end


----------------------------------------
-- 指定したオブジェクトが存在する場合削除します.
-- 存在しない場合は削除しません.
-- @param object オブジェクト
-- @return 削除した場合はそのオブジェクト
----------------------------------------
function PriorityQueue:remove(object)
    for i, v in ipairs(self.queue) do
        if object == v then
            return table.remove(self.queue, i)
        end
    end
    return nil
end

----------------------------------------
-- キューの内容をクリアします.
----------------------------------------
function PriorityQueue:clear()
    self.queue = {}
end

----------------------------------------
-- キューのサイズを返します.
-- @return キューのサイズ.
----------------------------------------
function PriorityQueue:size()
    return #self.queue
end

----------------------------------------------------------------------------------------------------
-- @type LayoutMgr
----------------------------------------------------------------------------------------------------
LayoutMgr = class()
M.LayoutMgr = LayoutMgr

LayoutMgr.ASC_COMPARETOR = function(a, b) 
    local alevel = a:getNestLevel()
    local blevel = b:getNestLevel()
    
    if alevel < blevel then
        return -1
    elseif alevel == blevel then
        return 0
    else
        return 1
    end
end

LayoutMgr.DESC_COMPARETOR = function(a, b) 
    return ascComparetor(a, b) * -1
end

function LayoutMgr:init()
    self._callOncePushed = false
    self._invalidateDisplayFlag = false
    self._invalidateLayoutFlag = false
    self._invalidateDisplayQueue = PriorityQueue(self.DESC_COMPARETOR)
    self._invalidateLayoutQueue = PriorityQueue(self.DESC_COMPARETOR)
end

function LayoutMgr:validate()
    self:validateDisplay()
    self:validateLayout()
end

function LayoutMgr:validateDisplay()
    if not self._invalidateDisplayFlag then
        return
    end

    local object = self._invalidateDisplayQueue:poll()
    while object do
        object:validateDisplay()
        object = self._invalidateDisplayQueue:poll()
    end
    self._invalidateDisplayFlag = false
end

function LayoutMgr:validateLayout()
    if not self._invalidateLayoutFlag then
        return
    end

    local object = invalidateLayoutQueue:poll()
    while object do
        object:validateLayout()
        object = self._invalidateLayoutQueue:poll()
    end
    self._invalidateLayoutFlag = false
end

function LayoutMgr:invalidateDisplay(object)
    self.invalidateDisplayFlag = true
    self.invalidateDisplayQueue:push(object)
    self:callOnceValidate()
end

function LayoutMgr:invalidateLayout(object)
    self._invalidateLayoutFlag = true
    self._invalidateLayoutQueue:push(object)
    self:callOnceValidate()
end

function LayoutMgr:callOnceValidate()
    if not self._callOncePushed then
        self._callOncePushed = true
        Executors.callOnce(function()
            self:validate()
            self._callOncePushed = false
        end)
    end
end

----------------------------------------------------------------------------------------------------
-- @type ThemeMgr
----------------------------------------------------------------------------------------------------
ThemeMgr = class()
M.ThemeMgr = ThemeMgr

--- Event: themeChanged
ThemeMgr.EVENT_THEME_CHANGED = "themeChanged"

function ThemeMgr:init()
    self.theme = BUILTIN_THEME
end

function ThemeMgr:setTheme(theme)
    if self.theme ~= theme then
        self.theme = theme
        self:dispatchEvent(ThemeMgr.EVENT_THEME_CHANGED)
    end
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
    if self.focusObject then
        self.focusObject:dispatchEvent(UIComponent.EVENT_FOCUS_OUT)
    end
    
    self.focusObject = object
    
    if self.focusObject then
        self.focusObject:dispatchEvent(UIComponent.EVENT_FOCUS_IN)
    end
end

function FocusMgr:getFocusObject()
    return self.focusObject
end

----------------------------------------------------------------------------------------------------
-- @type UIComponent
-- This class is an image that can be pressed.
-- It is a simple button.
----------------------------------------------------------------------------------------------------
UIComponent = class(Group)
M.UIComponent = UIComponent

--- Event: Resize Event
UIComponent.EVENT_RESIZE = "resize"

--- Event: Theme changed Event
UIComponent.EVENT_THEME_CHANGED = "themeChanged"

--- Event: Style changed Event
UIComponent.EVENT_STYLE_CHANGED = "styleChanged"

--- Event: Style changed Event
UIComponent.EVENT_PROPERTY_CHANGED = "propertyChanged"

--- Event: FocusIn Event
UIComponent.EVENT_FOCUS_IN = "focusIn"

--- Event: FocusOut Event
UIComponent.EVENT_FOCUS_OUT = "focusOut"

--------------------------------------------------------------------------------
-- Constructor.
-- Please do not inherit this constructor.
-- Please have some template functions are inherited.
-- @param params Parameter table
--------------------------------------------------------------------------------
function UIComponent:init(params)
    Group.init(self)
    self:initInternal(params)
    self:initEventListeners(params)
    self:initComponent(params)
end

--------------------------------------------------------------------------------
-- Initialization is the process of internal variables.
-- Please to inherit this function if the definition of the variable.
--------------------------------------------------------------------------------
function UIComponent:initInternal(params)
    self.isComponent = true
    
    self._enabled = true
    self._focusEnabled = true
    self._theme = nil
    self._styles = {}
    self._properties = {}
    self._layout = nil
    self._excludeLayout = false
    self._invalidDisplayFlag = false
    self._invalidLayoutFlag = false
end

--------------------------------------------------------------------------------
-- Performing the initialization processing of the event listener.
-- Please to inherit this function if you want to initialize the event listener.
--------------------------------------------------------------------------------
function UIComponent:initEventListeners(params)
    self:addEventListener(Event.TOUCH_DOWN, self.onTouchCommon, self, -10)
    self:addEventListener(Event.TOUCH_UP, self.onTouchCommon, self, -10)
    self:addEventListener(Event.TOUCH_MOVE, self.onTouchCommon, self, -10)
    self:addEventListener(Event.TOUCH_CANCEL, self.onTouchCommon, self, -10)
end

--------------------------------------------------------------------------------
-- Performing the initialization processing of the component.
-- Please to inherit this function if you want to change the behavior of the component.
-- @param params Parameter table
--------------------------------------------------------------------------------
function UIComponent:initComponent(params)
    self:createChildren()
    self:invalidateAll()
    
    PropertyUtils.setProperties(self, params, true)
end

--------------------------------------------------------------------------------
-- To create a child components.
-- Please be inherited as necessary.
--------------------------------------------------------------------------------
function UIComponent:createChildren()
end

--------------------------------------------------------------------------------
-- Scheduling the update process of the component.
--------------------------------------------------------------------------------
function UIComponent:invalidateAll()
    self:invalidateDisplay()
    self:invalidateLayout()
end

--------------------------------------------------------------------------------
-- Scheduling the process of updating the display.
--------------------------------------------------------------------------------
function UIComponent:invalidateDisplay()
    if not self._invalidDisplayFlag then
        local layoutMgr = self:getLayoutMgr()
        layoutMgr:invalidateDisplay(self)

        self._invalidDisplayFlag = true
    end
end

--------------------------------------------------------------------------------
-- Scheduling the process of updating the layout.
--------------------------------------------------------------------------------
function UIComponent:invalidateLayout()
    if not self._invalidLayoutFlag then
        local parent = self.parent
        local layoutMgr = self:getLayoutMgr()
        
        if parent and parent.isComponent then
            parent:invalidateLayout()
        end
        
        layoutMgr:invalidateLayout(self)
        self._invalidLayoutFlag = true
    end
end

--------------------------------------------------------------------------------
-- Validation of the component.
-- This process is heavy.
-- Use when you want to determine the size and layout of the component.
--------------------------------------------------------------------------------
function UIComponent:validateAll(updateChildrenFlag)
    self:validateDisplay(updateChildrenFlag)
    self:validateLayout(updateChildrenFlag)
end

--------------------------------------------------------------------------------
-- Validation of the display.
-- This process is heavy.
-- Use when you want to determine the size and layout of the component.
--------------------------------------------------------------------------------
function UIComponent:validateDisplay(updateChildrenFlag)
    if updateChildrenFlag then
        for i, child in ipairs(self:getChildren()) do
            if child.validateDisplay then
                child:validateDisplay(updateChildrenFlag)
            end
        end
    end

    if self._invalidDisplayFlag then
        self:updateDisplay()
        self._invalidDisplayFlag = false
    end
end

--------------------------------------------------------------------------------
-- Validation of the layout.
-- This process is heavy.
-- Use when you want to determine the size and layout of the component.
-- @param updateChildrenFlag Children are also updated
--------------------------------------------------------------------------------
function UIComponent:validateLayout(updateChildrenFlag)
    if updateChildrenFlag then
        for i, child in ipairs(self:getChildren()) do
            if child.validateLayout then
                child:validateLayout(updateChildrenFlag)
            end
        end
    end
    if self._invalidLayoutFlag then
        self:updateLayout()
        self._invalidLayoutFlag = false
    end
end

--------------------------------------------------------------------------------
-- Update the display.
-- This method is called at the time you need to update the display.
--------------------------------------------------------------------------------
function UIComponent:updateDisplay()
end

--------------------------------------------------------------------------------
-- Update the layout.
--------------------------------------------------------------------------------
function UIComponent:updateLayout()
    if self._layout then
        self._layout:update(self)
    end
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
-- Add the child component.
-- After adding performs scheduling of the layout.
-- @param child the child component
-- @return TODO:
--------------------------------------------------------------------------------
function UIComponent:addChild(child)
    if Group.addChild(self, child) then
        self:invalidateLayout()
        return true
    end
    return false
end

--------------------------------------------------------------------------------
-- Remove the child component.
-- @param child the child component
-- @return TODO:
--------------------------------------------------------------------------------
function UIComponent:removeChild(child)
    if Group.removeChild(self, child) then
        self:invalidateLayout()
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
        self:invalidateAll()        
        self:dispatchEvent(UIComponent.EVENT_RESIZE)
    end
end

--------------------------------------------------------------------------------
-- Set the enabled state.
-- @param value enabled
--------------------------------------------------------------------------------
function UIComponent:setEnabled(value)
    self:setProperty("enabled", value)
    self:invalidateDisplay()
end

--------------------------------------------------------------------------------
-- Returns the enabled.
-- @return enabled
--------------------------------------------------------------------------------
function UIComponent:isEnabled()
    return self:getProperty("enabled")
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
    return self:getFocusMgr():getFocusObject() == self
end

--------------------------------------------------------------------------------
-- Returns the focus.
-- @return focus
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
        self:invalidateAll()
        self:dispatchEvent(UIComponent.EVENT_THEME_CHANGED)
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
    
    local globalTheme = M.getTheme()
    if self.THEME_NAME then
        return globalTheme[self.THEME_NAME]
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
        self:invalidateDisplay()
        self:dispatchEvent(UIComponent.EVENT_STYLE_CHANGED, {styleName = name, styleValue = value})
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
-- Sets the style of the component.
-- @param name style name
-- @param value style value
--------------------------------------------------------------------------------
function UIComponent:setProperty(name, value)
    if self._properties[name] ~= value then
        self._properties[name] = value
        self:dispatchEvent(UIComponent.EVENT_PROPERTY_CHANGED, {propName = name, propValue = value})
    end
end

--------------------------------------------------------------------------------
-- Returns the style.
-- @param name style name
-- @return style value
--------------------------------------------------------------------------------
function UIComponent:getProperty(name)
    return self._properties[name]
end

--------------------------------------------------------------------------------
-- Set the layout.
-- When you set the layout, the update process of layout class is called when resizing.
-- The position of the component is automatically updated.
-- @param layout layout object
--------------------------------------------------------------------------------
function UIComponent:setLayout(layout)
    if self._layout ~= layout then
        self._layout = layout
        self:invalidateLayout()
    end
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
    if self._excludeLayout ~= excludeLayout then
        self._excludeLayout = excludeLayout
        self:invalidateLayout()
    end
end

--------------------------------------------------------------------------------
-- Return whether or not to set the layout automatically.
--------------------------------------------------------------------------------
function UIComponent:isExcludeLayout()
    return self._excludeLayout
end

--------------------------------------------------------------------------------
-- Returns the layoutMgr.
-- @return layoutMgr
--------------------------------------------------------------------------------
function UIComponent:getLayoutMgr()
    return M.getLayoutMgr()
end

--------------------------------------------------------------------------------
-- Returns the layoutMgr.
-- @return layoutMgr
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
-- This event handler is called when touch.
-- @param e Touch Event
--------------------------------------------------------------------------------
function UIComponent:onTouchCommon(e)
    if not self:isEnabled() then
        e:stop()
    end
    if e.type == "touchDown" then
        if self:isFocusEnabled() then
            local focusMgr = self:getFocusMgr()
            focusMgr:setFocusObject(self)
        end
    end
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
function UIGroup:initInternal(params)
    UIGroup.initInternal(self, params)
    self:setFocusEnabled(false)
end



----------------------------------------------------------------------------------------------------
-- @type ImageButton
-- This class is an image that can be pressed.
-- It is a simple button.
----------------------------------------------------------------------------------------------------
Button = class(UIComponent)
M.Button = Button

--- Theme name
Button.THEME_NAME = "Button"

--- Align map
Button.HORIZOTAL_ALIGNS = {
    left    = MOAITextBox.LEFT_JUSTIFY,
    center  = MOAITextBox.CENTER_JUSTIFY,
    right   = MOAITextBox.RIGHT_JUSTIFY,
}

--- Align map
Button.VERTICAL_ALIGNS = {
    top     = MOAITextBox.LEFT_JUSTIFY,
    center  = MOAITextBox.CENTER_JUSTIFY,
    bottom  = MOAITextBox.RIGHT_JUSTIFY,
}

--- Click Event
Button.EVENT_CLICK = "click"

--- Button down Event
Button.EVENT_BUTTON_DOWN = "buttonDown"

--- Button up Event
Button.EVENT_BUTTON_UP = "buttonUp"

--- Style: normalTexture
Button.STYLE_NORMAL_TEXTURE = "normalTexture"

--- Style: selectedTexture
Button.STYLE_SELECTED_TEXTURE = "selectedTexture"

--- Style: selectedTexture
Button.STYLE_DISABLED_TEXTURE = "disabledTexture"

--- Style: textSize
Button.STYLE_TEXT_SIZE = "textSize"

--- Style: font
Button.STYLE_FONT = "font"

--- Style: horizotalAlign
Button.STYLE_HORIZOTAL_ALIGN = "horizotalAlign"

--- Style: verticalAlign
Button.STYLE_VERTICAL_ALIGN = "verticalAlign"

--------------------------------------------------------------------------------
-- The constructor.
-- @param 
--------------------------------------------------------------------------------
function Button:initInternal(params)
    UIComponent.initInternal(self, params)
    self._touchDownIdx = nil
    self._currentImageDeck = nil
    self._currentTextSize = nil
    self._currentFont = nil
    self._currentHorizotalAlign = nil
    self._currentVerticalAlign = nil
    self._buttonImage = nil
    self._text = params.text or ""
    self._textLabel = nil
end

function Button:initEventListeners(params)
    UIComponent.initEventListeners(self, params)
    self:addEventListener(Event.TOUCH_DOWN, self.onTouchDown, self)
    self:addEventListener(Event.TOUCH_UP, self.onTouchUp, self)
    self:addEventListener(Event.TOUCH_MOVE, self.onTouchMove, self)
    self:addEventListener(Event.TOUCH_CANCEL, self.onTouchCancel, self)
end

function Button:initComponent(params)
    UIComponent.initComponent(self, params)
    
    self._currentImageDeck = self:getNewImageDeck()
    self._buttonImage = NineImage(self._currentImageDeck)
    self:addChild(self._buttonImage)
    
    self._textLabel = Label(self._text, 100, 30)
    self:addChild(self._textLabel)
    
    self:setSize(self._buttonImage:getSize())
end

function Button:updateDisplay()
    -- button image
    do
        local buttonImage = self._buttonImage
        local newImageDeck = self:getNewImageDeck()
        if newImageDeck ~= self._currentImageDeck then
            self._currentImageDeck = newImageDeck
            buttonImage:setImageDeck(self._currentImageDeck)
        end
        buttonImage:setSize(self:getSize())
    end
    
    -- text label
    do
        local textLabel = self._textLabel
        local xMin, yMin, xMax, yMax = self._buttonImage:getContentRect()
        local textWidth, textHeight = xMax - xMin, yMax - yMin
        local currentTextWidth, currentTextHeight = self._textLabel:getSize()
        
        -- position
        textLabel:setPos(xMin, yMin)
        
        -- size
        if currentTextWidth ~= textWidth or currentTextHeight ~= textHeight then
            textLabel:setSize(textWidth, textHeight)
        end
        
        -- textSize
        if self._currentTextSize ~= textSize then
            self._currentTextSize = textSize
            textLabel:setTextSize(textSize)
        end
        
        -- text align
        local horizotalAlign = self:getStyle(Button.STYLE_HORIZOTAL_ALIGN)
        local verticalAlign = self:getStyle(Button.STYLE_VERTICAL_ALIGN)
        if self._currentHorizotalAlign ~= horizotalAlign or self._currentVerticalAlign ~= verticalAlign then
            local h = Button.HORIZOTAL_ALIGNS[horizotalAlign]
            local v = Button.VERTICAL_ALIGNS[verticalAlign]
            textLabel:setAlignment(h, v)
        end
        
        -- font
        local font = self:getStyle(Button.STYLE_FONT)
        local textSize = self:getStyle(Button.STYLE_TEXT_SIZE)
        if self._currentFont ~= font then
            self._currentFont = font
            font = Resources.getFont(self._currentFont, nil, textSize)
            textLabel:setFont(self._currentFont)
            textLabel:setTextSize()
        end
    end
end

function Button:getNewImageDeck()
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
-- Sets the text.
-- @param text text
--------------------------------------------------------------------------------
function Button:setText(text)
    if self._text ~= text then
        self._text = text
        self._textLabel:setString(text)
    end
end

--------------------------------------------------------------------------------
-- Returns the text.
-- @param text text
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
end

--------------------------------------------------------------------------------
-- Sets the textSize.
-- @param textSize textSize
--------------------------------------------------------------------------------
function Button:setFont(font)
    self:setStyle(Button.STYLE_FONT, font)
end

--------------------------------------------------------------------------------
-- Sets the text align.
-- @param horizotalAlign horizotal align
-- @param verticalAlign vertical align
--------------------------------------------------------------------------------
function Button:setTextAlign(horizotalAlign, verticalAlign)
    self:setStyle(Button.STYLE_HORIZOTAL_ALIGN, horizotalAlign)
    self:setStyle(Button.STYLE_VERTICAL_ALIGN, verticalAlign)
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
    self._buttonImage:setImageDeck(self:getNewImageDeck())
    
    self:dispatchEvent(Button.EVENT_BUTTON_DOWN)
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
    self._buttonImage:setImageDeck(self:getNewImageDeck())
    
    self:dispatchEvent(Button.EVENT_BUTTON_UP)
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
    self:dispatchEvent(Button.EVENT_CLICK)
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
Joystick = class(Group)
M.Joystick = Joystick

--- Event type when you change the position of the stick
Joystick.EVENT_STICK_CHANGED   = "stickChanged"

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

--- Default texture
Joystick.DEFAULT_BASE_TEXTURE  = "skins/joystick_base.png"

--- Default texture
Joystick.DEFAULT_KNOB_TEXTURE  = "skins/joystick_knob.png"

--------------------------------------------------------------------------------
-- The constructor.
-- @param baseTexture Joystick base texture
-- @param knobTexture Joystick knob texture
--------------------------------------------------------------------------------
function Joystick:init(baseTexture, knobTexture)
    Group.init(self)
    self._touchDownFlag = false
    self._rangeOfCenterRate = Joystick.RANGE_OF_CENTER_RATE
    self._stickMode = Joystick.MODE_ANALOG
    self._changedEvent = Event(Joystick.EVENT_STICK_CHANGED)
    self._baseTexture = baseTexture or Joystick.DEFAULT_BASE_TEXTURE
    self._knobTexture = knobTexture or Joystick.DEFAULT_KNOB_TEXTURE
    
    self:initChildren()
    self:initEventListeners()
end

--------------------------------------------------------------------------------
-- Initialize child objects that make up the Joystick.
-- You must not be called directly.
--------------------------------------------------------------------------------
function Joystick:initChildren()
    self._baseImage = Image(self._baseTexture)
    self._knobImage = Image(self._knobTexture)
    
    self:addChild(self._baseImage)
    self:addChild(self._knobImage)

    self:setSize(self._baseImage:getSize())
    self:setCenterKnob()
end

--------------------------------------------------------------------------------
-- Initializes the event listener.
-- You must not be called directly.
--------------------------------------------------------------------------------
function Joystick:initEventListeners()
    self:addEventListener("touchDown", self.onTouchDown, self)
    self:addEventListener("touchUp", self.onTouchUp, self)
    self:addEventListener("touchMove", self.onTouchMove, self)
    self:addEventListener("touchCancel", self.onTouchCancel, self)
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
-- This event handler is called when touched.
-- @param e Touch Event
--------------------------------------------------------------------------------
function Joystick:onTouchDown(e)
    if self._touchDownFlag then
        return
    end

    local mx, my = self:worldToModel(e.wx, e.wy, 0)
    self._touchDownFlag = true
    self._touchIndex = e.idx
    self:updateKnob(mx, my)
end

--------------------------------------------------------------------------------
-- This event handler is called when the button is released.
-- @param e Touch Event
--------------------------------------------------------------------------------
function Joystick:onTouchUp(e)
    if not self._touchDownFlag then
        return
    end
    if e.idx ~= self._touchIndex then
        return
    end

    self._touchDownFlag = false
    local cx, cy = self:getCenterLoc()
    self:updateKnob(cx, cy)
end

--------------------------------------------------------------------------------
-- This event handler is called when you move on the button.
-- @param e Touch Event
--------------------------------------------------------------------------------
function Joystick:onTouchMove(e)
    if not self._touchDownFlag then
        return
    end
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
    self._touchDownFlag = false
    self:setCenterKnob()
end


-- widget initialize
M.initialize()

return M
