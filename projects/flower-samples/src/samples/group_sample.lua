module(..., package.seeall)

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

function onCreate(e)
    layer = flower.Layer()
    scene:addChild(layer)

    -- group1
    group1 = flower.Group()
    group1:setLayer(layer)
    group1:setSize(200, 200)
    group1:setPivToCenter()
    
    -- group2
    group2 = flower.Group()
    group1:addChild(group2)

    -- group3
    group3 = flower.Group()
    group3:setSize(50, 50)
    group3:setSize(100, 100)
    group3:setScissorContent(true)
    group2:addChild(group3)

    -- image1
    image1 = flower.Image("cathead.png")
    group1:addChild(image1)
    
    -- image2
    image2 = flower.Image("cathead.png", 64, 64)
    group2:setPos(0, image1:getBottom())
    group2:addChild(image2)
    
    -- image3
    image3 = flower.Image("cathead.png")
    image3:setPos(100, 100)
    group1:addChild(image3)
    group1:removeChild(image3)
    
    -- image4
    image4 = flower.Image("cathead.png")
    image4:setPos(120, 120)
    image4:setVisible(false)
    group2:addChild(image4)

    -- image5
    image5 = flower.Image("cathead.png")
    image5:setPos(50, 50)
    group3:addChild(image5)
end

function onStart(e)
    -- animation test
    flower.callOnce(function()
        local action1 = group1:moveLoc(100, 100, 0, 3)
        MOAICoroutine.blockOnAction(action1)

        local action2 = group1:moveRot(0, 0, 360, 3)
        MOAICoroutine.blockOnAction(action2)
        
        group2:setVisible(false)
        --group2:forceUpdate()
    end)
end