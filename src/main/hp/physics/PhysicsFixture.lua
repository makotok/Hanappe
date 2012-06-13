local table = require("hp/lang/table")
local class = require("hp/lang/class")

--------------------------------------------------------------------------------
-- Class that inherits from MOAIBox2DWorld.<br>
-- TODO:Not implemented
-- @class table
-- @name PhysicsWorld
--------------------------------------------------------------------------------
local M = class()

local Interface = MOAIBox2DFixture.getInterfaceTable()

--------------------------------------------------------------------------------
-- The constructor.
-- @param obj MOAIBox2DFixture instance.
--------------------------------------------------------------------------------
function M:new(obj, ...)
    table.copy(self, assert(obj))
    
    if obj.init then
        obj:init(...)
    end
    
    obj.new = nil
    obj.init = nil
    
    return obj
end

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function M:init(params)
    if params then
        self:copyParams(params)
    end
end

--------------------------------------------------------------------------------
-- Set the parameter setter function.
-- @param params Parameter is set to Object.<br>
-- (params:pe_fixture_id, name, density, friction, restitution, filter)
--------------------------------------------------------------------------------
function M:copyParams(params)
    if params.pe_fixture_id then
        self:setName(params.pe_fixture_id)
    end
    if params.name then
        self:setName(params.name)
    end
    if params.density then
        self:setDensity(params.density)
    end
    if params.friction then
        self:setFriction(params.friction)
    end
    if params.restitution then
        self:setRestitution(params.restitution)        
    end
    if params.filter then
        local filter = params.filter
        self:setFilter(filter.categoryBits, filter.maskBits, filter.groupIndex)
    end
end

--------------------------------------------------------------------------------
-- Fixtureを破棄します.
-- Bodyからも削除されます.
--------------------------------------------------------------------------------
function M:destroy()
    local body = self:getBody()
    Interface.destroy(self)
    
    local fixtures = body:getFixtures()
    table.removeElement(fixtures, self)
end

--------------------------------------------------------------------------------
-- 名前を設定します.
-- @param name
--------------------------------------------------------------------------------
function M:setName(name)
    self:setPrivate("name", name)
end

--------------------------------------------------------------------------------
-- 名前を返します.
-- @return name
--------------------------------------------------------------------------------
function M:getName()
    return self:getPrivate("name")
end

return M