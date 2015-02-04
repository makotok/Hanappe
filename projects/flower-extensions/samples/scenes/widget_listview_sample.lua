module(..., package.seeall)

local dataSource = {}
for i = 1, 100 do
    table.insert(dataSource, {label = "label" .. i, text = "text" .. i})
end


--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

function onCreate(e)
    viewGroup = widget.UIView {
        scene = scene,
        layout = widget.BoxLayout {
            gap = {5, 5},
        },
        children = {{
            widget.ListView {
                size = {flower.viewWidth, flower.viewHeight / 2 - 5},
                dataField = "label",
                dataSource = {dataSource},
            },
            widget.ListView {
                size = {flower.viewWidth, flower.viewHeight / 2 - 5},
                dataField = "label",
                dataSource = {dataSource},
                backgroundVisible = false,
            },
        }},
    }
end
