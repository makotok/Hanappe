module(..., package.seeall)

function onCreate(params)
    layer = Layer:new({scene = scene})
    
    joystick1 = Joystick:new({
        baseTexture = "samples/assets/control_base.png",
        knobTexture = "samples/assets/control_knob.png",
        layer = layer,
    })
    joystick1:setLeft(0)
    joystick1:setTop(layer.viewHeight - joystick1:getHeight())
    joystick1:setScene(scene)
    joystick1:addEventListener("stickChanged", onStickChanged)

    joystick2 = Joystick:new({
        baseTexture = "samples/assets/control_base.png",
        knobTexture = "samples/assets/control_knob.png",
        stickMode = Joystick.MODE_DIGITAL,
        layer = layer,
    })
    joystick2:setLeft(layer.viewWidth - joystick2:getWidth())
    joystick2:setTop(layer.viewHeight - joystick2:getHeight())
    joystick2:setScene(scene)
    joystick2:addEventListener("stickChanged", onStickChanged)

end

function onStickChanged(e)
    print("-----------------------------")
    print("stick old :", e.oldX, e.oldY)
    print("stick new :", e.newX, e.newY)
    print("stick dir :", e.direction)
    print("stick down:", e.down)
end