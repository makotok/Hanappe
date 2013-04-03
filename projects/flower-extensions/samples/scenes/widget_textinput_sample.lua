module(..., package.seeall)

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

function onCreate(e)
    view = widget.UIView {
        scene = scene,
    }
    
    textInput1 = widget.TextInput {
        size = {200, 50},
        pos = {5, 5},
        parent = view,
    }

    textInput2 = widget.TextInput {
        size = {200, 50},
        pos = {5, textInput1:getBottom() + 5},
        parent = view,
    }
end
