--------------------------------------------------------------------------------
-- Class that inherits from MOAIBox2DFixture.<br>
--------------------------------------------------------------------------------

local table = require("hp/lang/table")
local class = require("hp/lang/class")

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
-- Destroys the Fixture.
--------------------------------------------------------------------------------
function M:destroy()
    local body = self:getBody()
    Interface.destroy(self)
    
    local fixtures = body:getFixtures()
    table.removeElement(fixtures, self)
end

--------------------------------------------------------------------------------
-- Sets the name.
-- @param name
--------------------------------------------------------------------------------
function M:setName(name)
    self._name = name
end

--------------------------------------------------------------------------------
-- Returns the name.
-- @return name
--------------------------------------------------------------------------------
function M:getName()
    return self._name
end

return M