local config = require("config")
local TestCase = require("TestCase")
local Application = require("hp/Application")

Application:appStart(config)

-- test run
require("luaunit")
LuaUnit:run()
