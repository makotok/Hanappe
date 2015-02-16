module(..., package.seeall)

local ScrollView = widget.ScrollView
local UIGroup = widget.UIGroup
local Button = widget.Button
local BoxLayout = widget.BoxLayout

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

function onCreate(e)
    viewGroup = widget.UIView {
        scene = scene,
        layout = BoxLayout {
            align = {"center", "top"},
            gap = {5, 5},
        },
        children = {{
            ScrollView {
                size = {300, 200},
                layout = BoxLayout {
                    gap = {5, 5},
                },
                contents =  {{
                    Button {
                        size = {100, 50},
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
                    Button {
                        size = {100, 50},
                        text = "Test4",
                    },
                    Button {
                        size = {100, 50},
                        text = "Test5",
                    },
                }},
            },
            ScrollView {
                size = {300, 200},
                scrollPolicy = {false, true},
                layout = BoxLayout {
                    gap = {5, 5},
                    align = {"right", "top"},
                },
                contents =  {{
                    Button {
                        size = {100, 50},
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
                    Button {
                        size = {100, 50},
                        text = "Test4",
                    },
                    Button {
                        size = {100, 50},
                        text = "Test5",
                    },
                }},
            },
        }},
    }
end
