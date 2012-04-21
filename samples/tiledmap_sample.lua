module(..., package.seeall)

local touchX, touchY = 0, 0

function onCreate()
    mapData = TMXMapFactory:loadMap("samples/assets/platform.tmx")
    mapData.resourceDirectory = "samples/assets/"

    gameMap = TMXMapFactory:createDisplay(mapData)
    gameMap:setScene(scene)
end

function onTouchDown(e)
    touchX, touchY = e.x, e.y
end

function onTouchMove(e)
    local moveX, moveY = touchX - e.x, touchY - e.y
    gameMap.camera:addLoc(moveX, moveY, 0)
    touchX, touchY = e.x, e.y
end