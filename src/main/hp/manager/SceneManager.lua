local table = require("hp/lang/table")
local SceneFactory = require("hp/display/SceneFactory")
local SceneAnimation = require("hp/display/SceneAnimation")
local InputManager = require("hp/manager/InputManager")
local Event = require("hp/event/Event")
local EventDispatcher = require("hp/event/EventDispatcher")

----------------------------------------------------------------
-- Sceneを管理するマネージャクラスです.<br>
-- シーンのライフサイクルの管理やイベント制御を行います.
-- @class table
-- @name SceneManager
----------------------------------------------------------------
local M = EventDispatcher:new()

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

----------------------------------------------------------------
-- private functions
----------------------------------------------------------------

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
        self:removeScene(currentScene)
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

----------------------------------------------------------------
-- public functions
----------------------------------------------------------------

---------------------------------------
-- 新しいシーンを表示します.
-- 現在のシーンはそのままスタックされた状態で、
-- 次のシーンを表示します.
--
-- params引数で、いくつかの動作を変更できます.
-- 1. params.sceneClassを指定した場合、
--    Sceneクラスではなく、別のクラスをnewします.
-- 2. params.animationを指定した場合、
--    
---------------------------------------
function M:openScene(sceneName, params)
    if transitioning then
        return
    end

    params = params or {}
    
    -- get next scene
    nextScene = self:findSceneByName(sceneName)
    if nextScene then
        nextScene = nil
        return
    end
    
    -- stop current scene
    if currentScene then
        currentScene:onPause()
        if params.currentClosing then
            currentScene:onStop()
        end
    end
    
    -- create scene
    local scene = sceneFactory:createScene(sceneName, params)
    scene:onCreate(params)
    addScene(scene)
    nextScene = scene
    
    animateScene(params, openComplete)
    
    return nextScene
end

---------------------------------------
-- 次のシーンに遷移します.
-- 現在のシーンは終了します.
---------------------------------------
function M:openNextScene(sceneName, params)
    params = params and params or {}
    params.closing = true
    return self:openScene(sceneName, params)
end

---------------------------------------
-- 現在のシーンを終了します.
-- 前のシーンに遷移します.
---------------------------------------
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

---------------------------------------
-- 描画を更新します.
---------------------------------------
function M:updateRender()
    updateRenderFlag = true
end

---------------------------------------
-- 描画を更新します.
---------------------------------------
function M:forceUpdateRender()
    updateRender()
end


---------------------------------------
-- シーン名からシーンを検索して返します.
-- 見つからない場合はnilを返します.
---------------------------------------
function M:findSceneByName(sceneName)
    for i, scene in ipairs(scenes) do
        if scene.name == sceneName then
            return scene
        end
    end
    return nil
end

---------------------------------------
-- シーンを最前面に移動します.
---------------------------------------
function M:orderToFront(scene)
    if #scenes <= 1 then
        return
    end
    
    local i = table.indexOf(scenes, scene)
    if i > 0 then
        table.remove(scenes, i)
        table.insert(scenes, scene)
        currentScene = scene
        self:updateRender()
    end
end

---------------------------------------
-- シーンを最背面に移動します.
---------------------------------------
function M:orderToBack(scene)
    if #scenes <= 1 then
        return
    end    
    local i = table.indexOf(scenes, scene)
    if i > 0 then
        table.remove(scenes, i)
        table.insert(scenes, 1, scene)
        currentScene = scenes[#scenes]
        self:updateRender()
    end
end

---------------------------------------
-- SceneFactoryを設定します.<br>
---------------------------------------
function M:setSceneFactory(factory)
    sceneFactory = assert(factory, "sceneFactory is nil!")
end

return M