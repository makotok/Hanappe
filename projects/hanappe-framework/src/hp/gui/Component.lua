----------------------------------------------------------------------------------------------------
-- This class defines the common behavior of the GUI.
----------------------------------------------------------------------------------------------------

-- imports
local table             = require "hp/lang/table"
local class             = require "hp/lang/class"
local Group             = require "hp/display/Group"
local Graphics          = require "hp/display/Graphics"
local Event             = require "hp/event/Event"
local Executors         = require "hp/util/Executors"
local ThemeManager      = require "hp/manager/ThemeManager"
local FocusManager      = require "hp/manager/FocusManager"
local LayoutManager     = require "hp/manager/LayoutManager"

-- class define
local super             = Group
local M                 = class(super)
local MOAIPropInterface = MOAIProp.getInterfaceTable()

-- Events
M.EVENT_TOUCH_DOWN      = "touchDown"
M.EVENT_TOUCH_MOVE      = "touchMove"
M.EVENT_TOUCH_CANCEL    = "touchCancel"
M.EVENT_TOUCH_UP        = "touchUp"
M.EVENT_RESIZE          = "resize"
M.EVENT_FOCUS_IN        = "focusIn"
M.EVENT_FOCUS_OUT       = "focusOut"
M.EVENT_ENABLED_CHANGED = "enabledChanged"
M.EVENT_STATE_CHANGED   = "stateChanged"
M.EVENT_ADDED           = "added"
M.EVENT_REMOVED         = "removed"
M.EVENT_CHILD_ADDED     = "childAdded"
M.EVENT_CHILD_REMOVED   = "childRemoved"

-- States
M.STATE_NORMAL          = "normal"
M.STATE_DISABLED        = "disabled"

local function dummeyIsIncludeLayout() return false end

--------------------------------------------------------------------------------
-- Constructor.
-- Please do not inherit this constructor.
-- Please have some template functions are inherited.
-- @param params Parameter table
--------------------------------------------------------------------------------
function M:init(params)
    super.init(self)
    self:initInternal()
    self:initEventListeners()
    self:initComponent(params)
end

--------------------------------------------------------------------------------
-- Initialization is the process of internal variables.
-- Please to inherit this function if the definition of the variable.
--------------------------------------------------------------------------------
function M:initInternal()
    self._enabled = true
    self._theme = nil
    self._themeName = "Component"
    self._styles = {}
    self._layout = nil
    self._includeLayout = true
    self._initialized = false
    self._invalidDisplayFlag = false
    self._invalidLayoutFlag = false
    self._currentState = M.STATE_NORMAL
    self._graphics = Graphics {parent = self}
    self._graphics.isIncludeLayout = dummeyIsIncludeLayout
end

--------------------------------------------------------------------------------
-- Performing the initialization processing of the event listener.
-- Please to inherit this function if you want to initialize the event listener.
--------------------------------------------------------------------------------
function M:initEventListeners()
    self:addEventListener(M.EVENT_TOUCH_DOWN, self.touchDownHandler, self)
    self:addEventListener(M.EVENT_TOUCH_MOVE, self.touchMoveHandler, self)
    self:addEventListener(M.EVENT_TOUCH_CANCEL, self.touchCancelHandler, self)
    self:addEventListener(M.EVENT_TOUCH_UP, self.touchUpHandler, self)
    self:addEventListener(M.EVENT_RESIZE, self.resizeHandler, self)
    self:addEventListener(M.EVENT_STATE_CHANGED, self.stateChangedHandler, self)
    self:addEventListener(M.EVENT_ENABLED_CHANGED, self.enabledChangedHandler, self)
end

--------------------------------------------------------------------------------
-- Performing the initialization processing of the component.
-- Please to inherit this function if you want to change the behavior of the component.
-- @param params Parameter table
--------------------------------------------------------------------------------
function M:initComponent(params)
    if self._initialized then
        return
    end
    
    self:initTheme(params)
    self:initStyles(params)
    self:createChildren()
    self:copyParams(params)

    self:invalidateAll()
    self._initialized = true
end

--------------------------------------------------------------------------------
-- Theme initialization process is performed.
-- @param params Parameter table
--------------------------------------------------------------------------------
function M:initTheme(params)
    if params and params.themeName then
        if type(params.themeName) == "table" then
            self:setThemeName(unpack(params.themeName))
        else
            self:setThemeName(params.themeName)
        end
    end
    local theme = ThemeManager:getComponentTheme(self:getThemeName()) or {}
    self:setTheme(theme)
end

--------------------------------------------------------------------------------
-- It is a component-specific style initialization process.
-- @param params Parameter table
--------------------------------------------------------------------------------
function M:initStyles(params)
    if params and params.styles then
        if type(params.styles) == "table" then
            self:setStyles(unpack(params.styles))
        else
            self:setStyles(params.styles)
        end
    end
end

--------------------------------------------------------------------------------
-- To create a child components.
-- Please be inherited as necessary.
--------------------------------------------------------------------------------
function M:createChildren()
end

--------------------------------------------------------------------------------
-- Scheduling the update process of the component.
--------------------------------------------------------------------------------
function M:invalidateAll()
    self:invalidateDisplay()
    self:invalidateLayout()
end

--------------------------------------------------------------------------------
-- Scheduling the process of updating the display.
--------------------------------------------------------------------------------
function M:invalidateDisplay()
    self._invalidDisplayFlag = true
    LayoutManager:invalidateDisplay(self)
end

--------------------------------------------------------------------------------
-- Scheduling the process of updating the layout.
--------------------------------------------------------------------------------
function M:invalidateLayout()
    local parent = self:getParent()
    
    if parent and parent.isComponent then
        parent:invalidateLayout()
    end
    
    LayoutManager:invalidateLayout(self)
    self._invalidLayoutFlag = true
end

--------------------------------------------------------------------------------
-- Validation of the component.
-- This process is heavy.
-- Use when you want to determine the size and layout of the component.
--------------------------------------------------------------------------------
function M:validateAll()
    self:validateDisplay()
    self:validateLayout()
end

--------------------------------------------------------------------------------
-- Validation of the display.
-- This process is heavy.
-- Use when you want to determine the size and layout of the component.
--------------------------------------------------------------------------------
function M:validateDisplay(updateChildrenFlag)
    if updateChildrenFlag then
        for i, child in ipairs(self:getChildren()) do
            if child.validateDisplay then
                child:validateDisplay()
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
function M:validateLayout(updateChildrenFlag)
    if updateChildrenFlag then
        for i, child in ipairs(self:getChildren()) do
            if child.validateLayout then
                child:validateLayout()
            end
        end
    end
    if self._invalidLayoutFlag then
        self:updateLayout()
        self._invalidLayoutFlag = false
    end
end

--------------------------------------------------------------------------------
-- Update the component.
-- You do not need to be called directly update process.
--------------------------------------------------------------------------------
function M:updateComponent()
    self:updateDisplay()
    self:updateLayout()
end

--------------------------------------------------------------------------------
-- Update the display.
-- This method is called at the time you need to update the display.
--------------------------------------------------------------------------------
function M:updateDisplay()

end

--------------------------------------------------------------------------------
-- Update the layout.
--------------------------------------------------------------------------------
function M:updateLayout()
    if self._layout then
        self._layout:update(self)
    end
end

--------------------------------------------------------------------------------
-- Add the child component.
-- After adding performs scheduling of the layout.
-- @param child the child component
--------------------------------------------------------------------------------
function M:addChild(child)
    if super.addChild(self, child) then
        child:dispatchEvent(M.EVENT_ADDED)
        self:dispatchEvent(M.EVENT_CHILD_ADDED)
        self:invalidateLayout()
        return true
    end
    return false
end

--------------------------------------------------------------------------------
-- Remove the child component.
-- @param child the child component
--------------------------------------------------------------------------------
function M:removeChild(child)
    if child == self._graphics then
        return false
    end

    if super.removeChild(self, child) then
        child:dispatchEvent(M.EVENT_REMOVED)
        self:dispatchEvent(M.EVENT_CHILD_REMOVED)
        self:invalidateLayout()
        return true
    end
    return false
end

--------------------------------------------------------------------------------
-- Sets the state of the component.
-- To update the display by the state.
-- @param state state
--------------------------------------------------------------------------------
function M:setCurrentState(state)
    if self:getCurrentState() ~= state then
        self._currentState = state
        
        local e = Event(M.EVENT_STATE_CHANGED)
        e.state = state
        self:dispatchEvent(e)
        
        self:invalidateDisplay()
    end
end

--------------------------------------------------------------------------------
-- Returns the state of the component.
-- @return state
--------------------------------------------------------------------------------
function M:getCurrentState()
    return self._currentState
end

--------------------------------------------------------------------------------
-- The function to be performed asynchronously.
-- @param func function
-- @param ... args
--------------------------------------------------------------------------------
function M:callLater(func, ...)
    Executors.callLater(func, ...)
end

----------------------------------------------------------------------------------------------------
-- Properties
----------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Set the enabled state.
-- @param value enabled
--------------------------------------------------------------------------------
function M:setEnabled(value)
    if self:isEnabled() ~= value then
        self._enabled = value
        self:dispatchEvent(M.EVENT_ENABLED_CHANGED)
        
        if value then
            self:setCurrentState(M.STATE_NORMAL)
        else
            self:setCurrentState(M.STATE_DISABLED)
        end
        
        self:invalidateDisplay()
    end
end

--------------------------------------------------------------------------------
-- Returns the enabled.
-- @return enabled
--------------------------------------------------------------------------------
function M:isEnabled()
    return self._enabled
end

--------------------------------------------------------------------------------
-- Returns whether the component can touch.
--------------------------------------------------------------------------------
function M:isTouchEnabled()
    return self._touchEnabled and self._enabled
end

--------------------------------------------------------------------------------
-- To set the focus.
-- TODO:Focus does not function.
-- @param value focus
--------------------------------------------------------------------------------
function M:setFocus(value)
    value = value or true
    
    local focusManager = self:getFocusManager()
    if focusManager then
        focusManager:setFocus(value and self or nil)
    end
end

--------------------------------------------------------------------------------
-- If the component has the focus, returns true.
-- TODO:Focus does not function.
-- @return focus
--------------------------------------------------------------------------------
function M:isFocus()
    local focusManager = self:getFocusManager()
    if focusManager then
        return focusManager:getFocus() == self
    end
    return false
end

--------------------------------------------------------------------------------
-- Returns the FocusManager
-- TODO:Focus does not function.
--------------------------------------------------------------------------------
function M:getFocusManager()
    return FocusManager
end

--------------------------------------------------------------------------------
-- Returns the focus enabled.
-- TODO:Focus does not function.
-- @return focus enabled
--------------------------------------------------------------------------------
function M:isFocusEnabled()
    return self._focusEnabled
end

--------------------------------------------------------------------------------
-- Set whether you can set focus.
-- @param Whether you can set focus
--------------------------------------------------------------------------------
function M:setFocusEnabled(value)
    self._focusEnabled = value
    
    if value == false and self:isFocus() then
        self:getFocusManager():setFocus(nil)
    end
end

--------------------------------------------------------------------------------
-- Set the layout.
-- When you set the layout, the update process of layout class is called when resizing.
-- The position of the component is automatically updated.
-- @param value layout object
--------------------------------------------------------------------------------
function M:setLayout(value)
    self._layout = value
    self:invalidateLayout()
end

--------------------------------------------------------------------------------
-- Returns a layout.
-- @return layout object
--------------------------------------------------------------------------------
function M:getLayout()
    return self._layout
end

--------------------------------------------------------------------------------
-- Set whether you want to update the position by the layout class.
--------------------------------------------------------------------------------
function M:setIncludeLayout(value)
    self._includeLayout = value
    self:invalidateLayout()
end

--------------------------------------------------------------------------------
-- Return whether or not to set the layout automatically.
--------------------------------------------------------------------------------
function M:isIncludeLayout()
    return self._includeLayout
end

--------------------------------------------------------------------------------
-- Change the size of the component.
-- Not be reflected in all objects immediately after the change.
-- be reflected to call updateSize.
-- @param width width
-- @param height height
--------------------------------------------------------------------------------
function M:setSize(width, height)
    width  = width  < 0 and 0 or width
    height = height < 0 and 0 or height

    local oldWidth, oldHeight =  self:getWidth(), self:getHeight()
    
    if oldWidth ~= width or oldHeight ~= height then
        super.setSize(self, width, height)

        local e = Event(M.EVENT_RESIZE)
        e.oldWidth, e.oldHeight = oldWidth, oldHeight
        e.newWidth, e.newHeight = width, height
        self:dispatchEvent(e)
        
        self:invalidateDisplay()
        self:invalidateLayout()
        self._graphics:setSize(width, height)
    end
end

--------------------------------------------------------------------------------
-- Returns the theme of the component.
-- @return theme
--------------------------------------------------------------------------------
function M:getTheme()
    return self._theme
end

--------------------------------------------------------------------------------
-- Sets the theme of the component.
-- @param value theme
--------------------------------------------------------------------------------
function M:setTheme(value)
    if self._theme ~= value then
        self._theme = value
        self:invalidateDisplay()
    end
end

--------------------------------------------------------------------------------
-- Returns the name of the theme of the component.
-- @return theme name
--------------------------------------------------------------------------------
function M:getThemeName()
    return self._themeName
end

--------------------------------------------------------------------------------
-- Sets the name of the theme of the component.
-- @param value theme name
--------------------------------------------------------------------------------
function M:setThemeName(value)
    if self._themeName ~= value then
        self._themeName = value
    end
end

--------------------------------------------------------------------------------
-- Set the component has all the styles.
-- @param styles styles
--------------------------------------------------------------------------------
function M:setStyles(styles)
    if self._styles ~= styles then
        self._styles = assert(styles)
        self:invalidateDisplay()
    end
end

--------------------------------------------------------------------------------
-- Returns the style of the current state.
-- @param name style name
-- @param state (option)state name
--------------------------------------------------------------------------------
function M:getStyle(name, state)
    state = state or self:getCurrentState()
    
    local theme = self:getTheme()
    local componentStyles = self._styles[state]
    local currentStyles = theme[state]
    local normalStyles = theme["normal"]
    
    if componentStyles and componentStyles[name] ~= nil then
        return componentStyles[name]
    end
    if currentStyles and currentStyles[name] ~= nil then
        return currentStyles[name]
    end
    if normalStyles and normalStyles[name] ~= nil then
        return normalStyles[name]
    end
end

--------------------------------------------------------------------------------
-- Sets the style of the component.
-- @param state state name
-- @param name style name
-- @param value style value
--------------------------------------------------------------------------------
function M:setStyle(state, name, value)
   self._styles[state] = self._styles[state] or {}
    local stateStyles = self._styles[state]
    stateStyles[name] = value
    
    self:invalidateDisplay()
end

--------------------------------------------------------------------------------
-- Set the event listener.
-- Event listener that you set in this function is one.
-- @param eventName event name
-- @param func event listener
--------------------------------------------------------------------------------
function M:setEventListener(eventName, func)
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
-- It is a function to determine whether the component.
-- @return true
--------------------------------------------------------------------------------
function M:isComponent()
    return true
end

----------------------------------------------------------------------------------------------------
-- Event Handler
----------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- This event handler is called when you touch the component.
-- @param e touch event
--------------------------------------------------------------------------------
function M:touchDownHandler(e)
end

--------------------------------------------------------------------------------
-- This event handler is called when you touch the component.
-- @param e touch event
--------------------------------------------------------------------------------
function M:touchUpHandler(e)
end

--------------------------------------------------------------------------------
-- This event handler is called when you touch the component.
-- @param e touch event
--------------------------------------------------------------------------------
function M:touchMoveHandler(e)
end

--------------------------------------------------------------------------------
-- This event handler is called when you touch the component.
-- @param e touch event
--------------------------------------------------------------------------------
function M:touchCancelHandler(e)
end

--------------------------------------------------------------------------------
-- This event handler is called when resizing.
-- @param e resize event
--------------------------------------------------------------------------------
function M:resizeHandler(e)
end

--------------------------------------------------------------------------------
-- This event handler is called when the state changes.
-- @param e event
--------------------------------------------------------------------------------
function M:stateChangedHandler(e)
end

--------------------------------------------------------------------------------
-- This event handler is called when the enabled state changes.
-- @param e event
--------------------------------------------------------------------------------
function M:enabledChangedHandler(e)
end
    
return M