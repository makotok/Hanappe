----------------------------------------------------------------
-- This class is a top-level container to build a scene graph. <br>
-- Use this class to build a game scene. <br>
-- <br>
-- Scene is managed by the SceneManager. <br>
-- Use by specifying the module from the SceneManager. <br>
-- Scene will be generated internally. <br>
-- <br>
-- The Scene is the life cycle exists. <br>
-- It is important to understand the life cycle. <br>
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
--
-- @class table
-- @name Scene
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

-- event caches
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

-- event caches
local EC_ENTER_FRAME        = Event(M.EVENT_ENTER_FRAME)
local EC_CREATE             = Event(M.EVENT_CREATE)
local EC_START              = Event(M.EVENT_START)
local EC_RESUME             = Event(M.EVENT_RESUME)
local EC_STOP               = Event(M.EVENT_STOP)
local EC_DESTROY            = Event(M.EVENT_DESTROY)
local EC_TOUCH_DOWN         = Event(M.EVENT_TOUCH_DOWN)
local EC_TOUCH_UP           = Event(M.EVENT_TOUCH_UP)
local EC_TOUCH_MOVE         = Event(M.EVENT_TOUCH_MOVE)
local EC_TOUCH_CANCEL       = Event(M.EVENT_TOUCH_CANCEL)
local EC_KEY_DOWN           = Event(M.EVENT_KEY_DOWN)
local EC_KEY_UP             = Event(M.EVENT_KEY_UP)

-- local functions
local function destroyModule(m)
    if m and m._M and m._NAME then
        package.loaded[m._NAME] = nil
        _G[m._NAME] = nil
        Logger.debug("Scene module destroyed:", m._NAME)
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
-- @param Child to inherit the MOAILayer.
----------------------------------------------------------------
function M:addChild(child)
    Group.addChild(self, child)
    self.sceneManager:updateRender()
end

----------------------------------------------------------------
-- Remove the child object. <br>
-- @param Child to inherit the MOAILayer.
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
    if self:hasEventListener(M.EVENT_CREATE) then
        EC_CREATE.params = params
        self:dispatchEvent(EC_CREATE)
    end
end

---------------------------------------
-- Called when it is started.
---------------------------------------
function M:onStart()
    if self.sceneHandler.onStart then
        self.sceneHandler.onStart()
    end
    if self:hasEventListener(M.EVENT_START) then
        self:dispatchEvent(EC_START)
    end
end

---------------------------------------
-- Called when resumed.
---------------------------------------
function M:onResume()
    if self.sceneHandler.onResume then
        self.sceneHandler.onResume()
    end
    if self:hasEventListener(M.EVENT_RESUME) then
        self:dispatchEvent(EC_RESUME)
    end
end

---------------------------------------
-- Called when paused.
---------------------------------------
function M:onPause()
    if self.sceneHandler.onPause then
        self.sceneHandler.onPause()
    end
    if self:hasEventListener(M.EVENT_PAUSE) then
        self:dispatchEvent(EC_PAUSE)
    end
end

---------------------------------------
-- Called when stoped.
---------------------------------------
function M:onStop()
    if self.sceneHandler.onStop then
        self.sceneHandler.onStop()
    end
    if self:hasEventListener(M.EVENT_STOP) then
        self:dispatchEvent(EC_STOP)
    end
end

---------------------------------------
-- Called when destroyed.
---------------------------------------
function M:onDestroy()
    if self.sceneHandler.onDestroy then
        self.sceneHandler.onDestroy()
    end
    if self:hasEventListener(M.EVENT_DESTROY) then
        self:dispatchEvent(EC_DESTROY)
    end
    
    destroyModule(self.sceneHandler)
end

---------------------------------------
-- Called when updated.
---------------------------------------
function M:onEnterFrame()
    if self.sceneHandler.onEnterFrame then
        self.sceneHandler.onEnterFrame()
    end
    if self:hasEventListener(M.EVENT_ENTER_FRAME) then
        self:dispatchEvent(EC_ENTER_FRAME)
    end
end

---------------------------------------
-- Called when keyboard input.
-- @param event Keybord event.
---------------------------------------
function M:onKeyDown(event)
    if self.sceneHandler.onKeyDown then
        self.sceneHandler.onKeyDown(event)
    end
    if self:hasEventListener(M.EVENT_KEY_DOWN) then
        self:dispatchEvent(table.copy(event, EC_KEY_DOWN))
    end
end

---------------------------------------
-- Called when keyboard input.
-- @param event Keybord event.
---------------------------------------
function M:onKeyUp(event)
    if self.sceneHandler.onKeyUp then
        self.sceneHandler.onKeyUp(event)
    end
    if self:hasEventListener(M.EVENT_KEY_UP) then
        self:dispatchEvent(table.copy(event, EC_KEY_UP))
    end
end

---------------------------------------
-- Called when screen touched.
-- @param event Event.
---------------------------------------
function M:onTouchDown(event)
    self.touchDownFlag = true
    if self.sceneHandler.onTouchDown then
        self.sceneHandler.onTouchDown(event)
    end
    if self:hasEventListener(M.EVENT_TOUCH_DOWN) then
        self:dispatchEvent(table.copy(event, EC_TOUCH_DOWN))
    end
end

---------------------------------------
-- Called when screen touched.
-- @param event Event.
---------------------------------------
function M:onTouchUp(event)
    if self.sceneHandler.onTouchUp and self.touchDownFlag then
        self.touchDownFlag = false
        self.sceneHandler.onTouchUp(event)
    end
    if self:hasEventListener(M.EVENT_TOUCH_UP) then
        self:dispatchEvent(table.copy(event, EC_TOUCH_DOWN))
    end
end

---------------------------------------
-- Called when screen touched.
-- @param event Event.
---------------------------------------
function M:onTouchMove(event)
    if self.sceneHandler.onTouchMove and self.touchDownFlag then
        self.sceneHandler.onTouchMove(event)
    end
    if self:hasEventListener(M.EVENT_TOUCH_MOVE) then
        self:dispatchEvent(table.copy(event, EC_TOUCH_DOWN))
    end
end

---------------------------------------
-- Called when screen touched.
-- @param event Event.
---------------------------------------
function M:onTouchCancel(event)
    if self.sceneHandler.onTouchCancel then
        self.sceneHandler.onTouchCancel(event)
    end
    if self:hasEventListener(M.EVENT_TOUCH_CANCEL) then
        self:dispatchEvent(table.copy(event, EC_TOUCH_DOWN))
    end
end

return M