module(..., package.seeall)

local spineboy

function onCreate()
    local layer = flower.Layer()
    layer:setScene(scene)

    layer:setSortMode(MOAILayer.SORT_PRIORITY_ASCENDING)

    spineboy = spine.Skeleton("spineboy_atlas/spineboy.json", "spineboy_atlas/spineboy.atlas")
    
    spineboy:setLayer(layer)
    spineboy:setLoc(140, 400)
    spineboy:playAnim('walk', true)
end

function onClose(e)
    spineboy:stopAnim()
end