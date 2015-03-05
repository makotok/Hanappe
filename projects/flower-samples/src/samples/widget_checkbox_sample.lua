module(..., package.seeall)

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

function onCreate(e)
    view = widget.UIView {
        scene = scene,
        layout = widget.BoxLayout {
            gap = {5, 5},
        },
    }
    
    checkbox1 = widget.CheckBox {
        pos = {50, closeButton:getBottom() + 10},
        size = {300, 40},
        parent = view,
        text = "メッセージ",
        selected = true,
        onSelectedChanged = function(e)
            print("checkbox1 selected changed:", e.target:isSelected())
        end,
    }

    checkbox2 = widget.CheckBox {
        pos = {50, checkbox1:getBottom() + 20},
        size = {146, 40},
        parent = view,
        text = "English",
        selected = true,
        onSelectedChanged = function(e)
            print("checkbox2 selected changed:", e.data)
        end,
    }
end
