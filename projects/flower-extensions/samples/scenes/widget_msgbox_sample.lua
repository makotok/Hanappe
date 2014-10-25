module(..., package.seeall)

local message1 = "メッセージボックスのさんぷるです。\n内部的にはTextLabelが表示されています。\nHello MessageBox!\n改行も表示できます."

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

function onCreate(e)
    view = widget.UIView {
        scene = scene
    }
    
    showButton = widget.Button {
        size = {200, 50},
        pos = {5, 5},
        text = "Show",
        parent = view,
        onClick = showButton_OnClik,
    }
    
    hideButton = widget.Button {
        size = {200, 50},
        pos = {5, showButton:getBottom() + 5},
        text = "Hide",
        parent = view,
        onClick = hideButton_OnClik,
    }
    
    msgbox = widget.MsgBox {
        size = {flower.viewWidth - 10, 100},
        pos = {5, flower.viewHeight - 105},
        text = message1,
        parent = view,
    }
end

function showButton_OnClik(e)
    msgbox:showPopup()
end

function hideButton_OnClik(e)
    msgbox:hidePopup()
end