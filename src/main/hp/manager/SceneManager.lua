----------------------------------------------------------------
-- This is a class to manage the Scene. <br>
-- Order to manage the rendering of the scene and event notification. <br>
-- @class table
-- @name SceneManager
----------------------------------------------------------------

local table = require("hp/lang/table")
local SceneAnimation = require("hp/display/SceneAnimation")
local SceneFactory = require("hp/factory/SceneFactory")
local InputManager = require("hp/manager/InputManager")
local Event = require("hp/event/Event")
local EventDispatcher = require("hp/event/EventDispatcher")

local M = EventDispatcher()

-- private var
local scenes = {}
local sceneFactory = SceneFactory
local currentScene = nil
local currentClosing = false
local nextScene = nil
local transitioning = false
local sceneAnimation = nil
local renderTable = {}
local updateRenderFlag = false


local function onTouchDown(e)
    if currentScene and not transitioning then
        currentScene:onTouchDown(e)
    end
end

local function onTouchUp(e)
    if currentScene and not transitioning then
        currentScene:onTouchUp(e)
    end
end

local function onTouchMove(e)
    if currentScene and not transitioning then
        currentScene:onTouchMove(e)
    end
end

local function onTouchCancel(e)
    if currentScene and not transitioning then
        currentScene:onTouchCancel(e)
    end
end

local function onKeyDown(e)
    if currentScene and not transitioning then
        currentScene:onKeyDown(e)
    end
end

local function onKeyUp(e)
    if currentScene and not transitioning then
        currentScene:onKeyUp(e)
    end
end

local function onEnterFrame()
    local currentScene = currentScene
    if currentScene and not transitioning then
        currentScene:onEnterFrame()
    end
end

local function updateRender()
    renderTable = {}
    for i, scene in ipairs(scenes) do
        if scene.visible then
            table.insert(renderTable, scene:getRenderTable())
        end
    end
    MOAIRenderMgr.setRenderTable(renderTable)
end

local function addScene(scene)
    if table.indexOf(scenes, scene) == 0 then
        table.insert(scenes, scene)
    end
end

local function removeScene(scene)
    local i = table.indexOf(scenes, scene)
    if i > 0 then
        table.remove(scenes, i)
    end
end

local function hideScene(scene)
    if scene then
        scene:setVisible(false)
    end
end

local function showScene(scene)
    if scene then
        scene:setVisible(true)
        scene:setLeft(0)
        scene:setTop(0)
        scene:setColor(1, 1, 1, 1)
        scene:setScl(1, 1, 1)
        scene:setRot(0, 0, 0)
    end
end

local function animateScene(params, completeFunc)
    updateRenderFlag = true
    
    local animation = params.animation
    if animation then
        if type(animation) == "string" then
            animation = SceneAnimation[animation]
        end 
        transitioning = true
        animation(currentScene, nextScene, params):play({onComplete = completeFunc})
    else
        hideScene(currentScene)
        showScene(nextScene)
        
        completeFunc()
    end    
end

local function openComplete()
    if currentScene and currentClosing then
        removeScene(currentScene)
        currentScene:onDestroy()
    end
    
    transitioning = false
    currentScene = nextScene
    currentScene:onStart()
    currentScene:onResume()
    updateRenderFlag = true
end

local function closeComplete()
    transitioning = false
    removeScene(currentScene)
    currentScene:onDestroy()
    currentScene = nextScene
    
    --collectgarbage("collect")
    if nextScene then
        nextScene:onResume()
    end
    
    updateRender()
end

InputManager:addEventListener(Event.TOUCH_DOWN, onTouchDown)
InputManager:addEventListener(Event.TOUCH_UP, onTouchUp)
InputManager:addEventListener(Event.TOUCH_MOVE, onTouchMove)
InputManager:addEventListener(Event.TOUCH_CANCEL, onTouchCancel)
InputManager:addEventListener(Event.KEY_DOWN, onKeyDown)
InputManager:addEventListener(Event.KEY_UP, onKeyUp)

local thread = MOAICoroutine.new()
thread:run(
    function()
        while true do
            if updateRenderFlag then
                updateRenderFlag = false
                updateRender()
            end
            onEnterFrame()
            coroutine.yield()
        end
    end
)

--------------------------------------------------------------------------------
-- Open a new scene. <br>
-- The current scene is the stack intact. <br>
-- But if set to true currentClosing, close the current scene. <br>
-- <br>
-- You can specify the behavior in the argument params. <br>
-- 1. params.sceneClass <br>
--    Specifies the class of scenes to be generated. <br>
-- 2. params.animation <br>
--    Specifies the animation of the scene transitions. <br>
-- 3. params.sec <br>
--    Specifies the time of the animation.<br>
-- 4. params.currentClosing <br>
--    Specify whether to close the current scene. <br>
--
-- @param sceneName The unique name of the scene. Scene module path.
-- @param params (option)Parameters that define the behavior.
-- @return If you generate a return to the scene.
--------------------------------------------------------------------------------
function M:openScene(sceneName, params)
    if transitioning then
        return
    end

    params = params or {}
    currentClosing = params.currentClosing or false
    
    -- get next scene
    nextScene = self:findSceneByName(sceneName)
    if nextScene then
        nextScene = nil
        return
    end
    
    -- stop current scene
    if currentScene then
        currentScene:onPause()
        if currentClosing then
            currentScene:onStop()
        end
    end
    
    -- create scene
    local scene = sceneFactory.createScene(sceneName, params)
    scene:onCreate(params)
    addScene(scene)
    nextScene = scene
    
    animateScene(params, openComplete)
    
    return nextScene
end

--------------------------------------------------------------------------------
-- Open to the next scene. <br>
-- The current scene will be closed. <br>
-- See M:openScene(). <br>
-- @param The unique name of the scene. Scene module path.
-- @param params (option)Parameters that define the behavior.
-- @return If you generate a return to the scene.
--------------------------------------------------------------------------------
function M:openNextScene(sceneName, params)
    params = params and params or {}
    params.currentClosing = true
    return self:openScene(sceneName, params)
end

--------------------------------------------------------------------------------
-- Close the current scene. <br>
-- To resume the previous scene.
-- @param params (option)Parameters that define the behavior.
--------------------------------------------------------------------------------
function M:closeScene(params)
    if transitioning then
        return
    end
    if #scenes == 0 then
        return
    end
    
    params = params and params or {}
    
    nextScene = scenes[#scenes - 1]
    currentScene:onStop()
    
    animateScene(params, closeComplete)
    
    return nextScene
end

--------------------------------------------------------------------------------
-- Update the drawing order of layers. <br>
-- Normally, you need to manipulate this function is not available. <br>
-- Timing to be updated, in fact, is done in EnterFrame.
--------------------------------------------------------------------------------
function M:updateRender()
    updateRenderFlag = true
end

--------------------------------------------------------------------------------
-- Update the drawing order of layers. <br>
-- Normally, you need to manipulate this function is not available.
--------------------------------------------------------------------------------
function M:forceUpdateRender()
    updateRender()
end


--------------------------------------------------------------------------------
-- Returns the scene to find the scene name.
-- @param sceneName Name of the target scene.
-- @return If a match is found the scene.
--------------------------------------------------------------------------------
function M:findSceneByName(sceneName)
    for i, scene in ipairs(scenes) do
        if scene.name == sceneName then
            return scene
        end
    end
    return nil
end

--------------------------------------------------------------------------------
-- Move to the front scene. <br>
-- @param scene Scene or scene name.
--------------------------------------------------------------------------------
function M:orderToFront(scene)
    if #scenes <= 1 then
        return
    end
    
    scene = type(scene) == "string" and self:findSceneByName(scene) or scene
    
    local i = table.indexOf(scenes, scene)
    if i > 0 then
        table.remove(scenes, i)
        table.insert(scenes, scene)
        currentScene = scene
        self:updateRender()
    end
end

--------------------------------------------------------------------------------
-- Move to the back scene. <br>
-- @param scene Scene or scene name.
--------------------------------------------------------------------------------
function M:orderToBack(scene)
    if #scenes <= 1 then
        return
    end

    scene = type(scene) == "string" and self:findSceneByName(scene) or scene

    local i = table.indexOf(scenes, scene)
    if i > 0 then
        table.remove(scenes, i)
        table.insert(scenes, 1, scene)
        currentScene = scenes[#scenes]
        self:updateRender()
    end
end

--------------------------------------------------------------------------------
-- Sets the SceneFactory. <br>
-- If you need to use your own factory. <br>
-- @param factory Scene factory module.
--------------------------------------------------------------------------------
function M:setSceneFactory(factory)
    sceneFactory = assert(factory, "sceneFactory is nil!")
end

--------------------------------------------------------------------------------
-- Returns the current scene. <br>
-- @return currentScene.
--------------------------------------------------------------------------------
function M:getCurrentScene()
    return currentScene
end

return M