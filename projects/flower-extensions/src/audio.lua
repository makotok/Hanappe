----------------------------------------------------------------------------------------------------
-- Audio library.
-- 
-- @author Makoto
----------------------------------------------------------------------------------------------------

-- module
local M = {}

-- import
local flower = require "flower"
local class = flower.class
local Resources = flower.Resources

-- classes
local SoundMgr

function M.init()
    M._soundMgr = SoundMgr()
end

function M.play(sound)
    local sound = M._soundMgr:getSound(soundFileName)
    
end

function M.stop(soundName)

end

function M.getSoundMgr()
    return M._soundMgr
end

----------------------------------------------------------------------------------------------------
-- @type SoundMgr
-- 
-- Sound manager.
----------------------------------------------------------------------------------------------------
SoundMgr = class()
M.SoundMgr = SoundMgr

function SoundMgr:init()
    if not MOAIUntzSystem._initialized then
        MOAIUntzSystem.initialize()
        MOAIUntzSystem._initialized = true
    end
    
    self._soundMap = {}
    
end

function SoundMgr:loadSound(filePath)
    local sound = MOAIUntzSound.new()
    sound:load(filePath)
    sound:setVolume(1)
    sound:setLooping(false)
    return sound
end

function SoundMgr:getSound(filePath)
    filePath = Resources.getResourceFilePath(filePath)
    
    if not self._soundMap[filePath] then
        self._soundMap[filePath] = self:loadSound(filePath)
    end
    
    return self._soundMap[filePath]
end



return M
