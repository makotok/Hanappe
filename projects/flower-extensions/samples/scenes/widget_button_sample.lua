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
        text = "Test1",
        parent = view,
        onClick = button1_OnClick,
        onDown = button1_OnDown,
        onUp = button1_OnUp,
    }
    
    button2 = widget.Button()
    button2:setSize(200, 50)
    button2:setPivToCenter()
    button2:setPos(50, button1:getBottom() + 10)
    button2:setText("Test2")
    button2:setTextSize(24)
    button2:setOnClick(button2_OnClick)
    button2:setParent(view)
    
    button3 = widget.Button {
        size = {200, 50},
        pos = {50, button2:getBottom() + 10},
        text = "Test3",
        parent = view,
        onClick = button3_OnClick,
    }

    closeButton = widget.ImageButton {
        pos = {50, button3:getBottom() + 10},
        parent = view,
        sheetImage = "skins/tp_image",
        normalTexture = "gb-up.png",
        selectedTexture = "gb-down.png",
        disabledTexture = "gb-up.png",
        --onClick = button3_OnClick,
    }

    local checkbox1 = widget.CheckBox {
        pos = {50, closeButton:getBottom() + 10},
        size = {300, 40},
        parent = view,
        --onDown = button1_OnDown,
        sheetImage = "skins/tp_image",
        checkedTexture = "checkbox_mark.png",
        backgroundTexture = "checkbox_bg.png",
        textSize = 20,
        textColor = {1, 1, 1, 1},
        text = "メッセージ",
        leftPadding = 46,
        checked = true,
    }

    local checkbox2 = widget.CheckBox {
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

    local slider1 = widget.Slider { -- test Slider
        size = {200, 36},
        pos = {50, checkbox2:getBottom() + 20},
        backgroundTexture = "skins/slider_background.png",
        progressTexture = "skins/slider_progress.png",
        thumbTexture = "skins/slider_thumb.png",
        parent = view,
    }
    
    -- event listeners
    button1:addEventListener("focusIn", button1_OnFocusIn)
    button1:addEventListener("focusOut", button1_OnFocusOut)
end

function button1_OnClick(e)
    print("button1_OnClick!")

    -- test size
    button1:setSize(150, 50)
    button2:setSize(250, 50)
    button1:setPivToCenter()
    button2:setPivToCenter()

    -- test textSize
    button1:setTextSize(16)
    button2:setTextSize(22)
end

function button1_OnDown(e)
    print("button1_OnDown!")
end

function button1_OnUp(e)
    print("button1_OnUp!")
end

function button1_OnFocusIn(e)
    print("button1_OnFocusIn!")
end

function button1_OnFocusOut(e)
    print("button1_OnFocusOut!")
end

function button2_OnClick(e)
    print("button2_OnClick!")
    if coroutineAction then
        return
    end

    coroutineAction = flower.callOnce(function()
        -- test loc
        MOAICoroutine.blockOnAction(button1:moveLoc(100, 100, 0, 1))
        MOAICoroutine.blockOnAction(button1:moveLoc(-100, -100, 0, 1))
    
        -- test scl
        MOAICoroutine.blockOnAction(button1:moveScl(1, 1, 0, 1))
        MOAICoroutine.blockOnAction(button1:seekScl(1, 1, 1, 1))
    
        -- test rot
        MOAICoroutine.blockOnAction(button1:moveRot(0, 0, 180, 1))
        MOAICoroutine.blockOnAction(button1:seekRot(0, 0, 0, 1))
        
        -- test color
        MOAICoroutine.blockOnAction(button1:moveColor(-1, -1, -1, -1, 1))
        MOAICoroutine.blockOnAction(button1:moveColor(1, 1, 1, 1, 1))
        
        coroutineAction = nil
    end)
end

function button3_OnClick(e)
    flower.closeScene({animation = "fade"})
end
