module(..., package.seeall)

local touchX, touchY = 0, 0

function onCreate(params)
    mapLoader = TMXMapLoader()
    mapData = mapLoader:loadFile("platform.tmx")

    mapView = TMXMapView()
    mapView:loadMap(mapData)
    mapView:setScene(scene)
   
    printTileProperty() 
end

function onTouchMove(e)
    local viewScale = Application:getViewScale()
    mapView.camera:addLoc(-e.moveX / viewScale, -e.moveY / viewScale, 0)
end

function printTileProperty()
    print("gid=3, shape=" .. tostring(mapData:getTileProperty(3, "shape")))
    print("x=12, y=10, shape=" .. tostring(mapData.layers[2]:getTileProperty(12, 10, "shape")))
end