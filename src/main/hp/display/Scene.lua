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

local table = require("hp/lang/table")
local class = require("hp/lang/class")
local Group = require("hp/display/Group")
local Event = require("hp/event/Event")
local EventDispatcher = require("hp/event/EventDispatcher")
local Application = require("hp/Application")

local M = class(Group)

local ENTER_FRAME_EVENT = Event("enterFrame")

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
end

---------------------------------------
-- Called when it is started.
---------------------------------------
function M:onStart()
    if self.sceneHandler.onStart then
        self.sceneHandler.onStart()
    end
end

---------------------------------------
-- Called when resumed.
---------------------------------------
function M:onResume()
    if self.sceneHandler.onResume then
        self.sceneHandler.onResume()
    end
end

---------------------------------------
-- Called when paused.
---------------------------------------
function M:onPause()
    if self.sceneHandler.onPause then
        self.sceneHandler.onPause()
    end
end

---------------------------------------
-- Called when stoped.
---------------------------------------
function M:onStop()
    if self.sceneHandler.onStop then
        self.sceneHandler.onStop()
    end
end

---------------------------------------
-- Called when destroyed.
---------------------------------------
function M:onDestroy()
    if self.sceneHandler.onDestroy then
        self.sceneHandler.onDestroy()
    end
end

---------------------------------------
-- Called when updated.
---------------------------------------
function M:onEnterFrame()
    if self.sceneHandler.onEnterFrame then
        self.sceneHandler.onEnterFrame()
    end
    if self:hasEventListener("enterFrame") then
        self:dispatchEvent(ENTER_FRAME_EVENT)
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
    if self:hasEventListener(Event.KEY_DOWN) then
        self:dispatchEvent(table.copy(event, Event:new()))
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
    if self:hasEventListener(Event.KEY_UP) then
        self:dispatchEvent(table.copy(event, Event:new()))
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
    if self:hasEventListener(Event.TOUCH_DOWN) then
        self:dispatchEvent(table.copy(event, Event:new()))
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
    if self:hasEventListener(Event.TOUCH_UP) then
        self:dispatchEvent(table.copy(event, Event:new()))
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
    if self:hasEventListener(Event.TOUCH_MOVE) then
        self:dispatchEvent(table.copy(event, Event:new()))
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
    if self:hasEventListener(Event.TOUCH_CANCEL) then
        self:dispatchEvent(table.copy(event, Event:new()))
    end
end

return M