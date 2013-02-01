module(..., package.seeall)

local touchX, touchY = 0, 0

function onCreate(params)
    mapLoader = TMXMapLoader()
    mapData = mapLoader:loadFile("platform.tmx")

    mapView = TMXMapView()
    mapView:loadMap(mapData)
    mapView:setScene(scene)
end

function onTouchDown(e)
    local layer = mapView:findLayerByName("Main")
    local wx, wy = layer:wndToWorld(e.x, e.y, 0)
    local mapX, mapY = math.floor(wx / mapData.tilewidth + 1), math.floor(wy / mapData.tileheight + 1)
    mapView:updateGid(layer, mapX, mapY, math.random(50))
end