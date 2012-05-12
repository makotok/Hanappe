module(..., package.seeall)

function onCreate(params)
    widgetView = WidgetView:new()
    widgetView:setScene(scene)
    
    joystick1 = Joystick:new({
        baseTexture = "samples/assets/control_base.png",
        knobTexture = "samples/assets/control_knob.png",
    })
    joystick1:setLeft(0)
    joystick1:setTop(widgetView.viewHeight - joystick1:getHeight())
    joystick1:addEventListener("stickChanged", onStickChanged)
    widgetView:addChild(joystick1)

    joystick2 = Joystick:new({
        baseTexture = "samples/assets/control_base.png",
        knobTexture = "samples/assets/control_knob.png",
        stickMode = Joystick.MODE_DIGITAL,
    })
    joystick2:setLeft(widgetView.viewWidth - joystick2:getWidth())
    joystick2:setTop(widgetView.viewHeight - joystick2:getHeight())
    joystick2:addEventListener("stickChanged", onStickChanged)
    widgetView:addChild(joystick2)

end

function onStickChanged(e)
    print("-----------------------------")
    print("stick old :", e.oldX, e.oldY)
    print("stick new :", e.newX, e.newY)
    print("stick dir :", e.direction)
    print("stick down:", e.down)
end