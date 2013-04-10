module(..., package.seeall)

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

function onCreate(e)
    view = widget.UIView {
        scene = scene,
    }
    
    textbox1 = widget.TextBox {
        size = {flower.viewWidth - 10, 100},
        pos = {5, 5},
        text = "こんにちは、ウィジェットの世界へ！\nHello World!",
        parent = view,
    }

    textbox2 = widget.TextBox()
    textbox2:setSize(flower.viewWidth - 10, 100)
    textbox2:setPivToCenter()
    textbox2:setPos(5, textbox1:getBottom() + 5)
    textbox2:setText("こんにちは、ウィジェットの世界へ！\nHello World!\nあいうえおかきくけこさしすせそたちつてと")
    textbox2:setTextSize(16)
    textbox2:setParent(view)
    
end

