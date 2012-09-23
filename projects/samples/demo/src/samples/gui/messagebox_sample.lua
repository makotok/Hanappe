module(..., package.seeall)

function onCreate(params)
    view = View {
        scene = scene,
        layout = {VBoxLayout {hAlign = "right", vAlign = "bottom"} },
        children = {{
            Button {
                name = "showButton",
                text = "Show",
                height = 50,
                onClick = onShowClick,
            },
            Button {
                name = "showButton",
                text = "Hide",
                height = 50,
                onClick = onHideClick,
            },
            Button {
                name = "backButton",
                text = "Back",
                height = 50,
                onClick = onBackClick,
            },
            MessageBox {
                name = "messageBox",
                size = {300, 100},
                text = "Hello MessageBox!\nmessage1\nmessage2\nmessage3\nmessage4\nmessage5\nmessage6",
            },
        }},
    }
    
    messageBox = assert(view:getChildByName("messageBox"))
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