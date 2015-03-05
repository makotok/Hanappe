module(..., package.seeall)

local dataSource = {}
for i = 1, 100 do
    table.insert(dataSource, {label = "label" .. i, text = "text" .. i, image = "cathead.png", selected = (i % 3) == 0})
end


--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

function onCreate(e)
    widget.UIView {
        scene = scene,
        layout = widget.BoxLayout {},
        children = {{
            widget.ListView {
                size = {320, 150},
                pos = {5, 5},
                dataSource = {dataSource},
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
            widget.ListView {
                size = {320, 150},
                pos = {5, 5},
                dataSource = {dataSource},
                columnCount = 2,
                itemRendererClass = widget.ImageLabelItemRenderer,
                itemProperties = {{
                    labelField = "label",
                    imageField = "image",
                    imageSize = {20, 20},                    
                }},
            },
            widget.ListView {
                size = {320, 150},
                pos = {5, 5},
                dataSource = {dataSource},
                itemRendererClass = widget.CheckBoxItemRenderer,
                itemProperties = {{
                    labelField = "label",
                    selectedField = "selected",
                }},
            },
        }},


    }

end
