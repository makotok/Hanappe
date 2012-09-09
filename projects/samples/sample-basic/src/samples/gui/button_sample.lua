module(..., package.seeall)

local GUI = require "hp/modules/GUI"

function onCreate(params)
    view = GUI.View {
        scene = scene,
        layout = {GUI.VBoxLayout {hAlign = "right", vAlign = "bottom"} },
        children = {{
            GUI.Button {
                name = "startButton",
                text = "はじめ",
                onClick = onStartClick,
            },
            GUI.Button {
                name = "backButton",
                text = "戻る",
                onClick = onBackClick,
            },
            GUI.Button {
                name = "testButton1",
                text = "test1",
                onClick = onBackClick,
            },
            GUI.Button {
                name = "testButton2",
                text = "test2",
                onClick = onBackClick,
            },
        }},
    }
    
end

function onStartClick(e)
    print("onStartClick")
end

function onBackClick(e)
    SceneManager:closeScene({animation = "fade"})
end