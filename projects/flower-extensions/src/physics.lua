----------------------------------------------------------------------------------------------------
-- Physics Library.
-- @author Makoto
----------------------------------------------------------------------------------------------------

-- module
local M = {}

-- import
local flower = require "flower"
local class = flower.class
local table = flower.table
local PropertyUtils = flower.PropertyUtils
local Event = flower.Event
local DisplayObject = flower.DisplayObject

-- class
local B2World
local B2Body
local B2Fixture

-- variables
local MOAIBox2DWorldInterface = MOAIBox2DWorld.getInterfaceTable()
local MOAIBox2DBodyInterface = MOAIBox2DBody.getInterfaceTable()

----------------------------------------------------------------------------------------------------
-- @type ImageButton
-- This class is an image that can be pressed.
-- It is a simple button.
----------------------------------------------------------------------------------------------------
B2World = class()
B2World.__factory = MOAIBox2DWorld
M.B2World = B2World

--- Default Gravity
B2World.DEFUALT_GRAVITY = {0, 10}

--- Default UnitsToMeters
B2World.DEFAULT_UNITS_TO_METERS = 0.06

--- Constants representing the type of the Body.
B2World.BODY_TYPES = {
    dynamic = MOAIBox2DBody.DYNAMIC,
    static = MOAIBox2DBody.STATIC,
    kinematic = MOAIBox2DBody.KINEMATIC
}

--------------------------------------------------------------------------------
-- The constructor.
-- @param params 
--------------------------------------------------------------------------------
function B2World:init(params)
    self:setGravity(unpack(B2World.DEFUALT_GRAVITY))
    self:setUnitsToMeters(B2World.DEFAULT_UNITS_TO_METERS)
    self:setProperties(params)
end

--------------------------------------------------------------------------------
-- Sets the properties
-- @param properties properties
--------------------------------------------------------------------------------
function B2World:setProperties(properties)
    if properties then
        PropertyUtils.setProperties(self, properties, true)
    end
end

--------------------------------------------------------------------------------
-- Create a Body based on MOAIProp.
-- @param prop MOAIProp instance.
-- @param bodyType The type of the Body.
-- @param ... physicsDatas. Data that was created in PhysicsEditor can be used.
-- @return PhysicsBody instance.
--------------------------------------------------------------------------------
function B2World:createBody(prop, bodyType, ...)
    local params = {...}
    if #params == 0 then
        table.insert(params, {shape == "rectangle"})
    end
    
    local body = self:addBody(bodyType)
    local width, height = DisplayObject.getSize(prop)
    local xMin, yMin, xMax, yMax = -width / 2, -height / 2, width / 2, height / 2
    
    for i, data in ipairs(params) do
        data = table.copy(data)
        data.shape = data.shape or "rectangle"
        if data.shape == "rectangle" then
            data.xMin = data.xMin or xMin
            data.yMin = data.yMin or yMin
            data.xMax = data.xMax or xMax
            data.yMax = data.yMax or yMax
        elseif data.shape == "circle" then
            data.radius = data.radius or width / 2
            data.center = data.center or {x = 0, y = 0}
        end
        body:addPhysicsData(data)
    end

    DisplayObject.setPos(prop, xMin, yMin)
    prop:setParent(body)
    prop.body = body
    body.prop = prop
    
    body:resetMassData()
    return body
end

--------------------------------------------------------------------------------
-- To create a rectangle.
-- @return PhysicsBody instance.
--------------------------------------------------------------------------------
function B2World:createRect(left, top, width, height, params)
    params = params or {}
    
    local body = self:addBody(params.type)
    local fixture = body:addRect(0, 0, width, height)
    fixture:setProperties(params)
    
    body:setPos(left, top)
    body:resetMassData()
    return body
end

--------------------------------------------------------------------------------
-- Add the PhysicsBody object.
-- @param bodyType Can also be specified in the extended string.
-- @return PhysicsBody instance.
--------------------------------------------------------------------------------
function B2World:addBody(bodyType)
    bodyType = bodyType or "dynamic"
    bodyType = type(bodyType) == "string" and B2World.BODY_TYPES[bodyType] or bodyType
    return B2Body(MOAIBox2DBodyInterface.addBody(self, bodyType))
end


return M
