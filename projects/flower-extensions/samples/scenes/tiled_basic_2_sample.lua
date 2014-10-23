module(..., package.seeall)

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

function onCreate(e)
    layer = flower.Layer()
    layer:setScene(scene)
    layer:setTouchEnabled(true)
    
    camera = flower.Camera()
    layer:setCamera(camera)
    
    tileMap = tiled.TileMap()
    tileMap:loadLueFile("desert.lue")
    tileMap:setLayer(layer)
    
    tileMap:addEventListener("touchDown", tileMap_OnTouchDown)
    tileMap:addEventListener("touchUp", tileMap_OnTouchUp)
    tileMap:addEventListener("touchMove", tileMap_OnTouchMove)
    tileMap:addEventListener("touchCancel", tileMap_OnTouchUp)
end

function onStart(e)
end

function tileMap_OnTouchDown(e)
    if tileMap.lastTouchEvent then
        return
    end
    tileMap.lastTouchIdx = e.idx
    tileMap.lastTouchX = e.x
    tileMap.lastTouchY = e.y    
end

function tileMap_OnTouchUp(e)
    if not tileMap.lastTouchIdx then
        return
    end
    if tileMap.lastTouchIdx ~= e.idx then
        return
    end
    tileMap.lastTouchIdx = nil
    tileMap.lastTouchX = nil
    tileMap.lastTouchY = nil    
end

function tileMap_OnTouchMove(e)
    if not tileMap.lastTouchIdx then
        return
    end
    if tileMap.lastTouchIdx ~= e.idx then
        return
    end
    
    local moveX = e.x - tileMap.lastTouchX
    local moveY = e.y - tileMap.lastTouchY
    local x, y, z = camera:getLoc()
    x = math.min(math.max(0, x - moveX), math.max(tileMap:getWidth() - flower.viewWidth, 0))
    y = math.min(math.max(0, y - moveY), math.max(tileMap:getHeight() - flower.viewHeight, 0))
    camera:setLoc(x, y, z)

    tileMap.lastTouchX = e.x
    tileMap.lastTouchY = e.y
end