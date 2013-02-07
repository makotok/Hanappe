module(..., package.seeall)

--------------------------------------------------------------------------------
-- Constraints
--------------------------------------------------------------------------------

SAMPLES = {
    {title = "Tiled Basic 1", scene = "samples/tiled_basic_1_sample", openAnime = "fade", closeAnime = "fade"},
    {title = "Tiled Basic 2", scene = "samples/tiled_basic_2_sample", openAnime = "fade", closeAnime = "fade"},
    {title = "Tiled Isometric 1", scene = "samples/tiled_iso_1_sample", openAnime = "fade", closeAnime = "fade"},
}

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------

local selectedData = nil

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
    
    local backButton = flower.Group(layer)
    backButton:setPos(flower.viewWidth - 100, 0)
    backButton:addChild(rect)
    backButton:addChild(label)
    backButton:addEventListener("touchDown", backButton_onTouchDown)
end

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

function onCreate(e)
    -- layer
    layer = flower.Layer()
    layer:setTouchEnabled(true)
    scene:addChild(layer)
    
    -- samples
    local itemWidth = flower.viewWidth - 20
    for i, item in ipairs(SAMPLES) do
        local rect = flower.Rect(itemWidth, 30)
        rect:setColor(0, 0, 0.5, 1)
    
        local label = flower.Label(item.title, itemWidth, 30)

        local menuitem = flower.Group(layer)
        menuitem.data = item
        menuitem:setPos(10, (i * 40))
        menuitem:addChild(rect)
        menuitem:addChild(label)
        menuitem:addEventListener("touchDown", menuitem_onTouchDown)
    end
    
    flower.Runtime:addEventListener("resize", onResize)
end

function onResize(e)
    print("width = " .. e.width, "height = " .. e.height)
end

function menuitem_onTouchDown(e)
    if flower.SceneMgr.transitioning then
        return
    end

    local t = e.target
    local data = t and t.data
    if data then
        local childScene = flower.openScene(data.scene, {animation = data.openAnime})
        if childScene then
            selectedData = data
            createBackButton(childScene)
        end
    end
end

function backButton_onTouchDown(e)
    if flower.SceneMgr.transitioning then
        return
    end

    flower.closeScene({animation = selectedData.closeAnime})
end
