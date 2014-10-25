--------------------------------------------------------------------------------
-- Class that inherits from MOAIBox2DBody.<br>
--------------------------------------------------------------------------------

local table = require("hp/lang/table")
local class = require("hp/lang/class")
local Event = require("hp/event/Event")
local EventDispatcher = require("hp/event/EventDispatcher")
local PhysicsFixture = require("hp/physics/PhysicsFixture")

local M = class(EventDispatcher)

local Interface = MOAIBox2DBody.getInterfaceTable()

M.DEFAULT_FIXTURE_PARAMS = {
    density = 1,
    friction = 0.3,
    restitution = 0,
    filter = {categoryBits = 1, maskBits = nil, groupIndex = nil},
    sensor = false,
    center = {x = 0, y = 0}
}

M.PHASE = {}
M.PHASE[MOAIBox2DArbiter.BEGIN] = "begin"
M.PHASE[MOAIBox2DArbiter.END] = "end"
M.PHASE[MOAIBox2DArbiter.POST_SOLVE] = "postSolve"
M.PHASE[MOAIBox2DArbiter.PRE_SOLVE] = "preSolve"

--------------------------------------------------------------------------------
-- The constructor.
-- @param body MOAIBox2DBody instance.
--------------------------------------------------------------------------------
function M:new(body)
    table.copy(self, assert(body))
    
    if body.init then
        body:init()
    end
    
    body.new = nil
    body.init = nil
    
    return body
end

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function M:init()
    EventDispatcher.init(self)
    self._fixtures = {}
end

--------------------------------------------------------------------------------
-- Add the PhysicsData was created in PhysicsEditor. <br>
-- Partially, it is proprietary.
-- @param ... fixture datas
--------------------------------------------------------------------------------
function M:addPhysicsData(...)
    for i, data in ipairs({...}) do
        if data.radius then
            local fixture = self:addCircle(data.center.x, data.center.y, data.radius)
            fixture:copyParams(data)
        elseif data.shape == "rectangle" then
            local fixture = self:addRect(data.xMin, data.yMin, data.xMax, data.yMax)
            fixture:copyParams(data)
        elseif type(data.shape) == "table" then
            local fixture = self:addPolygon(data.shape)
            fixture:copyParams(data)
        end
    end
end

--------------------------------------------------------------------------------
-- Add a circle.
--------------------------------------------------------------------------------
function M:addCircle(x, y, radius)
    local fixture = Interface.addCircle(self, x, y, radius)
    fixture = PhysicsFixture(fixture)
    fixture:copyParams(M.DEFAULT_FIXTURE_PARAMS)
    table.insert(self:getFixtures(), fixture)
    return fixture
end

--------------------------------------------------------------------------------
-- Add the edge.
--------------------------------------------------------------------------------
function M:addEdges(verts)
    local fixture = Interface.addEdges(self, verts)
    fixture = PhysicsFixture(fixture)
    fixture:copyParams(M.DEFAULT_FIXTURE_PARAMS)
    table.insert(self:getFixtures(), fixture)
    return fixture
end

--------------------------------------------------------------------------------
-- Adds a polygon.
--------------------------------------------------------------------------------
function M:addPolygon(verts)
    local fixture = Interface.addPolygon(self, verts)
    fixture = PhysicsFixture(fixture)
    fixture:copyParams(M.DEFAULT_FIXTURE_PARAMS)
    table.insert(self:getFixtures(), fixture)
    return fixture
end

--------------------------------------------------------------------------------
-- Add a rectangle.
--------------------------------------------------------------------------------
function M:addRect(xMin, yMin, xMax, yMax)
    local fixture = Interface.addRect(self, xMin, yMin, xMax, yMax)
    fixture = PhysicsFixture(fixture)
    fixture:copyParams(M.DEFAULT_FIXTURE_PARAMS)
    table.insert(self:getFixtures(), fixture)
    return fixture
end

--------------------------------------------------------------------------------
-- Search from the name, and returns the Fixture was the first match.
-- @param name Fixture name.
-- @return Fixture instance.
--------------------------------------------------------------------------------
function M:findFixtureByName(name)
    for i, v in self:getFixtures() do
        if v:getName() == name then
            return v
        end
    end
end

--------------------------------------------------------------------------------
-- Search from the name, it returns a list of Fixture match.
-- @param name Fixture name.
-- @return Fixture instance list.
--------------------------------------------------------------------------------
function M:findFixturesByName(name)
    local list = {}
    for i, v in self:getFixtures() do
        if v:getName() == name then
            table.insert(list, v)
        end
    end
    return list
end

--------------------------------------------------------------------------------
-- Returns the Fixture for all.
-- @return Fixtures
--------------------------------------------------------------------------------
function M:getFixtures()
    return self._fixtures
end

--------------------------------------------------------------------------------
-- Returns a Fixture at the specified index.
-- @param i index
-- @return Fixture instance.
--------------------------------------------------------------------------------
function M:getFixtureAt(i)
    return self:getFixtures()[i]
end

--------------------------------------------------------------------------------
-- Sets angle.
-- @param angle angle
--------------------------------------------------------------------------------
function M:setAngle(angle)
    local x, y = self:getPosition()
    self:setTransform(x, y, angle)
end

--------------------------------------------------------------------------------
-- Returns the position x.
-- @return x
--------------------------------------------------------------------------------
function M:getX()
    local x, y = self:getPosition()
    return x
end

--------------------------------------------------------------------------------
-- Sets the position x.
-- @param x position x.
--------------------------------------------------------------------------------
function M:setX(x)
    self:setTransform(x, self:getY(), self:getAngle())
end

--------------------------------------------------------------------------------
-- Returns the position y.
-- @return y
--------------------------------------------------------------------------------
function M:getY()
    local x, y = self:getPosition()
    return y
end

--------------------------------------------------------------------------------
-- Sets the position y.
-- @param y position y.
--------------------------------------------------------------------------------
function M:setY(y)
    self:setTransform(self:getX(), y, self:getAngle())
end

--------------------------------------------------------------------------------
-- Sets the position.
-- @param x position x.
-- @param y position y.
--------------------------------------------------------------------------------
function M:setPos(x, y)
    self:setTransform(x, y, self:getAngle())
end

--------------------------------------------------------------------------------
-- Returns the position.
-- @return x, y.
--------------------------------------------------------------------------------
function M:getPos()
    return self:getPosition()
end

--------------------------------------------------------------------------------
-- Adds the position.
-- @param x x position
-- @param x y position
--------------------------------------------------------------------------------
function M:addPos(x, y)
    self:setPos(x + self:getX(), y + self:getY())
end

--------------------------------------------------------------------------------
-- Adds an event listener.
-- Also responsible for handling of Fixture.
--------------------------------------------------------------------------------
function M:addEventListener(eventType, callback, source, priority)
    EventDispatcher.addEventListener(self, eventType, callback, source, priority)
    if eventType == Event.COLLISION then
        for i, fixture in ipairs(self:getFixtures()) do
            fixture:setCollisionHandler(M.fixtureCollisionHandler, MOAIBox2DArbiter.ALL)
        end
    end
end

function M.fixtureCollisionHandler(phase, fixtureA, fixtureB, arbiter)
    local bodyA = fixtureA:getBody()
    local bodyB = fixtureB:getBody()
    local bodyAListened = bodyA:hasEventListener(Event.COLLISION)
    local bodyBListened = bodyB:hasEventListener(Event.COLLISION)
    if bodyAListened or bodyBListened then
        local e = Event(Event.COLLISION)
        e.phase = M.PHASE[phase]
        e.fixtureA = fixtureA
        e.fixtureB = fixtureB
        e.arbiter = arbiter
        if bodyAListened then
            bodyA:dispatchEvent(e)
        end
        if bodyBListened then
            bodyB:dispatchEvent(e)
        end
    end
end

return M