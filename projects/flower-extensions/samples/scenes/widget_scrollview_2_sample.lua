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
        contents =  {{
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
    }
end
