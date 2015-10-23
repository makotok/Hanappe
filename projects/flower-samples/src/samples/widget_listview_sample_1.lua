---
-- The basic sample for the ListView.

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
            -- Generate ListView
            -- Samples for LabelItemRenderer.
            widget.ListView {
                -- Set if you want to explicitly set the size.
                size = {flower.viewWidth, flower.viewHeight / 4},
                -- Set the data table to be displayed.
                dataSource = {dataSource},
                -- Set the property to pass to the ItemRenderer object.
                itemProperties = {{
                    -- Set the label fields to be displayed.
                    labelField = "label",
                }},
                -- Set the function to be called when the selected row is changed.
                onSelectedChanged = function(e)
                    print("onSelectedChanged")
                    if e.target:getSelectedItem() then
                        print("selectedItem:" .. e.target:getSelectedItem().label)
                    end
                end,
                -- Set a function to be called when the item is clicked.
                onItemClick = function(e)
                    print("onItemClick", e.data.label)
                end,
                -- Set a function to be called when the item is clicked.
                onItemEnter = function(e)
                    print("onItemEnter", e.data.label)
                end,
            },
            -- Samples for ImageLabelItemRenderer.
            widget.ListView {
                -- Set if you want to explicitly set the size.
                size = {flower.viewWidth, flower.viewHeight / 4},
                -- Set the data table to be displayed.
                dataSource = {dataSource},
                -- Set if you want to multi-column display.
                columnCount = 2,
                -- Set to if you want to generate a special ItemRenderer.
                itemRendererClass = widget.ImageLabelItemRenderer,
                -- Set the property to pass to the ItemRenderer object.
                itemProperties = {{
                    -- Set the label fields to be displayed.
                    labelField = "label",
                    -- Set the function to convert the label.
                    labelFunction = function(label)
                        return "I_" .. label
                    end,
                    -- Set the image field.
                    imageField = "image",
                    -- Set the image size.
                    imageSize = {20, 20},
                }},
            },
            -- Samples for SheetImageLabelItemRenderer.
            widget.ListView {
                -- Set if you want to explicitly set the size.
                size = {flower.viewWidth, flower.viewHeight / 4},
                -- Set the data table to be displayed.
                dataSource = {dataSource},
                -- Set if you want to multi-column display.
                columnCount = 2,
                -- Set to if you want to generate a special ItemRenderer.
                itemRendererClass = widget.SheetImageLabelItemRenderer,
                -- Set the property to pass to the ItemRenderer object.
                itemProperties = {{
                    -- Set the label field to be displayed.
                    labelField = "label",
                    -- Set the index field of the sheet.
                    sheetIndexField = "sheetIndex",
                }},
            },
            -- Samples for CheckBoxItemRenderer.
            widget.ListView {
                -- Set if you want to explicitly set the size.
                size = {flower.viewWidth, flower.viewHeight / 4},
                -- Set the data table to be displayed.
                dataSource = {dataSource},
                -- Set to if you want to generate a special ItemRenderer.
                itemRendererClass = widget.CheckBoxItemRenderer,
                -- Set the property to pass to the ItemRenderer object.
                itemProperties = {{
                    -- Set the label field to be displayed.
                    labelField = "label",
                    -- Set the selected field to be displayed.
                    selectedField = "selected",
                }},
                -- Set a function to be called when the item is clicked.
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
