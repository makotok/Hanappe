module(..., package.seeall)

local touchX, touchY = 0, 0

function onCreate(params)
    mapLoader = TMXMapLoader:new()
    mapData = mapLoader:loadFile("samples/assets/platform.tmx")

    mapView = TMXMapView:new("samples/assets/")
    mapView:loadMap(mapData)
    mapView:setScene(scene)
end

function onTouchDown(e)
    touchX, touchY = e.x, e.y
end

function onTouchMove(e)
    local moveX, moveY = touchX - e.x, touchY - e.y
    mapView.camera:addLoc(moveX, moveY, 0)
    touchX, touchY = e.x, e.y
end