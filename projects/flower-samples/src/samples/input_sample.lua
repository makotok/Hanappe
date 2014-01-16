module(..., package.seeall)

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
    flower.InputMgr:addEventListener("rightClick", onMouseButton)
    flower.InputMgr:addEventListener("middleClick", onMouseButton)
    flower.InputMgr:addEventListener("rightMove", onMouseMove)
    flower.InputMgr:addEventListener("middleMove", onMouseMove)
end

function onClose(e)
    flower.InputMgr:removeEventListener("keyDown", onKeyInput)
    flower.InputMgr:removeEventListener("keyUp", onKeyInput)
    flower.InputMgr:removeEventListener("touchDown", onTouch)
    flower.InputMgr:removeEventListener("touchUp", onTouch)
    flower.InputMgr:removeEventListener("touchMove", onTouch)
    flower.InputMgr:removeEventListener("touchCancel", onTouch)
    flower.InputMgr:removeEventListener("rightclick", onMouseButton)
    flower.InputMgr:removeEventListener("middleclick", onMouseButton)
    flower.InputMgr:removeEventListener("rightMove", onMouseMove)
    flower.InputMgr:removeEventListener("middleMove", onMouseMove)
end

function onKeyInput(e)
    print("----- onKeyInput -----")
    print("tupe  = " .. e.type)
    print("down  = " .. tostring(e.down))
    print("key   = " .. e.key)
end

function onTouch(e)
    print("----- onTouch -----")
    print("type     = " .. e.type)
    print("idx      = " .. e.idx)
    print("tapCount = " .. e.tapCount)
    print("x        = " .. e.x)
    print("y        = " .. e.y)
end

function onMouseButton(e)
    print("----- onMouseButton -----")
    print("type  = " .. e.type)
    print("down  = " .. tostring(e.down))
end

function onMouseMove(e)
    print("----- onMouseMove -----")
    print("type  = " .. e.type)
    print("down  = " .. tostring(e.down))
    print("x        = " .. e.x)
    print("y        = " .. e.y)
end
