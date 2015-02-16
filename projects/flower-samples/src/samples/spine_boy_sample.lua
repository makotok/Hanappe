module(..., package.seeall)

local spineboy

-- You should see some artifacts and strong aliasing when loading spineboy from separate images. 
-- This is because those .png files have alpha bleeding which is not compatible with premultiplied alpha. 
-- To workaround this issue we can load images without premultiplying alpha and setting apropriate shader
-- or resave assets in proper way disabling alpha bleeding. 
--
-- Prefered way would be to use texture atlas for export with these parameters:
--  * uncheck Bleed
--  * uncheck Premultiply Alpha (this will be done by Moai at load time, or by Xcode at compile time)
--  * filter Min and Mag - Linear (for some kind of antialiasing) or Nearest for pixel art games

function onCreate()
    local layer = flower.Layer()
    layer:setScene(scene)

    layer:setSortMode(MOAILayer.SORT_PRIORITY_ASCENDING)

    spineboy = spine.Skeleton("spineboy/spineboy.json", "spineboy/")
    
    spineboy:setLayer(layer)
    spineboy:setLoc(140, 400)
    spineboy:playAnim('walk', true)
end

function onClose(e)
    spineboy:stopAnim()
end