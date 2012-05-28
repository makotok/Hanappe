-- package config
-- To specify the directory in the source.
package.path = package.path .. ';src/main/?.lua'

-- Hanappe Application config
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
return config