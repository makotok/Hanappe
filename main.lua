-- requires
local Application = require("hp/Application")

-- application start
local config = require("config")
Application:appStart(config)

-- classes import
Application:importClasses(_G, "")

SceneManager:openScene("samples/sample_main", {animation = "fade"})
