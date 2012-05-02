-- package config
-- To specify the directory in the source.
package.path = package.path .. ';src/main/?.lua'

-- Hanappe Application config
local config = {
    title = "hanappe samples",
    screenWidth = 320,
    screenHeight = 480,
    viewWidth = 320,
    viewHeight = 480,
    landscape = false,
    showWindow = true,
    useInputManager = true,
}
return config