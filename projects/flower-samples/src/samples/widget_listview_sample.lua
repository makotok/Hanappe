module(..., package.seeall)

local dataSource = {}
for i = 1, 100 do
    table.insert(dataSource, {label = "label" .. i, text = "text" .. i})
end


--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

function onCreate(e)
    widget.ListView {
        size = {flower.viewWidth - 10, flower.viewHeight - 100},
        pos = {5, 5},
        dataField = "label",
        dataSource = {dataSource},
        scene = scene,
    }
end
