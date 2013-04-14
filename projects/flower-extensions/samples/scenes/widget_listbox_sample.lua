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
    
    listBox2 = widget.ListBox()
    listBox2:setWidth(200)
    listBox2:setRowCount(5)
    listBox2:setColumnCount(2)
    listBox2:setPos(5, listBox1:getBottom() + 5)
    listBox2:setLabelField("label")
    listBox2:setListData(listData)
    listBox2:setParent(view)
    listBox2:setOnItemChanged(listBox_OnItemChanged)
    listBox2:setOnItemEnter(listBox_OnItemEnter)
    
    textbox = widget.TextBox {
        size = {flower.viewWidth - 10, 100},
        pos = {5, flower.viewHeight - 105},
        parent = view,
    }
    
    enabledButton = widget.Button {
        size = {100, 50},
        pos = {210, 50},
        text = "Enable",
        parent = view,
        onClick = enabledButton_OnClick,
    }
    
    disabledButton = widget.Button {
        size = {100, 50},
        pos = {210, enabledButton:getBottom()},
        text = "Disable",
        parent = view,
        onClick = disabledButton_OnClick,
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

function enabledButton_OnClick(e)
    print("enabledButton_OnClick(e)")
    listBox1:setEnabled(true)
    listBox2:setEnabled(true)
end

function disabledButton_OnClick(e)
    print("disabledButton_OnClick(e)")
    listBox1:setEnabled(false)
    listBox2:setEnabled(false)
end
