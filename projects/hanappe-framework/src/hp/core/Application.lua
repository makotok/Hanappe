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

-- local functions
local function getDeviceSize()
    return MOAIEnvironment.horizontalResolution or 0, MOAIEnvironment.verticalResolution or 0
end

local function getScreenSize(config)
    local w, h = getDeviceSize()
    w = w > 0 and w or config.screenWidth
    h = h > 0 and h or config.screenHeight

    if config.landscape then
        if w > h then
            return w, h
        end
        return h, w
    else
        if w < h then
            return w, h
        end
        return h, w
    end
end

local function getViewSize(config)
    local w, h = getScreenSize(config)

    local scaleX, scaleY = math.floor(w / config.viewWidth), math.floor(h / config.viewWidth)
    local scale = math.min(scaleX, scaleY)
    scale = scale < 1 and 1 or scale
    scale = scale > 2 and 2 or scale

    w, h  = math.floor(w / scale + 0.5), math.floor(h / scale + 0.5)
    return w, h, scale
end

--------------------------------------------------------------------------------
-- Start the application. <br>
-- You can specify the behavior of the entire application by the config.
-- @param config
--------------------------------------------------------------------------------
function M:start(config)

    local title = config.title
    local screenWidth, screenHeight = getScreenSize(config)
    local viewWidth, viewHeight, viewScale = getViewSize(config)

    self.title = title
    self.screenWidth = screenWidth
    self.screenHeight = screenHeight
    self.viewWidth = viewWidth
    self.viewHeight = viewHeight
    self.viewScale = viewScale

    MOAISim.openWindow(title, screenWidth, screenHeight)
    InputManager:initialize()

    --
    print("screenSize:", screenWidth, screenHeight)
    print("viewSize  :", viewWidth, viewHeight)
end

--------------------------------------------------------------------------------
-- Returns whether the mobile execution environment.
-- @return True in the case of mobile.
--------------------------------------------------------------------------------
function M:isMobile()
    local bland = MOAIEnvironment.osBrand
    return bland == MOAIEnvironment.OS_BRAND_ANDROID or bland == MOAIEnvironment.OS_BRAND_IOS
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
