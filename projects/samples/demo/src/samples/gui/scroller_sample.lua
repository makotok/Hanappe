module(..., package.seeall)

function onCreate(params)
    view = View {
        scene = scene,
    }
    scroller = Scroller {
        parent = view,
        layout = {VBoxLayout {hAlign = "right", vAlign = "bottom"}},
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