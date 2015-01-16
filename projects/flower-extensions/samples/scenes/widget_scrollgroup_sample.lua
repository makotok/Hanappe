module(..., package.seeall)

local ScrollGroup = widget.ScrollGroup
local UIView = widget.UIView
local UIGroup = widget.UIGroup
local Button = widget.Button
local BoxLayout = widget.BoxLayout

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

function onCreate(e)
    view = UIView {
        scene = scene,
    }

    group = ScrollGroup {
        parent = view,
        scrollPolicy = {false, true},
        pos = {10, 10},
        size = {300, 300},
        layout = BoxLayout {
            gap = {5, 5},
            align = {"center", "top"},
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

    local background = group:getContentBackground()
    background:setPenColor(1, 1, 1, 1):fillRect()
end
