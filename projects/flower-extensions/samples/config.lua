-- import
local flower = require "flower"

-- module
local M = {}

--------------------------------------------------------------------------------
-- MOAI SDK
--------------------------------------------------------------------------------

-- Setting the FPS
MOAISim.setStep(1 / 60)

-- Setting of the operation of the Loop.
MOAISim.clearLoopFlags()
MOAISim.setLoopFlags(MOAISim.SIM_LOOP_ALLOW_BOOST)
MOAISim.setLoopFlags(MOAISim.SIM_LOOP_LONG_DELAY)

-- Sets the boost threshold
MOAISim.setBoostThreshold(0)

--------------------------------------------------------------------------------
-- Flower
--------------------------------------------------------------------------------

-- Resources setting
flower.Resources.addResourceDirectory("assets")

-- Set the window title
flower.DEFAULT_WINDOW_TITLE = "Flower extensions"

-- Set the display size
flower.setDefaultDisplaySize("iPhone5", false, false)

--- default width of the screen
--M.DEFAULT_SCREEN_WIDTH = 320

--- default height of the screen
--M.DEFAULT_SCREEN_HEIGHT = 480

--- default scale of the viewport
--M.DEFAULT_VIEWPORT_SCALE = 1

--- default y behavior; set to true to have y=0 be the bottom of the screen
flower.DEFAULT_VIEWPORT_YFLIP = false

-- Optional table of arguments for setBlendMode on new images.
-- Empty table gives default behavior.
flower.DEFAULT_BLEND_MODE = nil

-- High quality rendering of Label
-- When enabled, it may take a long time to display the label.
flower.Label.HIGH_QUALITY_ENABLED = true

-- Set the default font
flower.Font.DEFAULT_FONT = "VL-PGothic.ttf"

-- Set the default font charcodes
-- Optimized by setting the loadable string in advance.
flower.Font.DEFAULT_CHARCODES = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 .,:;!?()&/-"

-- Default font points
flower.Font.DEFAULT_POINTS = 24

-- Set the texture filter of default
--flower.Texture.DEFAULT_FILTER = MOAITexture.GL_LINEAR
flower.Texture.DEFAULT_FILTER = MOAITexture.GL_NEAREST

-- Setting of the behavior of the InputMgr
-- Whether to fire a touch event on the desktop environment
flower.InputMgr.TOUCH_EVENT_ENABLED = true

-- Whether to fire a mouse event on the desktop environment
flower.InputMgr.MOUSE_EVENT_ENABLED = true

--------------------------------------------------------------------------------
-- Debugging
--------------------------------------------------------------------------------

-- Show bounds of MOAIProp
--flower.DebugUtils.showDebugLines()

-- Start performance log
flower.DebugUtils.startPerformanceLog()

return M
