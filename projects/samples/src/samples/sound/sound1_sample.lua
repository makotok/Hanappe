module(..., package.seeall)

function onCreate(params)
    view = View {
        scene = scene
    }
    button1 = Button {
        parent = view,
        text = "play", 
        size = {200, 50},
        pos = {10, 10},
        onClick = button1_onClick,
    }
    
    sound = SoundManager:getSound("mono16.wav")
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
