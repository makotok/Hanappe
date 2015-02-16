----------------------------------------------------------------------------------------------------
-- This is UntzSoundMgr class using MOAIUntz.
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.lang.class"
local Resources = require "flower.core.Resources"
local BaseSoundMgr = require "flower.audio.BaseSoundMgr"

-- class
local UntzSoundMgr = class(BaseSoundMgr)

--- sampleRate
UntzSoundMgr.SAMPLE_RATE = nil

--- numFrames
UntzSoundMgr.NUM_FRAMES = nil

---
-- Constructor.
-- @param sampleRate sample rate
-- @param numFrames num frames
function UntzSoundMgr:init(sampleRate, numFrames)
    if not MOAIUntzSystem._initialized then
        sampleRate = sampleRate or UntzSoundMgr.SAMPLE_RATE
        numFrames = numFrames or UntzSoundMgr.NUM_FRAMES
        MOAIUntzSystem.initialize(sampleRate, numFrames)
        MOAIUntzSystem._initialized = true
    end
    
    self._soundMap = {}
end

---
-- Load the MOAIUntzSound.
-- @param filePath file path.
-- @return sound
function UntzSoundMgr:loadSound(filePath)
    local sound = MOAIUntzSound.new()
    sound:load(filePath)
    sound:setVolume(1)
    sound:setLooping(false)
    return sound
end

---
-- Return the MOAIUntzSound cached.
-- @param filePath file path.
-- @return sound
function UntzSoundMgr:getSound(filePath)
    filePath = Resources.getResourceFilePath(filePath)
    
    if not self._soundMap[filePath] then
        self._soundMap[filePath] = self:loadSound(filePath)
    end
    
    return self._soundMap[filePath]
end

---
-- Release the MOAIUntzSound.
-- @param filePath file path.
-- @return cached sound.
function UntzSoundMgr:release(filePath)
    local sound = self._soundMap[filePath]
    self._soundMap[filePath] = nil
    return sound
end

---
-- Play the sound.
-- @param sound file path or object.
-- @param volume (Optional)volume. Default value is 1.
-- @param looping (Optional)looping flag. Default value is 'false'.
-- @return Sound object
function UntzSoundMgr:play(sound, volume, looping)
    sound = type(sound) == "string" and self:getSound(sound) or sound
    volume = volume or 1
    looping = looping and true or false
    
    sound:setVolume(volume)
    sound:setLooping(looping)
    sound:play()
    return sound
end

---
-- Pause the sound.
-- @param sound file path or object.
function UntzSoundMgr:pause(sound)
    sound = type(sound) == "string" and self:getSound(sound) or sound
    sound:pause()
end

---
-- Stop the sound.
-- @param sound file path or object.
function UntzSoundMgr:stop(sound)
    sound = type(sound) == "string" and self:getSound(sound) or sound
    sound:stop()
end

---
-- Set the system level volume.
-- @param volume
function UntzSoundMgr:setVolume(volume)
   MOAIUntzSystem.setVolume(volume)
end

---
-- Return the system level volume.
-- @return volume
function UntzSoundMgr:getVolume()
   return MOAIUntzSystem.getVolume()
end

return UntzSoundMgr
