module(..., package.seeall)

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

function onCreate(e)
    scrollView = widget.ScrollView {
        scene = scene,
        bouncePolicy = {false, false},
    }

    tileMap = tiled.TileMap()
    tileMap:loadLueFile("desert.lue")
    
    scrollView:addContent(tileMap)
end

