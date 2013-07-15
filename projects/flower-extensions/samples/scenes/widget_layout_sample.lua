module(..., package.seeall)

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
        layout = BoxLayout {
            gap = {5, 5},
            align = {"right", "center"},
        },
        children = {{
            Button {
                size = {200, 50},
                text = "Test1",
            },
            Button {
                size = {100, 50},
                text = "Test2",
            },
            Button {
                size = {100, 50},
                text = "Test3",
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
                        text = "Test5",
                    },
                    Button {
                        size = {100, 50},
                        text = "Test6",
                    },
                }},
            },
        }},
    }
    
    view:updateLayout()
end
