-- requires
local config    = require("config")
local classes   = require("classes")
local Application = require("hp/core/Application")

-- Application start.
Application:start(config)

-- test run
require("TestCase")
require("luaunit")
LuaUnit:run()
