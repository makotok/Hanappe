module(..., package.seeall)

function onCreate(params)
    view = View {
        scene = scene,
        layout = {VBoxLayout {hAlign = "right", vAlign = "bottom"} },
        children = {{
            Button {
                name = "startButton",
                text = "はじめ",
                onClick = onStartClick,
            },
            Button {
                name = "backButton",
                text = "戻る",
                onClick = onBackClick,
            },
            Button {
                name = "testButton1",
                text = "disabled",
                enabled = false,
            },
        }},
    }
    view:updateComponent()
end

function onStartClick(e)
    print("onStartClick")
end

function onBackClick(e)
    SceneManager:closeScene({animation = "fade"})
end