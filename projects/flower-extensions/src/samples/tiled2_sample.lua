module(..., package.seeall)

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

function onCreate(e)
    layer = flower.Layer()
    layer:setScene(scene)
    
    camera = flower.Camera()

    tileMap = tiled.TileMap()
    tileMap:loadMapfile("desert.lue")
    tileMap:setLayer(layer)
    
end

function onStart(e)
end
