module(..., package.seeall)

function onCreate(params)
    view = View()
    view:setScene(scene)

    button1 = Button {text = "play", width = 200, height = 50}
    button1:setPos(10, 10)
    button1:addEventListener("click", button1_onClick)
    view:addChild(button1)

    button2 = Button {text = "back", width = 200, height = 50}
    button2:setPos(10, button1:getBottom() + 10)
    button2:addEventListener("click", button2_onClick)
    view:addChild(button2)
    
    sound = SoundManager.getSound("samples/assets/mono16.wav")
end

function button1_onClick(e)
    if sound:isPlaying() then
        sound:stop()
        button1:setText("play")
    else
        sound:play()
        button1:setText("stop")
    end
end

function button2_onClick(e)
    sound:stop()
    SceneManager:closeScene()
end