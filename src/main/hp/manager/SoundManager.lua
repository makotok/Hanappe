----------------------------------------------------------------
-- This is a class to manage the MOAIUntzSound.<br>
-- 
-- @auther Makoto
-- @class table
-- @name SoundManager
----------------------------------------------------------------

local M = {}
local cache = {}

local initialized = false

function M.initialize()
    if not initialized then
        MOAIUntzSystem.initialize()
        initialized = true
    end
end

----------------------------------------------------------------
-- Returns the untz sound. <br>
-- @param path path
-- @return MOAIUntzSound instance.
----------------------------------------------------------------
function M.getSound(path, volume, looping)
    if not initialized then
        M.initialize()
    end

    if cache[path] == nil then
        local sound = MOAIUntzSound.new()
        sound:load(path)
        sound:setVolume(1)
        sound:setLooping(false)
        cache[path] = sound
    end
    
    local sound = cache[path]
    if volume then
        sound:setVolume(volume)
    end
    if looping then
        sound:setLooping(looping)
    end
    return sound
end

return M