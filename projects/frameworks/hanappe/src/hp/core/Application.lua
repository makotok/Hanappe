--------------------------------------------------------------------------------
-- Module for the start of the application.<br>
-- 
-- @class table
-- @name Application
--------------------------------------------------------------------------------
local M = {}

local defaultConfig = {
    title = "title",
    screenWidth = 320,
    screenHeight = 480,
    viewWidth = 320,
    viewHeight = 480,
    landscape = false,
    showWindow = true,
    useInputManager = true,
}

local function getScreenSize(self, config)
    local w, h = config.screenWidth, config.screenHeight
    if self:isMobile() then
        local w, h = assert(MOAIEnvironment.horizontalResolution), assert(MOAIEnvironment.verticalResolution)
    end
    if config.landscape then
        return h, w
    end
    return w, h
end

local function getViewSize(self, config)
    local w, h = config.viewWidth, config.viewHeight
    if config.landscape then
        return h, w
    end
    return w, h
end

--------------------------------------------------------------------------------
-- Start the application. <br>
-- You can specify the behavior of the entire application by the config.
-- @param config
--------------------------------------------------------------------------------
function M:start(config)
    if not config then
        config = defaultConfig
    end
    
    local title = config.title
    local screenWidth, screenHeight = getScreenSize(self, config)
    local viewWidth, viewHeight = getViewSize(self, config)
    local inputManager = require("hp/manager/InputManager")
    
    self.title = title
    self.screenWidth = screenWidth
    self.screenHeight = screenHeight
    self.viewWidth = viewWidth
    self.viewHeight = viewHeight
    self.showWindow = config.showWindow
    
    if self.showWindow then
        MOAISim.openWindow(title, screenWidth, screenHeight)
    end
    if config.useInputManager then
        inputManager:initialize()
    end
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
    return self.screenWidth / self.viewWidth, self.screenHeight / self.viewHeight
end

return M