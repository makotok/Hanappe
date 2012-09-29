module(..., package.seeall)

function onCreate(params)
    backgroundLayer = Layer {
        scene = scene,
    }
    background = Graphics {
        size = {backgroundLayer:getViewSize()},
        layer = backgroundLayer,
    }
    background:fillRect()
    
    view = View {
        scene = scene,
        layout = {
            VBoxLayout {
                align = {"center", "center"},
                padding = {10, 10, 10, 10},
            },
        },
    }
    
    showButton = Button {
        text = "Show",
        size = {200, 50},
        parent = view,
        onClick = onShowClick,
    }
    hideButton = Button {
        text = "Hide",
        size = {200, 50},
        parent = view,
        onClick = onHideClick,
    }
    backButton = Button {
        name = "backButton",
        text = "Back",
        size = {200, 50},
        parent = view,
        onClick = onBackClick,
    }
    messageBox = MessageBox {
        size = {view:getWidth() - 20, 120},
        text = "Hello MessageBox!\nmessage1\nmessage2\nmessage3\nmessage4\nmessage5\nmessage6",
        parent = view,
    }

end

function onShowClick(e)
    messageBox:show()
end

function onHideClick(e)
    messageBox:hide()
end

function onBackClick(e)
    SceneManager:closeScene({animation = "fade"})
end