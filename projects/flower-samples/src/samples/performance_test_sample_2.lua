module(..., package.seeall)

local IMAGE_SIZE = 6000

function onCreate(e)
    layer = flower.Layer()
    layer:setTouchEnabled(true)
    layer:setScene(scene)
    layer:setSortMode(MOAILayer.SORT_NONE)
    
    createImages(IMAGE_SIZE)
end

function createImages(size)
    for i = 1, size do
        local image = flower.Image("moai.png", 64, 64)
        image:setLayer(layer)
        image:setPos(math.random(flower.viewWidth - 64), math.random(flower.viewHeight - 64))
    end
end
