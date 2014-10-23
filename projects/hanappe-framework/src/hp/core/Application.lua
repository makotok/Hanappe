--------------------------------------------------------------------------------
-- Module for the start of the application.<br>
--
-- @class table
-- @name Application
--------------------------------------------------------------------------------

-- import
local Event                 = require "hp/event/Event"
local EventDispatcher       = require "hp/event/EventDispatcher"
local InputManager          = require "hp/manager/InputManager"

-- class
local M                     = EventDispatcher()
local super                 = EventDispatcher

--------------------------------------------------------------------------------
-- Start the application. <br>
-- You can specify the behavior of the entire application by the config.
-- @param config
--------------------------------------------------------------------------------
function M:start(config)

    local title = config.title
    local screenWidth = config.screenWidth or MOAIEnvironment.horizontalResolution
    local screenHeight = config.screenHeight or MOAIEnvironment.verticalResolution 
    local viewScale = config.viewScale or 1
    local viewWidth = screenWidth / viewScale
    local viewHeight = screenHeight / viewScale

    self.title = title
    self.screenWidth = screenWidth
    self.screenHeight = screenHeight
    self.viewWidth = viewWidth
    self.viewHeight = viewHeight
    self.viewScale = viewScale

    MOAISim.openWindow(title, screenWidth, screenHeight)
    InputManager:initialize()
end

--------------------------------------------------------------------------------
-- Returns whether the mobile execution environment.
-- @return True in the case of mobile.
--------------------------------------------------------------------------------
function M:isMobile()
    local brand = MOAIEnvironment.osBrand
    return brand == 'Android' or brand == 'iOS'
end

--------------------------------------------------------------------------------
-- Returns whether the desktop execution environment.
-- @return True in the case of desktop.
--------------------------------------------------------------------------------
function M:isDesktop()
    return not self:isMobile()
end

--------------------------------------------------------------------------------
-- Returns true if the Landscape mode.
-- @return true if the Landscape mode.
--------------------------------------------------------------------------------
function M:isLandscape()
    local w, h = MOAIGfxDevice.getViewSize()
    return w > h
end

--------------------------------------------------------------------------------
-- Sets the background color.
--------------------------------------------------------------------------------
function M:setClearColor(r, g, b, a)
    MOAIGfxDevice.setClearColor(r, g, b, a)
end

--------------------------------------------------------------------------------
-- Returns the scale of the Viewport to the screen.
-- @return scale of the x-direction, scale of the y-direction,
--------------------------------------------------------------------------------
function M:getViewScale()
    return self.viewScale
end


return M
