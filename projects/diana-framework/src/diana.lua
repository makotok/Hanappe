----------------------------------------------------------------------------------------------------
-- Artemis Framework をベースに作られたフレームワークです.
--
-- @author Makoto
-- @release V1.0
----------------------------------------------------------------------------------------------------

-- module
local M = {}

-- Classes
local class
local table
local UUID
local Entity
local EntityObserver
local EntityManager
local EntitySystem
local World

----------------------------------------------------------------------------------------------------
-- This implements object-oriented style classes in Lua, including multiple inheritance.
-- This particular variation of class implementation copies the base class
-- functions into this class, which improves speed over other implementations
-- in return for slightly larger class tables.  Please note that the inherited
-- class members are therefore cached and subsequent changes to a superclass
-- may not be reflected in your subclasses.
-- @class table
-- @name class
----------------------------------------------------------------------------------------------------
class = {}
setmetatable(class, class)
M.class = class

--------------------------------------------------------------------------------
-- This allows you to define a class by calling 'class' as a function, 
-- specifying the superclasses as a list.  For example:
-- mynewclass = class(superclass1, superclass2)
-- @param ... Base class list.
-- @return class
--------------------------------------------------------------------------------
function class:__call(...)
    local classObj = table.copy(self)
    local bases = {...}
    for i = #bases, 1, -1 do
        table.copy(bases[i], classObj)
    end
    classObj.__call = function(self, ...)
        return self:new(...)
    end
    return setmetatable(classObj, classObj)
end

--------------------------------------------------------------------------------
-- Generic constructor function for classes.
-- Note that new() will call init() if it is available in the class.
-- @return Instance
--------------------------------------------------------------------------------
function class:new(...)
    local obj
    if self.__factory then
        obj = self.__factory.new()
        table.copy(self, obj)
    else
        obj = {__index = self}
        setmetatable(obj, obj)
    end
    
    if obj.init then
        obj:init(...)
    end

    obj.new = nil
    obj.init = nil
    
    return obj
end

----------------------------------------------------------------------------------------------------
-- The next group of functions extends the default lua table implementation
-- to include some additional useful methods.
-- @class table
-- @name table
----------------------------------------------------------------------------------------------------
table = setmetatable({}, {__index = _G.table})
M.table = table

--------------------------------------------------------------------------------
-- Returns the position found by searching for a matching value from an array.
-- @param array table array
-- @param value Search value
-- @return the index number if the value is found, or 0 if not found.
--------------------------------------------------------------------------------
function table.indexOf(array, value)
    for i, v in ipairs(array) do
        if v == value then
            return i
        end
    end
    return 0
end

--------------------------------------------------------------------------------
-- Same as indexOf, only for key values (slower)
-- Author:Nenad Katic
--------------------------------------------------------------------------------
function table.keyOf( src, val )
    for k, v in pairs( src ) do
        if v == val then
            return k
        end
    end
    return nil
end

--------------------------------------------------------------------------------
-- Copy the table shallowly (i.e. do not create recursive copies of values)
-- @param src copy
-- @param dest (option)Destination
-- @return dest
--------------------------------------------------------------------------------
function table.copy(src, dest)
    dest = dest or {}
    for i, v in pairs(src) do
        dest[i] = v
    end
    return dest
end

--------------------------------------------------------------------------------
-- Copy the table deeply (i.e. create recursive copies of values)
-- @param src copy
-- @param dest (option)Destination
-- @return dest
--------------------------------------------------------------------------------
function table.deepCopy(src, dest)
    dest = dest or {}
    for k, v in pairs(src) do
        if type(v) == "table" then
            dest[k] = table.deepCopy(v)
        else
            dest[k] = v
        end
    end
    return dest
end

--------------------------------------------------------------------------------
-- Adds an element to the table if and only if the value did not already exist.
-- @param t table
-- @param o element
-- @return If it already exists, returns false. If it did not previously exist, returns true.
--------------------------------------------------------------------------------
function table.insertIfAbsent(t, o)
    if table.indexOf(t, o) > 0 then
        return false
    end
    t[#t + 1] = o
    return true
end

--------------------------------------------------------------------------------
-- Adds an element to the table.
-- @param t table
-- @param o element
-- @return true
--------------------------------------------------------------------------------
function table.insertElement(t, o)
    t[#t + 1] = o
    return true
end

--------------------------------------------------------------------------------
-- Removes the element from the table.
-- If the element existed, then returns its index value.
-- If the element did not previously exist, then return 0.
-- @param t table
-- @param o element
-- @return index
--------------------------------------------------------------------------------
function table.removeElement(t, o)
    local i = table.indexOf(t, o)
    if i > 0 then
        table.remove(t, i)
    end
    return i
end

----------------------------------------------------------------------------------------------------
-- UUIDを生成する為のクラスです.
--
-- @author Makoto
-- @class table
-- @name UUID
----------------------------------------------------------------------------------------------------
UUID = {}
M.UUID = UUID

function UUID.generate()
    local template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"
    local random = math.random
    local format = string.format
    local x = string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and random(0, 0xf) or random(8, 0xb)
        return string.format('%x', v)
    end)
    return x
end

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
function Entity:init(world, id)
    self.world = assert(world)
    self.id = assert(id)
    self.components = {}
    self.componentMap = {}
end

function Entity:getId()
    return self.id
end

function Entity:addComponent(componentType, component)
    if not self.componentMap[componentType] then
        table.insertElement(self.components, component)
        self.componentMap[componentType] = component
    end
end

function Entity:removeComponent(componentType)
    if self.componentMap[componentType] then
        table.removeElement(self.components, component)
        self.componentMap[componentType] = nil
    end
end

function Entity:getComponent(componentType)
    return self.componentMap[componentType]    
end

function Entity:getComponentAt(index)
    return self.components[index]
end

function Entity:addToWorld()
    self.world:addEntity(self)
end

function Entity:deleteFromWorld()
    self.world:deleteEntity(self)
end

----------------------------------------------------------------------------------------------------
-- エンティティのイベントを受け取る抽象クラスです.
--
-- @author Makoto
-- @class table
-- @name EntityObserver
----------------------------------------------------------------------------------------------------
EntityObserver = class()
M.EntityObserver = EntityObserver

function EntityObserver:onAddedEntity(entity)
end

function EntityObserver:onDeletedEntity(entity)
end

function EntityObserver:setWorld(world)
    self.world = world
end

function EntityObserver:getWorld(world)
    return self.world
end

----------------------------------------------------------------------------------------------------
-- エンティティを管理するクラス
--
-- @author Makoto
-- @class table
-- @name EntityManager
----------------------------------------------------------------------------------------------------
EntityManager = class(EntityObserver)
M.EntityManager = EntityManager

function EntityManager:init()
    self.entities = {}
    self.entitiesMap = {}
end

function EntityManager:createEntity()
    return Entity(self.world, UUID.generate())
end

function EntityManager:getEntities()
    return self.entities
end

function EntityManager:getEntityById(id)
    return self.entitiesMap[id]
end

function EntityManager:findEntityByComponent(componentType, component)
    for i, entity in ipairs(self.entities) do
        if entity:getComponent(componentType) == component then
            return entity
        end
    end
end

function EntityManager:findEntitiesByComponent(componentType, component)
    local list = {}
    for i, entity in ipairs(self.entities) do
        if entity:getComponent(componentType) == component then
            table.insertElement(list, entity)
        end
    end
    return list
end

function EntityManager:hasEntity(entity)
    return self.entitiesMap[entity:getId()] ~= nil
end

function EntityManager:isActive(entityId)
    return self.entitiesMap[entityId] ~= nil
end

function EntityManager:onAddedEntity(entity)
    table.insertElement(self.entities, entity)
end

function EntityManager:onDeletedEntity(entity)
    table.removeElement(self.entities, entity)
end

----------------------------------------------------------------------------------------------------
-- エンティティシステムクラス.
--
-- @author Makoto
-- @class table
-- @name EntityWorld
----------------------------------------------------------------------------------------------------
EntitySystem = class(EntityObserver)
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

function EntitySystem:isPassive()
    return self.passive
end

function EntitySystem:setPassive(value)
    self.passive = value
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
    self.managers = {}
    self.systems = {}
    self.addedEntities = {}
    self.deletedEntities = {}
    self.entityManager = EntityManager()
    
    self:addManager(self.entityManager)
end

function World:notifyManagers(performer, entity)
    for i, manager in ipairs(self.managers) do
        local observerFunc = manager[performer]
        observerFunc(manager, entity)
    end
end

function World:notifySystems(performer, entity)
    for i, system in ipairs(self.systems) do
        local observerFunc = system[performer]
        observerFunc(system, entity)
    end
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
        self:notifyManagers(performer, entity)
        self:notifySystems(performer, entity)
    end
end

function World:addEntity(entity)
    table.insertElement(self.addedEntities, entity)
    return true
end

function World:deleteEntity(entity)
    if table.indexOf(self.deletedEntities, entity) > 0 then
        table.insertElement(self.deletedEntities, entity)
    end
end

function World:createEntity()
    return self.entityManager:createEntity()
end

function World:getEntities()
    return self.entityManager:getEntities()
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

function World:getManagers()
    return self.managers
end

function World:addManager(manager)
    table.insertElement(self.managers, manager)
    manager:setWorld(self)
end

function World:removeManager(manager)
    table.removeElement(self.managers, manager)
    manager:setWorld(nil)
end

return M
