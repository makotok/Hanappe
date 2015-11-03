arg = nil

-- import
flower = require "flower"
tests = require "tests"
require "LuaUnit"

-- setting
local screenWidth = 320
local screenHeight = 480

-- open scene
flower.openWindow("Flower samples", screenWidth, screenHeight)

-- run tests
LuaUnit:setVerbosity( 1 )
LuaUnit:run(unpack(tests))
--os.exit(LuaUnit:run(unpack(tests)))
