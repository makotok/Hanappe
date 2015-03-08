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
        layout = widget.BoxLayout {},
        children = {{
            widget.ListView {
                size = {flower.viewWidth, flower.viewHeight / 4},
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
                size = {flower.viewWidth, flower.viewHeight / 4},
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
                size = {flower.viewWidth, flower.viewHeight / 4},
                dataSource = {dataSource},
                columnCount = 2,
                itemRendererClass = widget.SheetImageLabelItemRenderer,
                itemProperties = {{
                    labelField = "label",
                    sheetIndexField = "sheetIndex",
                }},
            },
            widget.ListView {
                size = {flower.viewWidth, flower.viewHeight / 4},
                dataSource = {dataSource},
                itemRendererClass = widget.CheckBoxItemRenderer,
                itemProperties = {{
                    labelField = "label",
                    selectedField = "selected",
                }},
                onItemClick = function(e)
                    local itemNames = ""
                    for i, item in ipairs(dataSource) do
                        if item.selected then
                            itemNames = itemNames .. item.label .. ","
                        end
                    end
                    print("Selected " .. itemNames)
                end,
            },
        }},


    }

end
