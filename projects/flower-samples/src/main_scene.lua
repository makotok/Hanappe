module(..., package.seeall)

--------------------------------------------------------------------------------
-- Constraints
--------------------------------------------------------------------------------

Scenes = require "scenes"

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------

local selectedData
local backButton
local menuList

--------------------------------------------------------------------------------
-- Functions
--------------------------------------------------------------------------------

function createBackButton(childScene)
    local layer = flower.Layer()
    layer:setTouchEnabled(true)
    childScene:addChild(layer)
    
    local rect = flower.Rect(100, 30)
    rect:setColor(0, 0, 0.5, 1)
    rect:setLayer(layer)
    
    local label = flower.Label("Back")
    
    backButton = flower.Group(layer)
    backButton:setPos(flower.viewWidth - 100, 0)
    backButton:addChild(rect)
    backButton:addChild(label)
    backButton:addEventListener("touchDown", backButton_onTouchDown)
end

function updateLayout()
    if menuList then
        menuList:setSize(flower.viewWidth - 10, flower.viewHeight - 10)
        menuList:setPos(5, 5)
    end
    if backButton then
       backButton:setPos(flower.viewWidth - 100, 0)
    end
end

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

function onCreate(e)
    menuList = widget.ListView {
        scene = scene,
        dataField = "title",
        dataSource = {Scenes},
        onSelectedChanged = onSelectedChanged,
        onItemClick = onItemClick,
    }
    
    flower.Runtime:addEventListener("resize", onResize)
end

function onResize(e)
    updateLayout()
end

function onSelectedChanged(e)
end

function onItemClick(e)
    local data = e.data
    local childScene = flower.openScene(data.scene, {animation = data.openAnime})
    if childScene then
        selectedData = data
        createBackButton(childScene)
    end
end

function backButton_onTouchDown(e)
    if flower.SceneMgr.transitioning then
        return
    end
    
    flower.closeScene({animation = selectedData.closeAnime})
    backButton = nil
    selectedData = nil
end
