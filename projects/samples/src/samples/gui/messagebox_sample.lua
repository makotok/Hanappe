module(..., package.seeall)

function onCreate(params)
    view = View {
        scene = scene,
        layout = VBoxLayout {
            align = {"center", "center"},
            padding = {10, 10, 10, 10},
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
        text = "Back",
        size = {200, 50},
        parent = view,
        onClick = onBackClick,
    }
    messageBox = MessageBox {
        size = {view:getWidth() - 20, 120},
        text = "メッセージボックスのさんぷるです。\n内部的にはTextLabelが表示されています。\nHello MessageBox!\n改行とか？",
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