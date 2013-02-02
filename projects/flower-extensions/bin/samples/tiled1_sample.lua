module(..., package.seeall)

tiled = require "flower-tiled"

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

function onCreate(e)
    layer = flower.Layer()
    layer:setScene(scene)

    tileMap = tiled.TileMap()
    tileMap:loadMapfile("platform.lue")
    tileMap:setLayer(layer)
    
end

function onStart(e)
end
