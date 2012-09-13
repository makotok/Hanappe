module(..., package.seeall)

local SCREEN_WIDTH      = Application.screenWidth
local SCREEN_HEIGHT     = Application.screenHeight

function onCreate(params)

   guiView = GUI.ViewGroup {
        scene = scene,
        --layout = {GUI.VBoxLayout {pTop = 0, pLeft = 0, pBottom = 0, pRight = 0, vGap = 0}},
        children = {{
            --[[
            GUI.View {
                size = {SCREEN_WIDTH, SCREEN_HEIGHT - 100},
                layout = {GUI.VBoxLayout {}},
                children = {{
                    GUI.Button {text = "test button"},
                    GUI.Button {text = "test button"},
                    GUI.Button {text = "test button"},
                    GUI.Button {text = "test button"},
                    GUI.Button {text = "test button"},
                    GUI.Button {text = "test button"},
                }},
            },
            --]]
            GUI.View {
                --size = {SCREEN_WIDTH, 100},
                pos = {0, -50},
                children = {{
                    GUI.Panel {size = {100, 100}},
                    GUI.Button {text = "bottom button"},
                }},
            },
        }},
    
    }
end

function onStart()
end

function onTouchDown(e)
    SceneManager:closeScene()
end