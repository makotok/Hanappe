module(..., package.seeall)

function onCreate(params)
    view = GUI.View {
        scene = scene,
        layout = {GUI.VBoxLayout {hAlign = "right", vAlign = "bottom"} },
        children = {{
            GUI.Button {
                name = "showButton",
                text = "Show",
                height = 50,
                onClick = onShowClick,
            },
            GUI.Button {
                name = "showButton",
                text = "Hide",
                height = 50,
                onClick = onHideClick,
            },
            GUI.Button {
                name = "backButton",
                text = "Back",
                height = 50,
                onClick = onBackClick,
            },
            GUI.MessageBox {
                name = "messageBox",
                size = {300, 100},
                text = "Hello MessageBox!",
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