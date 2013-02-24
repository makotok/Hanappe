module(..., package.seeall)

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

function onCreate(e)
    layer = flower.Layer()
    layer:setScene(scene)
    layer:setSortMode(MOAILayer.SORT_PRIORITY_ASCENDING)
    layer:setTouchEnabled(true)
    
    tileMap = tiled.TileMap()
    tileMap:loadLueFile("platform.lue")
    tileMap:setLayer(layer)

    tileMap:addEventListener("touchDown", tileMap_OnTouchDown)
    tileMap:addEventListener("touchUp", tileMap_OnTouchUp)
    tileMap:addEventListener("touchMove", tileMap_OnTouchMove)
    tileMap:addEventListener("touchCancel", tileMap_OnTouchUp)
end

function tileMap_OnTouchDown(e)
    if tileMap.lastTouchEvent then
        return
    end
    tileMap.lastTouchIdx = e.idx
    tileMap.lastTouchWX = e.wx
    tileMap.lastTouchWY = e.wy    
end

function tileMap_OnTouchUp(e)
    if not tileMap.lastTouchIdx then
        return
    end
    if tileMap.lastTouchIdx ~= e.idx then
        return
    end
    tileMap.lastTouchIdx = nil
    tileMap.lastTouchWX = nil
    tileMap.lastTouchWY = nil    
end

function tileMap_OnTouchMove(e)
    if not tileMap.lastTouchIdx then
        return
    end
    if tileMap.lastTouchIdx ~= e.idx then
        return
    end
    
    local moveX = e.wx - tileMap.lastTouchWX
    local moveY = e.wy - tileMap.lastTouchWY
    local left, top = tileMap:getPos()
    left = math.max(math.min(0, left + moveX), -math.max(tileMap:getWidth() - flower.viewWidth, 0))
    top = math.max(math.min(0, top + moveY), -math.max(tileMap:getHeight() - flower.viewHeight, 0))
    tileMap:setPos(left, top)

    tileMap.lastTouchWX = e.wx
    tileMap.lastTouchWY = e.wy
end