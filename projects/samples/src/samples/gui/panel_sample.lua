module(..., package.seeall)

function onCreate(params)
    view = View {
        scene = scene,
    }

    panel = Panel {
        name = "panel",
        size = {460, 300},
        pos = {10, 10},
        parent = view,
    }

end

function onStart()
end

function onTouchDown(e)
    SceneManager:closeScene()
end