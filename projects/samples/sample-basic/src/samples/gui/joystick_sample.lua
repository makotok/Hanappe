module(..., package.seeall)

function onCreate(params)
    view = GUI.View {
        scene = scene,
        children = {{
            GUI.Joystick {
                name = "analogStick",
                onStickChanged = onStickChanged,
                stickMode = "analog",
                bottom = Application:getViewHeight(),
            },
            GUI.Joystick {
                name = "digitalStick",
                onStickChanged = onStickChanged,
                stickMode = "digital",
                right = Application:getViewWidth(),
                bottom = Application:getViewHeight(),
            },
        }},
    }
    
    analogStick = view:getChildByName("analogStick")
    digitalStick = view:getChildByName("digitalStick")
end

function onStickChanged(e)
    print("-----------------------------")
    print("stick old :", e.oldX, e.oldY)
    print("stick new :", e.newX, e.newY)
    print("stick dir :", e.direction)
    print("stick down:", e.down)
end