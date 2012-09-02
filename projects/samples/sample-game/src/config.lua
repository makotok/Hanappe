--------------------------------------------------------------------------------
-- Hanappe config
--------------------------------------------------------------------------------
local config = {
    title = "Fall Cat",
    screenWidth = 320,
    screenHeight = 480,
    viewWidth = 320,
    viewHeight = 480,
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