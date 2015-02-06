----------------------------------------------------------------------------------------------------
-- @type Scene
--
-- A scene class, handling display on one or more layers and receiving events from the EventMgr.
-- Object is controlled by SceneMgr; use that class to manipulate scenes.
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.lang.class"
local table = require "flower.lang.table"
local Config = require "flower.core.Config"
local Resources = require "flower.core.Resources"
local Event = require "flower.core.Event"
local Window = require "flower.core.Window"
local Group = require "flower.core.Group"

-- class
local Scene = class(Group)

--- Touch Event Cache
local TOUCH_EVENT = Event()

---
-- The constructor.
-- @param sceneName Module name
-- @param params Scene parameters
function Scene:init(sceneName, params)
    Group.init(self, nil, Window.width, Window.height)
    self.name = sceneName
    self.isScene = true
    self.opened = false
    self.started = false
    self.sceneUpdateEnabled = false
    self.sceneTouchEnabled = false
    self.sceneDestroyEnabled = Config.SCENE_CLOSED_DESTROY_ENABLED
    self.controller = self:createController(params)
    self.controller.scene = self
    self:initListeners()

    self:dispatchEvent(Event.CREATE, params)
end

---
-- INTERNAL USE ONLY -- create the scene controller.
function Scene:createController(params)
    params = params or {}

    local sceneController = params.sceneController
    if sceneController then
        return type(sceneController) == "string" and require(sceneController) or sceneController
    end

    local sceneName = self.name
    return sceneName and require(sceneName) or {}
end

---
-- INTERNAL USE ONLY -- initialize event listeners.
function Scene:initListeners()
    local addEventListener = function(type, func, obj)
        if func then
            self:addEventListener(type, func, obj)
        end
    end
    addEventListener(Event.CREATE, self.controller.onCreate)
    addEventListener(Event.OPEN, self.controller.onOpen)
    addEventListener(Event.CLOSE, self.controller.onClose)
    addEventListener(Event.START, self.controller.onStart)
    addEventListener(Event.STOP, self.controller.onStop)
    addEventListener(Event.UPDATE, self.controller.onUpdate)
    addEventListener(Event.TOUCH_DOWN, self.onTouch, self)
    addEventListener(Event.TOUCH_UP, self.onTouch, self)
    addEventListener(Event.TOUCH_MOVE, self.onTouch, self)
    addEventListener(Event.TOUCH_CANCEL, self.onTouch, self)
end

---
-- Open the scene.
-- Scenes add themselves to the SceneMgr when opened.
-- @param params Scene event parameters.(event.data)
function Scene:open(params)
    if self.opened then
        return
    end

    self:dispatchEvent(Event.OPEN, params)
    self.opened = true
end

---
-- Close the scene, removing it from the SceneMgr.
-- @param params Scene event parameters.(event.data)
function Scene:close(params)
    if not self.opened then
        return
    end
    self:stop()
    self.opened = false
    self:dispatchEvent(Event.CLOSE, params)

    if self.sceneDestroyEnabled then
        Resources.destroyModule(self.controller)
    end
end

---
-- Start the scene.
-- Start event is issued.
-- @param params Scene event parameters.(event.data)
function Scene:start(params)
    if self.started or not self.opened then
        return
    end
    self:dispatchEvent(Event.START, params)
    self.started = true
    self.paused = false
    self.sceneUpdateEnabled = true
    self.sceneTouchEnabled = true
end

---
-- Stop the scene.
-- Stop event is issued.
-- @param params Scene event parameters.(event.data)
function Scene:stop(params)
    if not self.started then
        return
    end
    self:dispatchEvent(Event.STOP, params)
    self.started = false
    self.sceneUpdateEnabled = false
    self.sceneTouchEnabled = false
end

---
-- Handle touch events sent by the EventMgr.
-- @param e Event
function Scene:onTouch(e)
    local e2 = table.copy(e, TOUCH_EVENT)
    for i = #self.children, 1, -1 do
        local layer = self.children[i]
        if layer.touchEnabled and layer:getVisible() then
            e2.wx, e2.wy = layer:wndToWorld(e.x, e.y, 0)
            layer:dispatchEvent(e2)
        end
        if e2.stopFlag then
            e:stop()
            break
        end
    end
end

---
-- Returns the rendering table.
-- Used by RenderMgr.
-- @return rendering table
function Scene:getRenderTable()
    return self.children
end

return Scene