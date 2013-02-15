--------------------------------------------------------------------------------
-- Class is a object of TMXMap.
--------------------------------------------------------------------------------

local class = require("hp/lang/class")

local M = class()

-- constraints
M.ATTRIBUTE_NAMES = {"name", "type", "x", "y", "width", "height", "gid"}

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function M:init()
    self.name = ""
    self.type = ""
    self.x = 0
    self.y = 0
    self.width = 0
    self.height = 0
    self.gid = nil
    self.properties = {}
end

return M
