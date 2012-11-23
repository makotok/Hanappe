module(..., package.seeall)

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

function onCreate(e)
end

function onOpen(e)
    flower.InputMgr:addEventListener("keyboard", onKeyboard)
    flower.InputMgr:addEventListener("touch", onTouch)
end

function onClose(e)
    flower.InputMgr:removeEventListener("keyboard", onKeyboard)
    flower.InputMgr:removeEventListener("touch", onTouch)
end

function onKeyboard(e)
    print("----- onKeyboard -----")
    print("down  = " .. tostring(e.down))
    print("key   = " .. e.key)
end

function onTouch(e)
    print("----- onTouch -----")
    print("idx      = " .. e.idx)
    print("tapCount = " .. e.tapCount)
    print("kind     = " .. e.kind)
    print("x        = " .. e.x)
    print("y        = " .. e.y)
end