-- requires
local table         = require "hp/lang/table"
local Display       = require "hp/modules/Display"
local Managers      = require "hp/modules/Managers"
local Physics       = require "hp/modules/Physics"
local Tiled         = require "hp/modules/Tiled"
local GUI           = require "hp/modules/GUI"

-- global imports
table.copy(Display, _G)
table.copy(Managers, _G)
table.copy(Physics, _G)
table.copy(Tiled, _G)
_G.GUI = GUI
