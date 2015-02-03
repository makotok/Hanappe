module(..., package.seeall)

local dataList = {}
for i = 1, 100 do
    table.insert(dataList, {label = "label" .. i, text = "text" .. i})
end


--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

function onCreate(e)
    listView = widget.ListView {
        size = {200, 300},
        pos = {50, 50},
        scene = scene,
        dataField = "label",
        dataList = {dataList},
    }
end
