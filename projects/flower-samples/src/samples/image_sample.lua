module(..., package.seeall)

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

function onCreate(e)
    layer = flower.Layer()
    scene:addChild(layer)

    -- image1
    image1 = flower.Image("cathead.png")
    image1:setLayer(layer)
    
    -- image2
    image2 = flower.Image("cathead.png", 64, 64)
    image2:setPos(0, image1:getBottom())
    image2:setLayer(layer)
end

function onStart(e)
    -- animation test
    flower.callOnce(function()
        -- move loc
        local action1 = image1:moveLoc(40, 40, 0, 3)
        MOAICoroutine.blockOnAction(action1)
    
        -- move rot
        local action2 = image1:moveRot(0, 0, 360, 3)
        MOAICoroutine.blockOnAction(action2)
    
        -- move scl
        local action3 = image1:moveScl(1, 1, 0, 3)
        MOAICoroutine.blockOnAction(action3)
    
        -- move piv
        local action4 = image1:movePiv(-image1:getWidth() / 2, -image1:getHeight() / 2, 0, 3)
        MOAICoroutine.blockOnAction(action4)
        image1:setPos(0, 0)
    
    end)
end
