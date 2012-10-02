module(..., package.seeall)

function onCreate(params)
    view = View {
        scene = scene,
    }
    scroller = Scroller {
        parent = view,
        size = {view:getSize()},
        layout = {
            VBoxLayout {
                align = {"center", "center"},
                padding = {10, 10, 10, 10},
                gap = {10, 10},
            }
        },
    }
    Button {
        parent = scroller,
        text = "Back",
        onClick = onBackClick,
    }
    for i = 1, 50 do
        Button {
            parent = scroller,
            text = "test" .. i,
        }
    end

end

function onBackClick(e)
    SceneManager:closeScene({animation = "fade"})
end