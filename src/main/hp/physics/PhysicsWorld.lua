local table = require("hp/lang/table")
local class = require("hp/lang/class")
local EventDispatcher = require("hp/event/EventDispatcher")
local PhysicsBody = require("hp/physics/PhysicsBody")
local MOAIPropUtil = require("hp/util/MOAIPropUtil")

--------------------------------------------------------------------------------
-- Class that inherits from MOAIBox2DWorld.<br>
-- TODO:Not implemented
-- @class table
-- @name PhysicsWorld
--------------------------------------------------------------------------------
local M = class(EventDispatcher)
local Interface = MOAIBox2DWorld.getInterfaceTable()

M.DEFUALT_PARAMS = {
    gravity = {0, 10},
    unitsToMeters = 0.06,
}

M.BODY_TYPES = {
    dynamic = MOAIBox2DBody.DYNAMIC,
    static = MOAIBox2DBody.STATIC,
    kinematic = MOAIBox2DBody.KINEMATIC
}

function M:new(...)
    local obj = MOAIBox2DWorld.new()
    table.copy(self, obj)
    
    if obj.init then
        obj:init(...)
    end
    
    obj.init = nil
    obj.new = nil
    
    return obj
end

function M:init(params)
    params = params or M.DEFUALT_PARAMS
    self:copyParams(params)
end

function M:copyParams(params)
    if params.gravity then
        self:setGravity(unpack(params.gravity))
    end
    if params.unitsToMeters then
        self:setUnitsToMeters(params.unitsToMeters)
    end
end

function M:createBodyFromProp(prop, bodyType, ...)
    local params = {...}
    if #params == 0 then
        table.insert(params, {shape == "rectangle"})
    end
    
    local body = self:addBody(bodyType)
    local width, height = MOAIPropUtil.getSize(prop)
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

    MOAIPropUtil.setPos(prop, xMin, yMin)
    prop:setParent(body)
    prop.body = body
    body.prop = prop
    
    body:resetMassData()
    return body
end

function M:createRect(left, top, width, height, params)
    params = params or {}
    
    local body = self:addBody(params.type)
    local fixture = body:addRect(0, 0, width, height)
    fixture:copyParams(params)
    
    body:setPos(left, top)
    body:resetMassData()
    return body
end

function M:addBody(bodyType)
    bodyType = bodyType or "dynamic"
    bodyType = type(bodyType) == "string" and M.BODY_TYPES[bodyType] or bodyType
    return PhysicsBody(Interface.addBody(self, bodyType))
end


return M