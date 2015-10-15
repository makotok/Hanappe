---
-- Samples for ListView to display the header and footer.

module(..., package.seeall)

-- import
local table = require "flower.table"

local dataSource = {}
for i = 1, 100 do
    table.insert(dataSource, {label = "label" .. i, text = "text" .. i, image = "cathead.png", selected = (i % 3) == 0, sheetIndex = i})
end


--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

function onCreate(e)
    view = widget.UIView {
        scene = scene,
        layout = widget.BoxLayout {
            gap = {0, 0},
        },
        children = {{
            -- Body
            widget.ListView {
                name = "listView",
                size = {flower.viewWidth, flower.viewHeight - 50},
                dataSource = {dataSource},
                itemProperties = {{
                    labelField = "label",
                }},
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
                        text = "Add Data",
                        size = {flower.viewWidth / 2, 50},
                        onClick = function(e)
                            local listView = view:getChildByName("listView")
                            local item = listView:getSelectedItem()
                            local index = listView:getSelectedIndex()

                            if item then
                                local addItem = table.copy(item)
                                listView:addItem(addItem, index)
                            end
                        end,
                    },
                    widget.Button {
                        text = "Remove Data",
                        size = {flower.viewWidth / 2, 50},
                        onClick = function(e)
                            local listView = view:getChildByName("listView")
                            local item = listView:getSelectedItem()
                            if item then
                                listView:removeItem(item)
                            else
                                listView:removeItemAt(listView:getDataLength())
                            end
                        end,
                    },
                }},
            }
        }},
    }

end
