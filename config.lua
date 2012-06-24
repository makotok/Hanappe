-- package config
-- To specify the directory in the source.
package.path = package.path .. ';src/main/?.lua'

--------------------------------------------------------------------------------
-- Hanappe Application config
--------------------------------------------------------------------------------
local config = {
    title = "hanappe samples",
    
    -- iPhone 3GS
    screenWidth = 320,
    screenHeight = 480,
    viewWidth = 320,
    viewHeight = 480,
    
    -- iPhone 4S
    --[[
    screenWidth = 640,
    screenHeight = 960,
    viewWidth = 640,
    viewHeight = 960,
    --]]
    
    -- iPad
    --[[
    screenWidth = 768,
    screenHeight = 1024,
    viewWidth = 768,
    viewHeight = 1024,
    --]]
    
    landscape = false,
    showWindow = true,
    useInputManager = true,
}

--------------------------------------------------------------------------------
-- Hanappe Application customize
--------------------------------------------------------------------------------

local classes = require("classes")

-- Shader setting.
classes.ShaderManager.SHADERS_DIRECTORY = "src/main/hp/shader/"

-- Widget themes setting.
classes.WidgetManager:setDefaultThemes("assets/themes/basic/Themes")

-- Font setting
classes.FontManager.DEFAULT_FONT = "assets/fonts/ipag.ttf"

-- TextLabel setting
classes.TextLabel.DEFAULT_COLOR = {1, 1, 1, 1}
classes.TextLabel.DEFAULT_TEXT_SIZE = 24

-- Background color style.
--[[
classes.Application:setClearColor(1, 1, 1, 1)
classes.TextLabel.DEFAULT_COLOR = {0, 0, 0, 1}
--]]

return config