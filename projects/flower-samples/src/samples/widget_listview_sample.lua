module(..., package.seeall)

local dataSource = {}
for i = 1, 100 do
    table.insert(dataSource, {label = "label" .. i, text = "text" .. i, image = "cathead.png"})
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
                dataField = "label",
                dataSource = {dataSource},
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
                dataField = "label",
                dataSource = {dataSource},
                itemRendererFactory = flower.ClassFactory(widget.ImageLabelItemRenderer, {
                    imageField = "image",
                    imageSize = {20, 20},
                }),
            },


        }},


    }

end
