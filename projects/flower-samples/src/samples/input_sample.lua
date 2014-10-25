module(..., package.seeall)

local KeyCode = flower.KeyCode

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

function onCreate(e)
end

function onOpen(e)
    flower.InputMgr:addEventListener("keyDown", onKeyInput)
    flower.InputMgr:addEventListener("keyUp", onKeyInput)
    flower.InputMgr:addEventListener("touchDown", onTouch)
    flower.InputMgr:addEventListener("touchUp", onTouch)
    flower.InputMgr:addEventListener("touchMove", onTouch)
    flower.InputMgr:addEventListener("touchCancel", onTouch)
    flower.InputMgr:addEventListener("mouseClick", onMouseClick)
    flower.InputMgr:addEventListener("mouseRightClick", onMouseClick)
    flower.InputMgr:addEventListener("mouseMiddleClick", onMouseClick)
    flower.InputMgr:addEventListener("mouseMove", onMouseMove)
end

function onClose(e)
    flower.InputMgr:removeEventListener("keyDown", onKeyInput)
    flower.InputMgr:removeEventListener("keyUp", onKeyInput)
    flower.InputMgr:removeEventListener("touchDown", onTouch)
    flower.InputMgr:removeEventListener("touchUp", onTouch)
    flower.InputMgr:removeEventListener("touchMove", onTouch)
    flower.InputMgr:removeEventListener("touchCancel", onTouch)
    flower.InputMgr:removeEventListener("mouseClick", onMouseClick)
    flower.InputMgr:removeEventListener("mouseRightClick", onMouseClick)
    flower.InputMgr:removeEventListener("mouseMiddleClick", onMouseClick)
    flower.InputMgr:removeEventListener("mouseMove", onMouseMove)
end

function onKeyInput(e)
    print("----- onKeyInput -----")
    print("tupe  = " .. e.type)
    print("down  = " .. tostring(e.down))
    print("key   = " .. e.key)

    if KeyCode.isShiftKey(e.key) then
        print("Shift key pressed")
    end
    if KeyCode.isCtrlKey(e.key) then
        print("Ctrl key pressed")
    end
    if KeyCode.isAltKey(e.key) then
        print("Alt key pressed")
    end
end

function onTouch(e)
    print("----- onTouch -----")
    print("type     = " .. e.type)
    print("idx      = " .. e.idx)
    print("tapCount = " .. e.tapCount)
    print("x        = " .. e.x)
    print("y        = " .. e.y)
end

function onMouseClick(e)
    print("----- onMouseClick -----")
    print("type  = " .. e.type)
    print("down  = " .. tostring(e.down))
    print("x     = " .. e.x)
    print("y     = " .. e.y)
end

function onMouseMove(e)
    print("----- onMouseMove -----")
    print("type  = " .. e.type)
    print("down  = " .. tostring(e.down))
    print("x     = " .. e.x)
    print("y     = " .. e.y)
end
