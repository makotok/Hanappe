module(..., package.seeall)

local listData = {}
for i = 1, 100 do
    table.insert(listData, {label = "label" .. i, text = "text" .. i})
end

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

function onCreate(e)
    view = widget.UIView {
        scene = scene,
    }
    
    listBox1 = widget.ListBox {
        width = 200,
        rowCount = 5,
        pos = {5, 5},
        parent = view,
        labelField = "label",
        listData = {listData},
        onItemChanged = listBox_OnItemChanged,
        onItemEnter = listBox_OnItemEnter,
    }
    
    textbox = widget.TextBox {
        size = {flower.viewWidth - 10, 100},
        pos = {5, flower.viewHeight - 105},
        parent = view,
    }
    
end

function listBox_OnItemChanged(e)
    print("listBox_OnItemChanged(e)")
    local data = e.data
    local text = data and data.text or ""
    textbox:setText(text)
end

function listBox_OnItemEnter(e)
    print("listBox_OnItemEnter(e)")
        
end
