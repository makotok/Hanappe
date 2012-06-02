module(..., package.seeall)

function onCreate(params)
    view = View()
    view:setScene(scene)
    
    radioGroup = RadioGroup()
    
    -- TODO:ラジオボタンのテキストが表示できません
    -- TODO:まだいまいちな感じがする
    button1 = RadioButton()
    button1:setPos(10, 10)
    button1:setRadioGroup(radioGroup)
    button1:addEventListener("click", onButtonClick)
    button1:addEventListener("cancel", onButtonCancel)
    view:addChild(button1)
    
    button2 = RadioButton()
    button2:setPos(button1:getRight() + 10, 10)
    button2:setRadioGroup(radioGroup)
    button2:addEventListener("click", onButtonClick)
    button2:addEventListener("cancel", onButtonCancel)
    view:addChild(button2)
    
    button3 = RadioButton()
    button3:setPos(button2:getRight() + 10, 10)
    button3:setRadioGroup(radioGroup)
    button3:addEventListener("click", onButtonClick)
    button3:addEventListener("cancel", onButtonCancel)
    view:addChild(button3)
    
    button3:setSelected(true)
    
end

function onButtonClick(e)
    print("onButtonClick")
end

function onButtonCancel(e)
    print("onButtonCancel")
end
