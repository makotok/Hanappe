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
end

function onClose(e)
    flower.InputMgr:removeEventListener("keyDown", onKeyInput)
    flower.InputMgr:removeEventListener("keyUp", onKeyInput)
    flower.InputMgr:removeEventListener("touchDown", onTouch)
    flower.InputMgr:removeEventListener("touchUp", onTouch)
    flower.InputMgr:removeEventListener("touchMove", onTouch)
    flower.InputMgr:removeEventListener("touchCancel", onTouch)
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