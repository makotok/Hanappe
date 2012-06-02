local table = require("hp/lang/table")
local class = require("hp/lang/class")

--------------------------------------------------------------------------------
-- Class that inherits from MOAIBox2DWorld.<br>
-- TODO:Not implemented
-- @class table
-- @name PhysicsWorld
--------------------------------------------------------------------------------
local M = class()


local BODY_TYPES = {
    dynamic = MOAIBox2DBody.DYNAMIC,
    static = MOAIBox2DBody.STATIC,
    kinematic = MOAIBox2DBody.KINEMATIC
}

function M:new()
    local obj = MOAIBox2DWorld.new()
    table.copy(self, obj)
    
    if obj.init then
        obj:init()
    end
    
    obj.init = nil
    obj.new = nil
    
    return obj
end

function M:init(params)
    
end

return M