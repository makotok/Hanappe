module(..., package.seeall)

local listData = {
    {label = "label001", data = "data001"},
    {label = "label002", data = "data001"},
    {label = "label003", data = "data001"},
    {label = "label004", data = "data001"},
    {label = "label005", data = "data001"},
    {label = "label006", data = "data001"},
    {label = "label007", data = "data001"},
    {label = "label008", data = "data001"},
    {label = "label009", data = "data001"},
    {label = "label010", data = "data001"},
}

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

function onCreate(e)
    view = widget.UIView {
        scene = scene,
    }
    
    listBox1 = widget.ListBox {
        size = {300, 200},
        pos = {5, 5},
        parent = view,
        labelField = "label",
        listData = {listData},
    }
end
