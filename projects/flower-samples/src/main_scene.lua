module(..., package.seeall)

--------------------------------------------------------------------------------
-- Constraints
--------------------------------------------------------------------------------

SAMPLES = {
    {title = "Image",       scene = "samples/image_sample",         openAnime = "fade",         closeAnime = "fade"},
    {title = "SheetImage",  scene = "samples/sheetimage_sample",    openAnime = "crossFade",    closeAnime = "crossFade"},
    {title = "MovieClip",   scene = "samples/movieclip_sample",     openAnime = "popIn",        closeAnime = "popOut"},
    {title = "MapImage",    scene = "samples/mapimage_sample",      openAnime = "slideLeft",    closeAnime = "slideRight"},
    {title = "NineImage",   scene = "samples/nineimage_sample",     openAnime = "slideLeft",    closeAnime = "slideRight"},
    {title = "Label",       scene = "samples/label_sample",         openAnime = "slideRight",   closeAnime = "slideLeft"},
    {title = "Group",       scene = "samples/group_sample",         openAnime = "slideRight",   closeAnime = "slideLeft"},
    {title = "Scene",       scene = "samples/scene_sample",         openAnime = "slideTop",     closeAnime = "slideBottom"},
    {title = "Touch",       scene = "samples/touch_sample",         openAnime = "slideBottom",  closeAnime = "slideTop"},
    {title = "Input",       scene = "samples/input_sample",         openAnime = "change",       closeAnime = "change"},
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
