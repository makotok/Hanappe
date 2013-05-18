module(..., package.seeall)

--------------------------------------------------------------------------------
-- Constraints
--------------------------------------------------------------------------------

SAMPLES = require "scene_list"

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------

local selectedData
local backButton
local view
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
    
    local label = flower.Label("Back", 100, 30)
    
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
    view = widget.UIView {
        scene = scene,
    }
    
    menuList = widget.ListBox {
        size = {flower.viewWidth - 10, flower.viewHeight - 10},
        pos = {5, 5},
        parent = view,
        labelField = "title",
        listData = {SAMPLES},
        rowHeight = 35,
        listItemFactory = flower.ClassFactory(widget.ListItem, {textSize = 20}),
        onItemChanged = menuList_OnItemChanged,
        onItemEnter = menuList_OnItemEnter,
    }
    
    flower.Runtime:addEventListener("resize", onResize)
end

function onResize(e)
    updateLayout()
end

function menuList_OnItemChanged(e)
end

function menuList_OnItemEnter(e)
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
