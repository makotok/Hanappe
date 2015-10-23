---
-- Sample to set the height for each row in the ListView.

module(..., package.seeall)

local dataSource = {}
for i = 1, 100 do
    table.insert(dataSource, {label = "label" .. i})
end

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

function onCreate(e)
    rootView = widget.UIView {
        scene = scene,
        layout = widget.BoxLayout {},
    }

    rootView:addChild(widget.ListView {
        dataSource = {dataSource},
        backgroundVisible = true,
        rowCount = 5,
        itemProperties = {{
            labelField = "label",
        }},
    })

    rootView:addChild(widget.ListView {
        scene = scene,
        dataSource = {dataSource},
        backgroundVisible = false,
        scrollEnabled = false,
        rowHeight = 30,
        rowCount = 4,
        columnCount = 2,
        itemProperties = {{
            labelField = "label",
        }},
    })
end
