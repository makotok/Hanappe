module(..., package.seeall)

function onCreate(params)
    view = View()
    view:setScene(scene)
    
    joystick1 = Joystick {
        baseTexture = "control_base.png",
        knobTexture = "control_knob.png",
    }
    joystick1:setLeft(0)
    joystick1:setTop(view.viewHeight - joystick1:getHeight())
    joystick1:addEventListener("stickChanged", onStickChanged)
    view:addChild(joystick1)

    joystick2 = Joystick {
        baseTexture = "control_base.png",
        knobTexture = "control_knob.png",
        stickMode = Joystick.MODE_DIGITAL,
    }
    joystick2:setLeft(view.viewWidth - joystick2:getWidth())
    joystick2:setTop(view.viewHeight - joystick2:getHeight())
    joystick2:addEventListener("stickChanged", onStickChanged)
    view:addChild(joystick2)

end

function onStickChanged(e)
    print("-----------------------------")
    print("stick old :", e.oldX, e.oldY)
    print("stick new :", e.newX, e.newY)
    print("stick dir :", e.direction)
    print("stick down:", e.down)
end