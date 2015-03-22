module(..., package.seeall)

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

function onCreate(e)
    view = widget.UIView {
        scene = scene
    }
    
    playButton = widget.Button {
        size = {200, 50},
        pos = {50, 10},
        text = "Play",
        parent = view,
        onClick = playButton_OnClick,
    }

    pauseButton = widget.Button {
        size = {200, 50},
        pos = {50, playButton:getBottom() + 10},
        text = "Pause",
        parent = view,
        onClick = pauseButton_OnClick,
    }

    stopButton = widget.Button {
        size = {200, 50},
        pos = {50, pauseButton:getBottom() + 10},
        text = "Stop",
        parent = view,
        onClick = stopButton_OnClick,
    }
end


function playButton_OnClick()
    local sound = audio.play("sample_sound.wav")
end

function pauseButton_OnClick()
    audio.pause("sample_sound.wav")
end

function stopButton_OnClick()
    audio.stop("sample_sound.wav")
end