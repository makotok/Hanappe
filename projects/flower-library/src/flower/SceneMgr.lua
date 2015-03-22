----------------------------------------------------------------------------------------------------
-- This is a singleton class to manage the scene object.
--
-- <h4>Extends:</h4>
-- <ul>
--   <li><a href="flower.EventDispatcher.html">EventDispatcher</a><l/i>
-- </ul>
--
-- @author Makoto
-- @release V3.0.0
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.class"
local table = require "flower.table"
local Executors = require "flower.Executors"
local Runtime = require "flower.Runtime"
local RenderMgr = require "flower.RenderMgr"
local InputMgr = require "flower.InputMgr"
local ClassFactory = require "flower.ClassFactory"
local Event = require "flower.Event"
local EventDispatcher = require "flower.EventDispatcher"
local Scene = require "flower.Scene"
local SceneAnimations = require "flower.SceneAnimations"

-- class
local SceneMgr = EventDispatcher()

-- variables
SceneMgr.scenes = {}
SceneMgr.currentScene = nil
SceneMgr.nextScene = nil
SceneMgr.nextSceneIndex = nil
SceneMgr.closingSceneSize = nil
SceneMgr.closingSceneGroup = nil
SceneMgr.transitioning = false
SceneMgr.sceneUpdateEnabled = true
SceneMgr.sceneTouchEnabled = true
SceneMgr.sceneFactory = nil

---
-- Initialize.
function SceneMgr:initialize()
    InputMgr:addEventListener(Event.TOUCH_DOWN, self.onTouch, self)
    InputMgr:addEventListener(Event.TOUCH_UP, self.onTouch, self)
    InputMgr:addEventListener(Event.TOUCH_MOVE, self.onTouch, self)
    InputMgr:addEventListener(Event.TOUCH_CANCEL, self.onTouch, self)
    Runtime:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
    RenderMgr:addChild(self)

    self.sceneClass = Scene
    self.sceneFactory = self.sceneFactory or ClassFactory(self.sceneClass)
end

---
-- Goes to a new scene.
-- Will close the current scene.
-- @param sceneName module name of the Scene
-- @param params (option)Parameters of the Scene
function SceneMgr:gotoScene(sceneName, params)
    return self:internalOpenScene(sceneName, params, true)
end

---
-- Open the Scene.
-- @param sceneName module name of the Scene
-- @param params (option)Parameters of the Scene
function SceneMgr:openScene(sceneName, params)
    return self:internalOpenScene(sceneName, params, false)
end

---
-- Open the scene for the internal implementation.
-- variable that can be specified in params are as follows.
-- <ul>
--   <li>animation: Scene animation of transition. </li>
--   <li>second: Time to scene animation. </li>
--   <li>easeType: EaseType to animation scene. </li>
--   <li>sync: Other threads wait until action will finish. </li>
-- </ul>
function SceneMgr:internalOpenScene(sceneName, params, currentCloseFlag)
    params = params or {}

    -- state check
    if self.transitioning then
        return
    end
    if self:getSceneByName(sceneName) then
        return
    end
    self.transitioning = true

    -- stop
    if self.currentScene then
        self.currentScene:stop(params)
    end

    -- create next scene
    self.nextScene = self:createScene(sceneName, params)
    self.nextScene:open(params)
    self:addScene(self.nextScene)

    -- scene animation
    local funAnimation = function()
        local animation = self:getSceneAnimationByName(params.animation)
        animation(self.currentScene or self.sceneClass(), self.nextScene, params)

        if self.currentScene and currentCloseFlag then
            self.currentScene:close(params)
            self:removeScene(self.currentScene)
        end

        self.currentScene = self.nextScene
        self.nextScene = nil
        self.transitioning = false
        self.currentScene:start(params)

        self:dispatchEvent(Event.OPEN_COMPLETE)
    end

    if params.sync then
        funAnimation()
    else
        Executors.callOnce(funAnimation)
    end

    return self.nextScene
end

---
-- Close the Scene.
-- variable that can be specified in params are as follows.
-- <ul>
--   <li>animation: Scene animation of transition. </li>
--   <li>second: Time to scene animation. </li>
--   <li>easeType: EaseType to animation scene. </li>
--   <li>backScene: The name of the scene you want to back. </li>
--   <li>backSceneCount: Number of scene you want to back. </li>
--   <li>sync: Other threads wait until action will finish. </li>
-- </ul>
-- @param params (option)Parameters of the Scene
function SceneMgr:closeScene(params)
    params = params or {}

    -- state check
    if self.transitioning or not self.currentScene then
        return
    end
    self.transitioning = true

    -- set next scene
    local backSceneName = params.backScene
    local backSceneCount = params.backSceneCount or 1
    self.nextScene = backSceneName and assert(self:getSceneByName(backSceneName)) or self.scenes[#self.scenes - backSceneCount]
    self.nextSceneIndex = table.indexOf(self.scenes, self.nextScene)

    -- set closing scenes
    self.closingSceneSize = #self.scenes - self.nextSceneIndex
    self.closingSceneGroup = self.sceneClass()
    for i = 0, self.closingSceneSize - 1 do
        local scene = self.scenes[#self.scenes - i]
        self.closingSceneGroup:addChild(scene)
    end

    -- stop current scene
    self.currentScene:stop(params)

    local funAnimation = function()
        local animation = self:getSceneAnimationByName(params.animation)
        animation(self.closingSceneGroup, self.nextScene or self.sceneClass(), params)

        -- close scens
        for i, scene in ipairs(self.closingSceneGroup.children) do
            scene:close(params)
            self:removeScene(scene)
        end

        self.closingSceneGroup = nil
        self.closingSceneSize = nil
        self.currentScene = self.nextScene
        self.nextScene = nil
        self.transitioning = false

        if self.currentScene then
            self.currentScene:start(params)
        end

        self:dispatchEvent(Event.CLOSE_COMPLETE)
    end

    if params.sync then
        funAnimation()
    else
        Executors.callOnce(funAnimation)
    end

    return true
end

---
-- Create the Scene.
-- NOTE: FOR INTERNAL USE ONLY
function SceneMgr:createScene(sceneName, params)
    local sceneFactory = params.sceneFactory or self.sceneFactory
    return sceneFactory:newInstance(sceneName, params)
end

---
-- Return the scene transition animation with the specified name.
-- If you do not specify a name, will return to the default animation ('change').
-- @param name Animation name of the SceneAnimations
-- @return animation function
function SceneMgr:getSceneAnimationByName(name)
    local animation = name or "change"
    animation = type(animation) == "string" and SceneAnimations[animation] or animation
    return animation
end

---
-- Find a scene by its name.
-- @param sceneName name of the Scene.
-- @return Scene object
function SceneMgr:getSceneByName(sceneName)
    for i, scene in ipairs(self.scenes) do
        if scene.name == sceneName then
            return scene
        end
    end
end

---
-- Add a scene.
-- @param scene scene
-- @return True if this scene didn't already exist in the list.
function SceneMgr:addScene(scene)
    RenderMgr:invalidate()
    return table.insertIfAbsent(self.scenes, scene)
end

---
-- Remove a scene.
-- @param scene scene
-- @return a number if the scene was removed; false if it wasn't there in the first place.
function SceneMgr:removeScene(scene)
    RenderMgr:invalidate()
    return table.removeElement(self.scenes, scene)
end

---
-- Returns the render table.
-- Used in RenderMgr.
-- @return Render table
function SceneMgr:getRenderTable()
    local t = {}
    for i, scene in ipairs(self.scenes) do
        if scene.opened then
            table.insertElement(t, scene:getRenderTable())
        end
    end
    return t
end

---
-- The event handler is called when you touch the screen.
-- Touch to fire a event to Scene.
-- @param e Touch event
function SceneMgr:onTouch(e)
    if not self.sceneTouchEnabled then
        return
    end

    local scene = self.currentScene
    if scene and scene.sceneTouchEnabled then
        scene:dispatchEvent(e)
    end
end

---
-- The event handler is called when enter frame.
-- Fire a event to Scene.
-- @param e Enter frame event
function SceneMgr:onEnterFrame(e)
    if not self.sceneUpdateEnabled then
        return
    end

    for i, scene in ipairs(self.scenes) do
        if scene.sceneUpdateEnabled then
            scene:dispatchEvent(Event.UPDATE)
        end
    end
end

SceneMgr:initialize()

return SceneMgr