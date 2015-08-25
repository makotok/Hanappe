module(..., package.seeall)

local dataSource = {}
for i = 1, 100 do
    table.insert(dataSource, {label = "label" .. i, rowHeight = 35 + (i % 20 * 4)})
end

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

function onCreate(e)
    widget.ListView {
        scene = scene,
        dataSource = {dataSource},
        backgroundVisible = false,
        itemProperties = {{
            labelField = "label",
            rowHeightField = "rowHeight",
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
