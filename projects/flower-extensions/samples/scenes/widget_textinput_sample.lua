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

    textInput2 = widget.TextInput()
    textInput2:setPos(5, textInput1:getBottom() + 5)
    textInput2:setSize(200, 50)
    --textInput2:updateDisplay()
    textInput2:setText("Hello")
    textInput2:setParent(view)

    -- event listeners
    textInput1:addEventListener("focusIn", textInput_OnFocusIn)
    textInput1:addEventListener("focusOut", textInput_OnFocusOut)
    textInput2:addEventListener("focusIn", textInput_OnFocusIn)
    textInput2:addEventListener("focusOut", textInput_OnFocusOut)
end

function textInput_OnFocusIn(e)
    print("FocusIn!")
end

function textInput_OnFocusOut(e)
    print("FocusOut!")
end
