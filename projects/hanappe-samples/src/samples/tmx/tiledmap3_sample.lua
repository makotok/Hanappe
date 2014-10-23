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
    local objectLayer = mapView.objectLayers[1]
    local wx, wy = objectLayer:wndToWorld(e.x, e.y, 0)
    local object = objectLayer.partition:propForPoint(wx, wy, 0)
    
    if object then
        mapView:removeDisplayObject(objectLayer, object)
    end
end
