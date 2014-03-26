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
        scrollPolicy = {false, true},
        layout = BoxLayout {
            gap = {5, 5},
            align = {"right", "top"},
        },
        contents = {{
            Button {
                size = {200, 50},
                text = "Test1",
                onClick = function(e)
                    print("Hello!!!")
                end,
            },
            Button {
                size = {100, 50},
                text = "Test2",
                onClick = function(e)
                    print("World!!!")
                end,
            },
            Button {
                size = {100, 50},
                text = "Test3",
                onClick = function(e)
                    print("Layout!!")
                end,
            },
            Button {
                size = {100, 300},
                text = "Test4",
                onClick = function(e)
                    print("Layout!!")
                end,
            },
            Button {
                size = {100, 300},
                text = "Test5",
                onClick = function(e)
                    print("Layout!!")
                end,
            },
            UIGroup {
                layout = BoxLayout {
                    gap = {5, 5},
                    padding = {10, 10, 10, 10},
                    direction = "horizotal",
                },
                children = {{
                    Button {
                        size = {120, 70},
                        text = "Test11",
                    },
                    Button {
                        size = {100, 50},
                        text = "Test12",
                    },
                }},
            },
        }},
    }
end
