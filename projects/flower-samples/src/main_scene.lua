module(..., package.seeall)

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------
SAMPLES = {
    {title = "Image", scene = "samples/image_sample"},
    {title = "SheetImage", scene = "samples/sheetimage_sample"},
    {title = "MovieClip", scene = "samples/movieclip_sample"},
    {title = "MapImage", scene = "samples/mapimage_sample"},
    {title = "Label", scene = "samples/label_sample"},
}

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

function onLoad(e)
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
        label.item = item

        local item = flower.Group(layer)
        item:setPos(10, (i * 40))
        item:addChild(rect)
        item:addChild(label)
        item:addEventListener("touch", item_onTouch)
    end
end

function item_onTouch(e)
    print("item on touch")
    if e.kind == "down" then
        local t = e.prop
        if t.item then
            local childScene = flower.openScene(t.item.scene, {animation = "fade"})
            createBackButton(childScene)
        end
    end
end

function createBackButton(childScene)
    local layer = flower.Layer()
    layer:setTouchEnabled(true)
    childScene:addChild(layer)
    
    local rect = flower.Rect(100, 30)
    rect:setColor(0, 0, 0.5, 1)
    rect:setLayer(layer)
    
    local label = flower.Label("Back", 100, 30)
    
    local back = flower.Group(layer)
    back:setPos(flower.viewWidth - 100, 0)
    back:addChild(rect)
    back:addChild(label)
    back:addEventListener("touch", back_onTouch)
end

function back_onTouch(e)
    if e.kind == "down" then
        flower.closeScene({animation = "fade"})
    end
end
