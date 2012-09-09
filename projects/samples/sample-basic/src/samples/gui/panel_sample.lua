module(..., package.seeall)

function onCreate(params)
    guiView = GUI.View {
        scene = scene,
        children = {{
            GUI.Panel {
                name = "panel",
                size = {300, 460},
                pos = {10, 10},
            },
        }},
    
    }
end

function onStart()
end

function onTouchDown(e)
    SceneManager:closeScene()
end