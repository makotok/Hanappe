module(..., package.seeall)

function onCreate(params)
    view = View {
        scene = scene,
    }
    scroller = Scroller {
        parent = view,
        layout = VBoxLayout {
            align = {"center", "center"},
            padding = {10, 10, 10, 10},
            gap = {10, 10},
        },
    }
    for i = 1, 50 do
        Button {
            parent = scroller,
            text = "test" .. i,
        }
    end
end

function onDestroy()

end
