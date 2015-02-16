----------------------------------------------------------------------------------------------------
-- Skeletal implementation of SoundMgr.
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.lang.class"

-- class
local BaseSoundMgr = class()

---
-- Constructor.
function BaseSoundMgr:init()
end

function BaseSoundMgr:loadSound(filePath)
end

function BaseSoundMgr:getSound(filePath)
end

function BaseSoundMgr:play(sound, volume, looping)
end

function BaseSoundMgr:pause(sound)
end

function BaseSoundMgr:stop(sound)
end

function BaseSoundMgr:setVolume(volume)
end

function BaseSoundMgr:getVolume()
end

return BaseSoundMgr
