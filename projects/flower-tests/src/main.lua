arg = nil

-- import
flower = require "flower"
tests = require "tests"
require "LuaUnit"

-- setting
local screenWidth = MOAIEnvironment.horizontalResolution or 320
local screenHeight = MOAIEnvironment.verticalResolution or 480
local screenDpi = MOAIEnvironment.screenDpi or 120
local viewScale = math.floor(screenDpi / 240) + 1

-- open scene
flower.openWindow("Flower samples", screenWidth, screenHeight, viewScale)

-- run tests
LuaUnit:setVerbosity( 1 )
LuaUnit:run(unpack(tests))
--os.exit(LuaUnit:run(unpack(tests)))
