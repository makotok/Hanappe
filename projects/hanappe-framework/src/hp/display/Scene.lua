----------------------------------------------------------------
-- This class is a top-level container to build a scene graph.
-- Use this class to build a game scene.
-- <br>
-- Scene is managed by the SceneManager.
-- Use by specifying the module from the SceneManager.
-- Scene will be generated internally.
-- <br>
-- The Scene is the life cycle exists.
-- It is important to understand the life cycle.
-- <br>
-- 1. onCreate(params)<br>
--   Called when created.<br>
--   Initializes the scene graph in this function.<br>
-- 2. onStart()<br>
--   Called when started.<br>
--   Called after the animation is complete.<br>
-- 3. onResume()<br>
--   Called when resumed.
-- 4. onPause()<br>
--   Called when paused.<br>
-- 5. onStop()<br>
--   Called when the stoped.<br>
-- 6. onDestroy()<br>
--   Called when destroyed.<br>
----------------------------------------------------------------

-- import
local table                 = require "hp/lang/table"
local class                 = require "hp/lang/class"
local Group                 = require "hp/display/Group"
local Event                 = require "hp/event/Event"
local EventDispatcher       = require "hp/event/EventDispatcher"
local Application           = require "hp/core/Application"
local Logger                = require "hp/util/Logger"

-- class
local M                     = class(Group)

-- events
M.EVENT_ENTER_FRAME         = "enterFrame"
M.EVENT_CREATE              = "create"
M.EVENT_START               = "start"
M.EVENT_RESUME              = "resume"
M.EVENT_PAUSE               = "pause"
M.EVENT_STOP                = "stop"
M.EVENT_DESTROY             = "destroy"
M.EVENT_TOUCH_DOWN          = "touchDown"
M.EVENT_TOUCH_UP            = "touchUp"
M.EVENT_TOUCH_MOVE          = "touchMove"
M.EVENT_TOUCH_CANCEL        = "touchCancel"
M.EVENT_KEY_DOWN            = "keyDown"
M.EVENT_KEY_UP              = "keyUp"

-- local functions
local function destroyModule(m)
    if m and m._M and m._NAME then
        package.loaded[m._NAME] = nil
        _G[m._NAME] = nil
    end
end

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function M:init()
    Group.init(self)
    
    self:setSize(Application.screenWidth, Application.screenHeight)
    
    self.name = ""
    self.visible = true
    self.sceneManager = require("hp/manager/SceneManager")
    self.sceneHandler = {}
    self.touchDownFlag = false

    self:setCenterPiv()
    self:setPos(0, 0)
end

----------------------------------------------------------------
-- Add a child object. <br>
-- @param child Child to inherit the MOAILayer.
----------------------------------------------------------------
function M:addChild(child)
    Group.addChild(self, child)
    self.sceneManager:updateRender()
end

----------------------------------------------------------------
-- Remove the child object. <br>
-- @param child Child to inherit the MOAILayer.
----------------------------------------------------------------
function M:removeChild(child)
    Group.removeChild(self, child)
    self.sceneManager:updateRender()
end

----------------------------------------------------------------
-- Sets the visible.<br>
-- If set to false, excluded from the target rendering.<br>
-- @param value visible.
----------------------------------------------------------------
function M:setVisible(value)
    self.visible = value
    self.sceneManager:updateRender()
end

----------------------------------------------------------------
-- Returns the visible.
-- @return visible.
----------------------------------------------------------------
function M:getVisible()
    return self.visible
end

---------------------------------------
-- Display to the front Scene.
---------------------------------------
function M:orderToFront()
    self.sceneManager:orderToFront(self)
end

---------------------------------------
-- Display to the back Scene.
---------------------------------------
function M:orderToBack()
    self.sceneManager:orderToBack(self)
end

---------------------------------------
-- Returns the rendering table.<br>
-- @return renderTable.
---------------------------------------
function M:getRenderTable()
    local renderTable = {}
    for i, v in ipairs(self.children) do
        if v.getRenderTable then
            table.insert(renderTable, v:getRenderTable())
        else
            table.insert(renderTable, v)
        end
    end
    return renderTable
end

---------------------------------------
-- Called when it is created.
---------------------------------------
function M:onCreate(params)
    if self.sceneHandler.onCreate then
        self.sceneHandler.onCreate(params)
    end
    self:dispatchEvent(M.EVENT_CREATE, params)
end

---------------------------------------
-- Called when it is started.
---------------------------------------
function M:onStart()
    if self.sceneHandler.onStart then
        self.sceneHandler.onStart()
    end
    self:dispatchEvent(M.EVENT_START)
end

---------------------------------------
-- Called when resumed.
---------------------------------------
function M:onResume()
    if self.sceneHandler.onResume then
        self.sceneHandler.onResume()
    end
    self:dispatchEvent(M.EVENT_RESUME)
end

---------------------------------------
-- Called when paused.
---------------------------------------
function M:onPause()
    if self.sceneHandler.onPause then
        self.sceneHandler.onPause()
    end
    self:dispatchEvent(M.EVENT_PAUSE)
end

---------------------------------------
-- Called when stoped.
---------------------------------------
function M:onStop()
    if self.sceneHandler.onStop then
        self.sceneHandler.onStop()
    end
    self:dispatchEvent(M.EVENT_STOP)
end

---------------------------------------
-- Called when destroyed.
---------------------------------------
function M:onDestroy()
    if self.sceneHandler.onDestroy then
        self.sceneHandler.onDestroy()
    end
    self:dispatchEvent(M.EVENT_DESTROY)
    
    self:dispose()
    destroyModule(self.sceneHandler)
end

---------------------------------------
-- Called when updated.
---------------------------------------
function M:onEnterFrame()
    if self.sceneHandler.onEnterFrame then
        self.sceneHandler.onEnterFrame()
    end
    self:dispatchEvent(M.EVENT_ENTER_FRAME)
end

---------------------------------------
-- Called when keyboard input.
-- @param event Keybord event.
---------------------------------------
function M:onKeyDown(event)
    local target = event.target
    self:dispatchEvent(event)
    event.target = target

    if not event.stoped and self.sceneHandler.onKeyDown then
        self.sceneHandler.onKeyDown(event)
    end
end

---------------------------------------
-- Called when keyboard input.
-- @param event Keybord event.
---------------------------------------
function M:onKeyUp(event)
    local target = event.target
    self:dispatchEvent(event)
    event.target = target

    if not event.stoped and self.sceneHandler.onKeyUp then
        self.sceneHandler.onKeyUp(event)
    end
end

---------------------------------------
-- Called when screen touched.
-- @param event Event.
---------------------------------------
function M:onTouchDown(event)
    local target = event.target
    self:dispatchEvent(event)
    event.target = target

    if not event.stoped and self.sceneHandler.onTouchDown then
        self.sceneHandler.onTouchDown(event)
    end
    
end

---------------------------------------
-- Called when screen touched.
-- @param event Event.
---------------------------------------
function M:onTouchUp(event)
    local target = event.target
    self:dispatchEvent(event)
    event.target = target

    if not event.stoped and self.sceneHandler.onTouchUp then
        self.sceneHandler.onTouchUp(event)
    end
end

---------------------------------------
-- Called when screen touched.
-- @param event Event.
---------------------------------------
function M:onTouchMove(event)
    local target = event.target
    self:dispatchEvent(event)
    event.target = target

    if not event.stoped and self.sceneHandler.onTouchMove then
        self.sceneHandler.onTouchMove(event)
    end
end

---------------------------------------
-- Called when screen touched.
-- @param event Event.
---------------------------------------
function M:onTouchCancel(event)
    local target = event.target
    self:dispatchEvent(event)
    event.target = target

    if not event.stoped and self.sceneHandler.onTouchCancel then
        self.sceneHandler.onTouchCancel(event)
    end
end

return M