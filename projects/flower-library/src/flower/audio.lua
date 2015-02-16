----------------------------------------------------------------------------------------------------
-- Audio library.
-- This allows the change of the flexible implementation.
-- 
-- @author Makoto
-- @release V3.0.0
----------------------------------------------------------------------------------------------------

-- module
local audio = {}

----------------------------------------------------------------------------------------------------
-- Fields
----------------------------------------------------------------------------------------------------

--- SoundMgr
audio.soundMgr = nil

----------------------------------------------------------------------------------------------------
-- Functions
----------------------------------------------------------------------------------------------------

---
-- Initializes the module.
-- @param soundMgr (option) soundMgr object.
function audio.init(soundMgr)
    if not audio.soundMgr then
        if soundMgr then
            audio.soundMgr = soundMgr
        elseif MOAIUntzSystem then
            audio.soundMgr = audio.UntzSoundMgr()
        else
            audio.soundMgr = audio.MockSoundMgr()
        end
    end
end

---
-- Play the sound.
-- @param sound file path or object.
-- @param volume (Optional)volume. Default value is 1.
-- @param looping (Optional)looping flag. Default value is 'false'.
-- @return Sound object
function audio.play(sound, volume, looping)
    return audio.soundMgr:play(sound, volume, looping)
end

---
-- Pause the sound.
-- @param sound file path or object.
function audio.pause(sound)
    audio.soundMgr:pause(sound)
end

---
-- Stop the sound.
-- @param sound file path or object.
function audio.stop(sound)
    audio.soundMgr:stop(sound)
end

---
-- Set the system level volume.
-- @param volume volume(0 <= volume <= 1)
function audio.setVolume(volume)
    audio.soundMgr:setVolume(volume)
end

---
-- Return the system level volume.
-- @return volume
function audio.getVolume(volume)
    audio.soundMgr:getVolume()
end

---
-- Return SoundMgr a singleton.
-- @return soundMgr
function audio.getSoundMgr()
    return audio.soundMgr
end

----------------------------------------------------------------------------------------------------
-- Classes
-- @section Classes
----------------------------------------------------------------------------------------------------

---
-- BaseSoundMgr Class.
-- @see flower.audio.BaseSoundMgr
audio.BaseSoundMgr = require "flower.audio.BaseSoundMgr"

---
-- UntzSoundMgr Class.
-- @see flower.audio.UntzSoundMgr
audio.UntzSoundMgr = require "flower.audio.UntzSoundMgr"

---
-- MockSoundMgr Class.
-- @see flower.audio.MockSoundMgr
audio.MockSoundMgr = require "flower.audio.MockSoundMgr"

return audio