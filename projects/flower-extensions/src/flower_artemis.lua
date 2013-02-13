----------------------------------------------------------------------------------------------------
-- Artemis Framework をベースに作られたフレームワークです.
--
-- @author Makoto
-- @release V1.0
----------------------------------------------------------------------------------------------------

-- module
local M = {}

-- import
local flower = require "flower"
local class = flower.class
local table = flower.table

-- Classes
local Entity
local System
local EntityManager
local EntitySystem
local World

----------------------------------------------------------------------------------------------------
-- エンティティクラス
--
-- @author Makoto
-- @class table
-- @name Entity
----------------------------------------------------------------------------------------------------
Entity = class()
M.Entity = Entity

--------------------------------------------------------------------------------
-- The constructor.
-- @param world EntityWorld
-- @param id Entity id
--------------------------------------------------------------------------------
function Entity:init(world)
    self.world = assert(world)
end

function Entity:addToWorld()
    self.world:addEntity(self)
end

function Entity:deleteFromWorld()
    self.world:deleteEntity(self)
end

----------------------------------------------------------------------------------------------------
-- システム共通の抽象クラスです.
--
-- @author Makoto
-- @class table
-- @name System
----------------------------------------------------------------------------------------------------
System = class()
M.System = System

function System:initialize()
end

function System:process(entities)
end

function System:setWorld(world)
    self.world = world
end

function System:getWorld(world)
    return self.world
end

function System:isPassive()
    return self.passive
end

function System:setPassive(value)
    self.passive = value
end

function System:onAddedEntity(entity)
end

function System:onDeletedEntity(entity)
end

----------------------------------------------------------------------------------------------------
-- エンティティを管理するクラス
--
-- @author Makoto
-- @class table
-- @name EntityManager
----------------------------------------------------------------------------------------------------
EntityManager = class(System)
M.EntityManager = EntityManager

function EntityManager:init()
    self.entities = {}
    self.entitiesMap = {}
end

function EntityManager:createEntity()
    return Entity(self.world)
end

function EntityManager:getEntities()
    return self.entities
end

function EntityManager:findEntityByComponent(componentType, component)
    for i, entity in ipairs(self.entities) do
        if entity[componentType] == component then
            return entity
        end
    end
end

function EntityManager:findEntitiesByComponent(componentType, component)
    local list = {}
    for i, entity in ipairs(self.entities) do
        if entity[componentType] == component then
            table.insertElement(list, entity)
        end
    end
    return list
end

function EntityManager:hasEntity(entity)
    return self.entitiesMap[entity]
end

function EntityManager:onAddedEntity(entity)
    if not self.entitiesMap[entity] then
        table.insertElement(self.entities, entity)
        self.entitiesMap[entity] = true
    end
end

function EntityManager:onDeletedEntity(entity)
    if self.entitiesMap[entity] then
        table.removeElement(self.entities, entity)
        self.entitiesMap[entity] = false
    end
end

----------------------------------------------------------------------------------------------------
-- エンティティシステムクラス.
--
-- @author Makoto
-- @class table
-- @name EntityWorld
----------------------------------------------------------------------------------------------------
EntitySystem = class(System)
M.EntitySystem = EntitySystem

function EntitySystem:init()
    self.passive = false
end

function EntitySystem:process(entities)
    if self:checkProcessing() then
        self:beginProcess(entities)
        self:processEntities(entities)
        self:endProcess(entities)
    end
end

function EntitySystem:beginProcess(entities)
end

function EntitySystem:endProcess(entities)
end

function EntitySystem:processEntities(entities)
    for i, entity in ipairs(entities) do
        self:processEntity(entity)
    end
end

function EntitySystem:processEntity(entity)
end

function EntitySystem:checkProcessing()
    return true
end

----------------------------------------------------------------------------------------------------
-- ワールドクラス
--
-- @author Makoto
-- @class table
-- @name EntityWorld
----------------------------------------------------------------------------------------------------
World = class()
M.World = World

function World:init()
    self.initialized = false
    self.systems = {}
    self.addedEntities = {}
    self.deletedEntities = {}
    self.entityManager = EntityManager()
    
    self:addSystem(self.entityManager)
end

function World:initialize()
    if self.initialized then
        return
    end
    
    for i, system in ipairs(self.systems) do
        system:initialize()
    end
    self:validateProcess()
    self.initialized = true
end

function World:process()
    self:validateProcess()
    for i, system in ipairs(self.systems) do
        if not system:isPassive() then
            system:process(self:getEntities())
        end
    end
end

function World:validateProcess()
    self:validateEntities(self.addedEntities, "onAddedEntity")
    self:validateEntities(self.deletedEntities, "onDeletedEntity")
    
    self.addedEntities = #self.addedEntities == 0 and self.addedEntities or {}
    self.deletedEntities = #self.deletedEntities == 0 and self.deletedEntities or {}
end

function World:validateEntities(entities, performer)
    for i, entity in ipairs(entities) do
        self:notifySystems(performer, entity)
    end
end

function World:notifySystems(performer, entity)
    for i, system in ipairs(self.systems) do
        local observerFunc = system[performer]
        observerFunc(system, entity)
    end
end

function World:addEntity(entity)
    if not self:hasEntity(entity) and not self.addedEntities[entity] then
        self.addedEntities[entity] = true
        table.insertElement(self.addedEntities, entity)
        return true
    end
end

function World:deleteEntity(entity)
    if not self.deletedEntities[entity] then
        self.deletedEntities[entity] = true
        table.insertElement(self.deletedEntities, entity)
        return true
    end
end

function World:createEntity()
    return self.entityManager:createEntity()
end

function World:getEntities()
    return self.entityManager:getEntities()
end

function World:findEntityByComponent(componentType, component)
    return self.entityManager:findEntityByComponent(componentType, component)
end

function World:findEntitiesByComponent(componentType, component)
    return self.entityManager:findEntitiesByComponent(componentType, component)
end

function World:hasEntity(entity)
    return self.entityManager:hasEntity(entity)
end

function World:getEntityManager()
    return self.entityManager
end

function World:getSystems()
    return self.systems
end

function World:addSystem(system)
    table.insertElement(self.systems, system)
    system:setWorld(self)
end

function World:removeSystem(system)
    table.removeElement(self.systems, system)
    system:setWorld(nil)
end

return M
