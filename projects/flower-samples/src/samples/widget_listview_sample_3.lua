---
-- Samples to display multiple lines of label in ListView.

module(..., package.seeall)

local dataSource = {}
for i = 1, 5 do
    table.insert(dataSource, {label = "label" .. i, text = "hello world" .. i})
end

for i = 1, 5 do
    table.insert(dataSource, {label = "label" .. i, text = "ああああああああああああああああああああああああああああ" .. i})
end

for i = 1, 5 do
    table.insert(dataSource, {label = "label" .. i, text = "aaaa\nbbbb\ncccc" .. i})
end


--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

function onCreate(e)
    widget.ListView {
        scene = scene,
        dataSource = {dataSource},
        backgroundVisible = true,
        itemProperties = {{
            labelField = "text",
            -- In LabelItemRenderer, it is set if you want to multi-line display.
            lineBreak = true,
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
    }


end
