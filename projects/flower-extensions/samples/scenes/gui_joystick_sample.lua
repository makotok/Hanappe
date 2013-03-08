module(..., package.seeall)

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

function onCreate(e)
    layer = flower.Layer()
    layer:setScene(scene)
    layer:setTouchEnabled(true)
    
    joystick = gui.Joystick()
    joystick:setStickMode("analog")
    joystick:setPos(5, flower.viewHeight - joystick:getHeight() - 5)
    joystick:setLayer(layer)
    joystick:addEventListener("stickChanged", joystick_OnStickChanged)

    joystick = gui.Joystick("skins/joystick_base.png", "skins/joystick_knob.png")
    joystick:setStickMode("digital")
    joystick:setPos(flower.viewWidth - joystick:getWidth() - 5, flower.viewHeight - joystick:getHeight() - 5)
    joystick:setLayer(layer)
    joystick:addEventListener("stickChanged", joystick_OnStickChanged)
end

function joystick_OnStickChanged(e)
    print("-----------------------------")
    print("stick old :", e.oldX, e.oldY)
    print("stick new :", e.newX, e.newY)
    print("stick dir :", e.direction)
    print("stick down:", e.down)
end