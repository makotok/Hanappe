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

    textbox2 = widget.TextBox {
        size = {flower.viewWidth - 10, 100},
        pos = {5, textbox1:getBottom() + 5},
        text = "こんにちは、ウィジェットの世界へ！\nHello World!",
        textSize = 16,
        parent = view,
    }
end
