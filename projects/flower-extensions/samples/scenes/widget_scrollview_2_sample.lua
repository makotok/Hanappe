module(..., package.seeall)

local ScrollView = widget.ScrollView
local UIGroup = widget.UIGroup
local Button = widget.Button
local BoxLayout = widget.BoxLayout

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

function onCreate(e)
    view = ScrollView {
        scene = scene,
        layout = BoxLayout {
            gap = {5, 5},
            align = {"right", "top"},
        },
        scrollGroup = UIGroup {
            layout = BoxLayout {
                gap = {2, 2},
                padding = {2, 2, 2, 2},
                direction = "vertical",
            },
            children = {{
                Button {
                    size = {600, 200},
                    text = "Test1",
                },
                Button {
                    size = {600, 200},
                    text = "Test2",
                },
                Button {
                    size = {600, 200},
                    text = "Test3",
                },
                Button {
                    size = {600, 200},
                    text = "Test4",
                },
                Button {
                    size = {600, 200},
                    text = "Test5",
                },
            }},
        },
    }
end
