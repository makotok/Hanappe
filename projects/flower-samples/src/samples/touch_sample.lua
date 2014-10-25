module(..., package.seeall)

--------------------------------------------------------------------------------
-- Functions
--------------------------------------------------------------------------------

function addTouchEventListeners(item)
    item:addEventListener("touchDown", item_onTouchDown)
    item:addEventListener("touchUp", item_onTouchUp)
    item:addEventListener("touchMove", item_onTouchMove)
    item:addEventListener("touchCancel", item_onTouchCancel)
end

function printTouchEvent(e)
    print("-----" .. e.target.name .. "-----")
    print("type     = " .. e.type)
    print("idx      = " .. e.idx)
    print("tapCount = " .. e.tapCount)
    print("x        = " .. e.x)
    print("y        = " .. e.y)
    print("wx       = " .. e.wx)
    print("wy       = " .. e.wy)
end

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

function onCreate(e)
    layer = flower.Layer()
    layer:setTouchEnabled(true)
    scene:addChild(layer)
    
    -- group
    group = flower.Group(layer)
    group.name = "group"

    -- image1
    image1 = flower.Image("cathead.png")
    image1.name = "image1"
    group:addChild(image1)
    
    -- image2
    image2 = flower.Image("cathead.png")
    image2.name = "image2"
    image2:setPos(15, 15)
    group:addChild(image2)

    -- image3
    image3 = flower.Image("cathead.png")
    image3.name = "image3"
    image3:setPos(30, 30)
    image3:setVisible(false)
    group:addChild(image3)
    
    -- add event listeners
    addTouchEventListeners(group)
    addTouchEventListeners(image1)
    addTouchEventListeners(image2)
    addTouchEventListeners(image3)
end

function onStart(e)
    image1:moveLoc(50, 50, 0, 5)
    image1:moveRot(0, 0, 90, 5)
    image1:moveScl(1, 1, 0, 5)
end

function item_onTouchDown(e)
    printTouchEvent(e)
    
    local prop = e.prop
    if prop == nil or prop.touchDown and prop.touchIdx ~= e.idx then
        return
    end
    
    prop.touchDown = true
    prop.touchIdx = e.idx
    prop.touchLastX = e.wx
    prop.touchLastY = e.wy
end

function item_onTouchUp(e)
    printTouchEvent(e)
    
    local prop = e.prop
    if prop == nil or prop.touchDown and prop.touchIdx ~= e.idx then
        return
    end

    prop.touchDown = false
    prop.touchIdx = nil
    prop.touchLastX = nil
    prop.touchLastY = nil
end

function item_onTouchMove(e)
    printTouchEvent(e)
    
    local prop = e.prop
    if prop == nil or not prop.touchDown then
        return
    end
    
    local moveX = e.wx - prop.touchLastX 
    local moveY = e.wy - prop.touchLastY
    prop:addLoc(moveX, moveY, 0)
    prop.touchLastX  = e.wx
    prop.touchLastY = e.wy
end

function item_onTouchCancel(e)
    printTouchEvent(e)
    
    local prop = e.prop
    if prop == nil or not prop.touchDown then
        return
    end
    
    prop.touchDown = false
    prop.touchIdx = nil
    prop.touchLastX = nil
    prop.touchLastY = nil
end
