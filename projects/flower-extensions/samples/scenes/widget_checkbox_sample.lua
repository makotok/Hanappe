module(..., package.seeall)

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

function onCreate(e)
    view = widget.UIView {
        scene = scene
    }
    
    checkbox1 = widget.CheckBox {
        pos = {50, closeButton:getBottom() + 10},
        size = {300, 40},
        parent = view,
        text = "メッセージ",
        checked = true,
    }

    checkbox2 = widget.CheckBox {
        pos = {50, checkbox1:getBottom() + 20},
        size = {146, 40},
        parent = view,
        --onDown = button1_OnDown,
        sheetImage = "skins/tp_image",
        checkedTexture = "checkbox_mark.png",
        backgroundTexture = "checkbox_bg.png",
        textSize = 20,
        textColor = {1, 1, 1, 1},
        text = "English",
        leftPadding = 46,
        checked = true,
    }
end

