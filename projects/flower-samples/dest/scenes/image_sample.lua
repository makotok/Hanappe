local scene = flower.Scene("image_sample")

--------------------------------------------------------------------------------
-- 
--------------------------------------------------------------------------------
function scene:onLoad(params)
    local layer = flower.Layer()
    layer:setTouchEnabled(true)
    scene:addChild(layer)

    local image = flower.Image("cathead.png")
    image:addEventListener("touch", image_onTouch)
    layer:insertProp(image)
    
end

function scene:onStart()

end


function scene:onStop()

end

function scene:onUnload()

end

function scene:onEnterFrame()

end

function image_onTouch(e)

end

return scene
