--------------------------------------------------------------------------------
-- Hanappe Application config
--------------------------------------------------------------------------------
local config = {
    title = "Hanappe samples",
    
    -- iPhone 3GS
    screenWidth = 320,
    screenHeight = 480,
    viewWidth = 320,
    viewHeight = 480,
    
    -- iPhone 4S
    --[[
    screenWidth = 320 * 2,
    screenHeight = 480 * 2,
    viewWidth = 320,
    viewHeight = 480,
    --]]
    
    -- iPad
    --[[
    screenWidth = 768,
    screenHeight = 1024,
    viewWidth = 768,
    viewHeight = 1024,
    --]]
    
    -- New iPad
    --[[
    screenWidth = 768 * 2,
    screenHeight = 1024 * 2,
    viewWidth = 768,
    viewHeight = 1024,
    --]]
    
    -- TODO:Scale mode
    --scaleMode = "NON_SCALE",
    
    landscape = false,
    showWindow = true,
    useInputManager = true,
}

--------------------------------------------------------------------------------
-- Hanappe Application customize
--------------------------------------------------------------------------------

local WidgetManager     = require("hp/manager/WidgetManager")
local FontManager       = require("hp/manager/FontManager")

-- Widget themes setting.
WidgetManager:setDefaultThemes("themes/basic/Themes")

-- Font setting
FontManager.DEFAULT_FONT = "fonts/ipag.ttf"

return config