module(..., package.seeall)

function onCreate(params)
    view = View()
    view:setScene(scene)
    
    button1 = Button({
        upSkin = "samples/assets/button_a.png",
        downSkin = "samples/assets/button_a.png",
        upColor = {red = 1, green = 1, blue = 1, alpha = 1},
        downColor = {red = 0.5, green = 0.5, blue = 0.5, alpha = 1},
    })
    button1:addEventListener("buttonDown", onButtonTouchDown)
    button1:addEventListener("buttonUp", onButtonTouchUp)
    button1:addEventListener("click", onButtonClick)
    button1:addEventListener("cancel", onButtonCancel)
    view:addChild(button1)
    
    button2 = Button({
        upSkin = "samples/assets/button_a.png",
        downSkin = "samples/assets/button_a.png",
        upColor = {red = 1, green = 1, blue = 1, alpha = 1},
        downColor = {red = 0.5, green = 0.5, blue = 0.5, alpha = 1},
        toggle = true
    })
    button2:setLeft(button1:getRight())
    button2:addEventListener("buttonDown", onButtonTouchDown)
    button2:addEventListener("buttonUp", onButtonTouchUp)
    button2:addEventListener("click", onButtonClick)
    button2:addEventListener("cancel", onButtonCancel)
    view:addChild(button2)
    
    button3 = Button({
        upSkin = "samples/assets/btn_up.png",
        downSkin = "samples/assets/btn_down.png",
        text = "ハローボタン"
    })
    button3:setSize(200, 50)
    button3:setLeft(0)
    button3:setTop(button1:getBottom())
    button3:addEventListener("buttonDown", onButtonTouchDown)
    button3:addEventListener("buttonUp", onButtonTouchUp)
    button3:addEventListener("click", onButtonClick)
    button3:addEventListener("cancel", onButtonCancel)
    view:addChild(button3)

    button4 = Button()
    button4:setSize(200, 50)
    button4:setLeft(0)
    button4:setText("default theme")
    button4:setTextSize(20)
    button4:setTop(button3:getBottom() + 10)
    button4:addEventListener("buttonDown", onButtonTouchDown)
    button4:addEventListener("buttonUp", onButtonTouchUp)
    button4:addEventListener("click", onButtonClick)
    button4:addEventListener("cancel", onButtonCancel)
    view:addChild(button4)
    
end

function onButtonTouchDown(e)
    print("onButtonTouchDown")
end

function onButtonTouchUp(e)
    print("onButtonTouchUp")
end

function onButtonClick(e)
    print("onButtonClick")
end

function onButtonCancel(e)
    print("onButtonCancel")
end
