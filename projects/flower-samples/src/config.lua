-- import
flower = require "flower"

--------------------------------------------------------------------------------
-- Flower
--------------------------------------------------------------------------------

-- Set the screen size
flower.DEFAULT_SCREEN_WIDTH = MOAIEnvironment.horizontalResolution or 320
flower.DEFAULT_SCREEN_HEIGHT = MOAIEnvironment.verticalResolution or 480

-- Set the scale of the Viewport
flower.DEFAULT_VIEWPORT_SCALE = 1

-- High quality rendering of Label
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

--------------------------------------------------------------------------------
-- MOAI SDK
--------------------------------------------------------------------------------

-- MOAISim settings
MOAISim.setStep(1 / 60)
MOAISim.clearLoopFlags()
MOAISim.setLoopFlags(MOAISim.SIM_LOOP_ALLOW_BOOST)
MOAISim.setLoopFlags(MOAISim.SIM_LOOP_LONG_DELAY)
MOAISim.setBoostThreshold(0)


-- debug
--[[
MOAIDebugLines.setStyle ( MOAIDebugLines.TEXT_BOX, 1, 1, 1, 1, 1 )
MOAIDebugLines.setStyle ( MOAIDebugLines.TEXT_BOX_LAYOUT, 1, 0, 0, 1, 1 )
MOAIDebugLines.setStyle ( MOAIDebugLines.TEXT_BOX_BASELINES, 1, 1, 0, 0, 1 )
MOAIDebugLines.setStyle ( MOAIDebugLines.PROP_MODEL_BOUNDS, 2, 1, 1, 1 )
MOAIDebugLines.setStyle ( MOAIDebugLines.PROP_WORLD_BOUNDS, 2, 0.75, 0.75, 0.75 )
]]



return {}