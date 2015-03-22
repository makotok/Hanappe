module(..., package.seeall)

local dataSource = {}
for i = 1, 100 do
    table.insert(dataSource, {label = "label" .. i, text = "text" .. i, image = "cathead.png", selected = (i % 3) == 0, sheetIndex = i})
end


--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

function onCreate(e)
    widget.UIView {
        scene = scene,
        layout = widget.BoxLayout {
            gap = {0, 0},
        },
        children = {{
            -- Header
            widget.UIGroup {
                layout = widget.BoxLayout {
                    align = {"left", "top"},
                    direction = "horizontal",
                    padding = {0, 0, 0, 0},
                    gap = {0, 0},
                },
                size = {flower.viewWidth, 50},
                children = {{
                    widget.Button {
                        text = "Back",
                        size = {80, 50},
                    },
                    widget.Spacer {
                        size = {flower.viewWidth - 160, 50},
                    },
                    widget.Button {
                        text = "Next",
                        size = {80, 50},
                    },
                }},
            },
            -- Body
            widget.ListView {
                size = {flower.viewWidth, flower.viewHeight - 100},
                dataSource = {dataSource},
                backgroundVisible = false,
                itemProperties = {{
                    labelField = "label",
                }},
                onSelectedChanged = function(e)
                    print("onSelectedChanged")
                    if e.target:getSelectedItem() then
                        print("selectedItem:" .. e.target:getSelectedItem().label)
                    end
                end,
                onItemClick = function(e)
                    print("onItemClick", e.data.label)
                end,
            },
            -- Footer
            widget.UIGroup {
                layout = widget.BoxLayout {
                    align = {"left", "center"},
                    direction = "horizontal",
                    padding = {0, 0, 0, 0},
                    gap = {0, 0},
                },
                size = {flower.viewWidth, 50},
                children = {{
                    widget.Button {
                        text = "Button",
                        size = {flower.viewWidth / 4, 50},
                    },
                    widget.Button {
                        text = "Button",
                        size = {flower.viewWidth / 4, 50},
                    },
                    widget.Button {
                        text = "Button",
                        size = {flower.viewWidth / 4, 50},
                    },
                    widget.Button {
                        text = "Button",
                        size = {flower.viewWidth / 4, 50},
                    },
                }},
            }
        }},
    }

end
