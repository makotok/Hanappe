module(..., package.seeall)

function onCreate(params)
    view = View {
        scene = scene,
    }

    analogStick = Joystick {
        onStickChanged = onStickChanged,
        stickMode = "analog",
        bottom = view:getHeight(),
        parent = view,
    }
    
    digitalStick = Joystick {
        onStickChanged = onStickChanged,
        stickMode = "digital",
        right = view:getWidth(),
        bottom = view:getHeight(),
        parent = view,
    }
end

function onStickChanged(e)
    print("-----------------------------")
    print("stick old :", e.oldX, e.oldY)
    print("stick new :", e.newX, e.newY)
    print("stick dir :", e.direction)
    print("stick down:", e.down)
end