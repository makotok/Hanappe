module(..., package.seeall)

function onCreate(params)
    layer = Layer({scene = scene})
    sprite1 = Sprite({texture = "cathead.png", layer = layer, left = 0, top = 0})
    sprite2 = Sprite({texture = "cathead.png", layer = layer, left = 0, top = sprite1:getBottom()})
end

function touchHandler(e)
    print(e.type, e.idx, e.x, e.y, e.tapCount)
end

function keyHandler(e)
    print(e.type, e.key)
end

-- add event listeners
InputManager:addEventListener("touchDown", touchHandler)
InputManager:addEventListener("touchUp", touchHandler)
InputManager:addEventListener("touchMove", touchHandler)
InputManager:addEventListener("touchCancel", touchHandler)
InputManager:addEventListener("keyDown", keyHandler)
InputManager:addEventListener("keyUp", keyHandler)

--[[
-- remove event listeners
InputManager:removeEventListener("touchDown", touchHandler)
InputManager:removeEventListener("touchUp", touchHandler)
InputManager:removeEventListener("touchMove", touchHandler)
InputManager:removeEventListener("touchCancel", touchHandler)
InputManager:removeEventListener("keyDown", keyHandler)
InputManager:removeEventListener("keyUp", keyHandler)
--]]
