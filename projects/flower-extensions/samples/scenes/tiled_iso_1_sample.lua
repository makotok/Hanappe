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
    
    -- TODO: Tile Map Editor 0.9 Bug
    mapData = dofile("assets/isometric_grass_and_water2.lue")
    mapData.tilesets[1].tileoffsetx = 0
    mapData.tilesets[1].tileoffsety = 16
    
    tileMap = tiled.TileMap()
    tileMap:loadMapData(mapData)
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
    camera:addLoc(-moveX, -moveY, 0)

    tileMap.lastTouchX = e.x
    tileMap.lastTouchY = e.y
end