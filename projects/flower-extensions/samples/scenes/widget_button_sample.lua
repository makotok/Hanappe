module(..., package.seeall)

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

function onCreate(e)
    view = widget.UIView {
        scene = scene
    }
    
    button1 = widget.Button {
        size = {200, 50},
        pos = {50, 50},
        text = "Hello",
        parent = view,
        onClick = button_OnClick,
        onDown = button_OnDown,
        onUp = button_OnUp,
    }
    
    button2 = widget.Button {
        size = {200, 50},
        pos = {50, 120},
        text = "World",
        parent = view,
        onClick = button_OnClick,
        onDown = button_OnDown,
        onUp = button_OnUp,
    }
    
    -- event listeners
    button1:addEventListener("focusIn", button_OnFocusIn)
    button1:addEventListener("focusOut", button_OnFocusOut)
    button2:addEventListener("focusIn", button_OnFocusIn)
    button2:addEventListener("focusOut", button_OnFocusOut)
end

function button_OnFocusIn(e)
    print("FocusIn!")
end

function button_OnFocusOut(e)
    print("FocusOut!")
end

function button_OnClick(e)
    print("Click!")
end

function button_OnDown(e)
    print("Down!")
end

function button_OnUp(e)
    print("Up!")
end